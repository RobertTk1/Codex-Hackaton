#!/usr/bin/env python3
"""Build the Magic Mirror production logo package from approved raster masters.

The ImageGen masters establish the approved geometry. This exporter isolates that
geometry, applies exact brand colors, traces editable SVG paths, and creates the
PNG/PDF/favicon size matrix without asking an image model to redraw each variant.
"""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
import io
import json
import math
from pathlib import Path
import struct
import subprocess

import numpy as np
from PIL import Image, ImageFilter


BRAND_ROOT = Path(__file__).resolve().parents[1]
MASTERS_ROOT = BRAND_ROOT / "masters"
EXPORT_ROOT = BRAND_ROOT / "exports"

COLORS = {
    "acid": "#D7FF3F",
    "deep": "#263300",
    "pale": "#F2FFD0",
    "ink": "#17171A",
    "white": "#FFFFFF",
    "cloud": "#F4F3F1",
    "black": "#000000",
}

MARK_COLORS = ("acid", "ink", "deep", "white", "black")

TREATMENTS = {
    "primary-ink-on-acid": ("ink", "acid"),
    "dark-acid-on-ink": ("acid", "ink"),
    "soft-deep-on-pale": ("deep", "pale"),
    "light-ink-on-white": ("ink", "white"),
    "mono-black-on-white": ("black", "white"),
    "mono-white-on-black": ("white", "black"),
}


@dataclass(frozen=True)
class MarkSpec:
    name: str
    source: str
    sizes: tuple[int, ...]
    square: bool = False


MARKS = (
    MarkSpec(
        name="wordmark",
        source="magic-mirror-wordmark-imagegen.png",
        sizes=(2048, 1024, 512, 256),
    ),
    MarkSpec(
        name="combined",
        source="magic-mirror-combined-imagegen.png",
        sizes=(2048, 1024, 512, 256),
    ),
    MarkSpec(
        name="icon",
        source="magic-mirror-icon-imagegen.png",
        sizes=(1024, 512, 256, 180, 128, 64, 48, 32, 16),
        square=True,
    ),
)


def hex_rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    return tuple(int(value[index : index + 2], 16) for index in (0, 2, 4))


def isolate_mark(source: Path, square: bool) -> tuple[np.ndarray, np.ndarray]:
    """Return a soft alpha canvas and a binary canvas for vector tracing."""

    rgb = np.asarray(Image.open(source).convert("RGB"), dtype=np.float32)
    green = rgb[:, :, 1]

    border = np.concatenate(
        (
            green[:24, :].ravel(),
            green[-24:, :].ravel(),
            green[:, :24].ravel(),
            green[:, -24:].ravel(),
        )
    )
    background_green = float(np.median(border))
    low = max(background_green + 16.0, 36.0)
    high = 190.0
    alpha = np.clip((green - low) / (high - low), 0.0, 1.0)
    binary = alpha >= 0.48

    ys, xs = np.where(binary)
    if len(xs) == 0:
        raise ValueError(f"No mark detected in {source}")

    x0, x1 = int(xs.min()), int(xs.max()) + 1
    y0, y1 = int(ys.min()), int(ys.max()) + 1
    cropped_alpha = alpha[y0:y1, x0:x1]
    cropped_binary = binary[y0:y1, x0:x1]
    mark_height, mark_width = cropped_alpha.shape

    if square:
        clear_space = int(math.ceil(max(mark_width, mark_height) * 0.14))
        side = max(mark_width, mark_height) + 2 * clear_space
        canvas_alpha = np.zeros((side, side), dtype=np.float32)
        canvas_binary = np.zeros((side, side), dtype=bool)
        offset_x = (side - mark_width) // 2
        offset_y = (side - mark_height) // 2
    else:
        clear_space = int(math.ceil(mark_height * 0.12))
        canvas_height = mark_height + 2 * clear_space
        canvas_width = mark_width + 2 * clear_space
        canvas_alpha = np.zeros((canvas_height, canvas_width), dtype=np.float32)
        canvas_binary = np.zeros((canvas_height, canvas_width), dtype=bool)
        offset_x = clear_space
        offset_y = clear_space

    canvas_alpha[
        offset_y : offset_y + mark_height,
        offset_x : offset_x + mark_width,
    ] = cropped_alpha
    canvas_binary[
        offset_y : offset_y + mark_height,
        offset_x : offset_x + mark_width,
    ] = cropped_binary
    return canvas_alpha, canvas_binary


def boundary_loops(mask: np.ndarray) -> list[list[tuple[int, int]]]:
    """Trace foreground pixel boundaries as closed loops."""

    height, width = mask.shape
    adjacency: dict[tuple[int, int], list[tuple[int, int]]] = defaultdict(list)

    for y, x in np.argwhere(mask):
        y = int(y)
        x = int(x)
        if y == 0 or not mask[y - 1, x]:
            adjacency[(x, y)].append((x + 1, y))
        if x == width - 1 or not mask[y, x + 1]:
            adjacency[(x + 1, y)].append((x + 1, y + 1))
        if y == height - 1 or not mask[y + 1, x]:
            adjacency[(x + 1, y + 1)].append((x, y + 1))
        if x == 0 or not mask[y, x - 1]:
            adjacency[(x, y + 1)].append((x, y))

    direction_index = {(1, 0): 0, (0, 1): 1, (-1, 0): 2, (0, -1): 3}
    turn_priority = {1: 0, 0: 1, 3: 2, 2: 3}
    loops: list[list[tuple[int, int]]] = []

    while adjacency:
        start = next(iter(adjacency))
        previous = start
        current = adjacency[start].pop()
        if not adjacency[start]:
            del adjacency[start]
        loop = [start, current]

        while current != start:
            candidates = adjacency.get(current)
            if not candidates:
                break
            old_direction = (
                current[0] - previous[0],
                current[1] - previous[1],
            )
            old_index = direction_index[old_direction]

            def rank(candidate: tuple[int, int]) -> int:
                new_direction = (
                    candidate[0] - current[0],
                    candidate[1] - current[1],
                )
                new_index = direction_index[new_direction]
                return turn_priority[(new_index - old_index) % 4]

            candidate_index = min(range(len(candidates)), key=lambda i: rank(candidates[i]))
            next_point = candidates.pop(candidate_index)
            if not candidates:
                del adjacency[current]
            previous, current = current, next_point
            loop.append(current)

        if current == start and len(loop) >= 5:
            loops.append(loop[:-1])

    return loops


def perpendicular_distance(
    point: tuple[int, int],
    start: tuple[int, int],
    end: tuple[int, int],
) -> float:
    if start == end:
        return math.dist(point, start)
    x, y = point
    x1, y1 = start
    x2, y2 = end
    numerator = abs((y2 - y1) * x - (x2 - x1) * y + x2 * y1 - y2 * x1)
    denominator = math.hypot(y2 - y1, x2 - x1)
    return numerator / denominator


def rdp(points: list[tuple[int, int]], epsilon: float) -> list[tuple[int, int]]:
    if len(points) < 3:
        return points
    farthest_index = 0
    farthest_distance = 0.0
    for index in range(1, len(points) - 1):
        distance = perpendicular_distance(points[index], points[0], points[-1])
        if distance > farthest_distance:
            farthest_index = index
            farthest_distance = distance
    if farthest_distance > epsilon:
        left = rdp(points[: farthest_index + 1], epsilon)
        right = rdp(points[farthest_index:], epsilon)
        return left[:-1] + right
    return [points[0], points[-1]]


def simplify_loop(loop: list[tuple[int, int]], epsilon: float = 1.35) -> list[tuple[int, int]]:
    if len(loop) < 4:
        return loop

    reduced: list[tuple[int, int]] = []
    for point in loop:
        if len(reduced) < 2:
            reduced.append(point)
            continue
        a, b = reduced[-2], reduced[-1]
        if (b[0] - a[0], b[1] - a[1]) == (
            point[0] - b[0],
            point[1] - b[1],
        ):
            reduced[-1] = point
        else:
            reduced.append(point)

    anchor_index = min(range(len(reduced)), key=lambda i: (reduced[i][0], reduced[i][1]))
    rotated = reduced[anchor_index:] + reduced[:anchor_index]
    simplified = rdp(rotated + [rotated[0]], epsilon)
    return simplified[:-1]


def svg_path(mask: np.ndarray) -> str:
    paths: list[str] = []
    for loop in boundary_loops(mask):
        simplified = simplify_loop(loop)
        if len(simplified) < 3:
            continue
        commands = [f"M {simplified[0][0]} {simplified[0][1]}"]
        commands.extend(f"L {x} {y}" for x, y in simplified[1:])
        commands.append("Z")
        paths.append(" ".join(commands))
    return " ".join(paths)


def write_svg(mark: str, mask: np.ndarray, color_name: str, path_data: str) -> Path:
    height, width = mask.shape
    color = COLORS[color_name]
    output_dir = EXPORT_ROOT / mark / "svg"
    output_dir.mkdir(parents=True, exist_ok=True)
    output = output_dir / f"magic-mirror-{mark}-{color_name}.svg"
    svg = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" '
        f'role="img" aria-labelledby="title">\n'
        f'  <title id="title">Magic Mirror {mark} — {color_name}</title>\n'
        f'  <path fill="{color}" fill-rule="evenodd" d="{path_data}"/>\n'
        '</svg>\n'
    )
    output.write_text(svg, encoding="utf-8")
    return output


def write_pdf(svg: Path, mark: str, color_name: str) -> Path:
    output_dir = EXPORT_ROOT / mark / "pdf"
    output_dir.mkdir(parents=True, exist_ok=True)
    output = output_dir / f"magic-mirror-{mark}-{color_name}.pdf"
    subprocess.run(
        ["rsvg-convert", "-f", "pdf", "-o", str(output), str(svg)],
        check=True,
    )
    return output


def colored_image(alpha: np.ndarray, color_name: str) -> Image.Image:
    height, width = alpha.shape
    rgba = np.empty((height, width, 4), dtype=np.uint8)
    rgba[:, :, :3] = hex_rgb(COLORS[color_name])
    rgba[:, :, 3] = np.rint(alpha * 255.0).astype(np.uint8)
    return Image.fromarray(rgba, mode="RGBA")


def resize_mark(image: Image.Image, size: int, square: bool) -> Image.Image:
    if square:
        return image.resize((size, size), Image.Resampling.LANCZOS)
    width, height = image.size
    target_height = max(1, round(height * size / width))
    return image.resize((size, target_height), Image.Resampling.LANCZOS)


def force_exact_color(image: Image.Image, color_name: str) -> Image.Image:
    """Restore exact visible RGB after RGBA resampling changes edge RGB values."""

    rgba = np.asarray(image.convert("RGBA")).copy()
    visible = rgba[:, :, 3] > 0
    rgba[visible, :3] = hex_rgb(COLORS[color_name])
    return Image.fromarray(rgba, mode="RGBA")


def write_pngs(
    mark: MarkSpec,
    alpha: np.ndarray,
    color_name: str,
    small_use_alpha: np.ndarray | None = None,
) -> list[Path]:
    source = colored_image(alpha, color_name)
    outputs: list[Path] = []
    output_dir = EXPORT_ROOT / mark.name / "png" / "transparent" / color_name
    output_dir.mkdir(parents=True, exist_ok=True)
    for size in mark.sizes:
        size_source = source
        if mark.name == "icon" and size <= 16 and small_use_alpha is not None:
            size_source = colored_image(small_use_alpha, color_name)
        resized = force_exact_color(
            resize_mark(size_source, size, mark.square),
            color_name,
        )
        output = output_dir / f"magic-mirror-{mark.name}-{color_name}-{size}px.png"
        resized.save(output, optimize=True)
        outputs.append(output)
    return outputs


def write_treatments(mark: MarkSpec, alpha: np.ndarray) -> list[Path]:
    outputs: list[Path] = []
    output_dir = EXPORT_ROOT / mark.name / "png" / "treatments"
    output_dir.mkdir(parents=True, exist_ok=True)
    preview_size = 512 if mark.square else 1024

    for treatment, (mark_color, background_color) in TREATMENTS.items():
        foreground = force_exact_color(
            resize_mark(colored_image(alpha, mark_color), preview_size, mark.square),
            mark_color,
        )
        background = Image.new("RGBA", foreground.size, hex_rgb(COLORS[background_color]) + (255,))
        background.alpha_composite(foreground)
        output = output_dir / f"magic-mirror-{mark.name}-{treatment}.png"
        background.convert("RGB").save(output, optimize=True)
        outputs.append(output)
    return outputs


def small_use_icon(alpha: np.ndarray) -> np.ndarray:
    """Keep the two lens halves and omit focus corners for the 16px favicon."""

    mask = alpha >= 0.48
    height, width = mask.shape
    seen = np.zeros_like(mask, dtype=bool)
    components: list[list[tuple[int, int]]] = []

    for start_y, start_x in np.argwhere(mask):
        start_y = int(start_y)
        start_x = int(start_x)
        if seen[start_y, start_x]:
            continue
        stack = [(start_y, start_x)]
        seen[start_y, start_x] = True
        component: list[tuple[int, int]] = []
        while stack:
            y, x = stack.pop()
            component.append((y, x))
            for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                ny, nx = y + dy, x + dx
                if (
                    0 <= ny < height
                    and 0 <= nx < width
                    and mask[ny, nx]
                    and not seen[ny, nx]
                ):
                    seen[ny, nx] = True
                    stack.append((ny, nx))
        components.append(component)

    keep = np.zeros_like(mask, dtype=np.uint8)
    for component in sorted(components, key=len, reverse=True)[:2]:
        for y, x in component:
            keep[y, x] = 255

    expanded = np.asarray(
        Image.fromarray(keep, mode="L").filter(ImageFilter.MaxFilter(5)),
        dtype=np.float32,
    ) / 255.0
    isolated = alpha * expanded
    ys, xs = np.where(isolated > 0.02)
    x0, x1 = int(xs.min()), int(xs.max()) + 1
    y0, y1 = int(ys.min()), int(ys.max()) + 1
    crop = isolated[y0:y1, x0:x1]
    side = int(math.ceil(max(crop.shape) * 1.22))
    canvas = np.zeros((side, side), dtype=np.float32)
    offset_y = (side - crop.shape[0]) // 2
    offset_x = (side - crop.shape[1]) // 2
    canvas[offset_y : offset_y + crop.shape[0], offset_x : offset_x + crop.shape[1]] = crop
    return canvas


def write_ico(frames: list[Image.Image], output: Path) -> None:
    png_payloads: list[bytes] = []
    for frame in frames:
        buffer = io.BytesIO()
        frame.save(buffer, format="PNG", optimize=True)
        png_payloads.append(buffer.getvalue())

    header_size = 6 + 16 * len(frames)
    offset = header_size
    entries: list[bytes] = []
    for frame, payload in zip(frames, png_payloads):
        width, height = frame.size
        entries.append(
            struct.pack(
                "<BBBBHHII",
                0 if width == 256 else width,
                0 if height == 256 else height,
                0,
                0,
                1,
                32,
                len(payload),
                offset,
            )
        )
        offset += len(payload)

    output.write_bytes(
        struct.pack("<HHH", 0, 1, len(frames))
        + b"".join(entries)
        + b"".join(png_payloads)
    )


def write_favicons(alpha: np.ndarray, small_use_alpha: np.ndarray) -> list[Path]:
    output_dir = EXPORT_ROOT / "icon" / "favicon"
    output_dir.mkdir(parents=True, exist_ok=True)
    foreground = colored_image(alpha, "acid")
    outputs: list[Path] = []
    icon_frames: list[Image.Image] = []

    for size in (16, 32, 48):
        source = colored_image(small_use_alpha, "acid") if size == 16 else foreground
        mark = force_exact_color(
            source.resize((size, size), Image.Resampling.LANCZOS),
            "acid",
        )
        frame = Image.new("RGBA", (size, size), hex_rgb(COLORS["ink"]) + (255,))
        frame.alpha_composite(mark)
        output = output_dir / f"favicon-{size}x{size}.png"
        frame.save(output, optimize=True)
        outputs.append(output)
        icon_frames.append(frame)

    ico = output_dir / "favicon.ico"
    write_ico(icon_frames, ico)
    outputs.append(ico)

    apple_mark = force_exact_color(
        foreground.resize((180, 180), Image.Resampling.LANCZOS),
        "acid",
    )
    apple = Image.new("RGBA", (180, 180), hex_rgb(COLORS["ink"]) + (255,))
    apple.alpha_composite(apple_mark)
    apple_path = output_dir / "apple-touch-icon-180x180.png"
    apple.save(apple_path, optimize=True)
    outputs.append(apple_path)
    return outputs


def main() -> None:
    EXPORT_ROOT.mkdir(parents=True, exist_ok=True)
    manifest: dict[str, object] = {
        "brand": "Magic Mirror",
        "year": 2026,
        "palette": COLORS,
        "treatments": TREATMENTS,
        "marks": {},
    }

    icon_alpha: np.ndarray | None = None
    icon_small_alpha: np.ndarray | None = None
    for mark in MARKS:
        alpha, binary = isolate_mark(MASTERS_ROOT / mark.source, mark.square)
        small_alpha = small_use_icon(alpha) if mark.name == "icon" else None
        path_data = svg_path(binary)
        files: list[str] = []
        for color_name in MARK_COLORS:
            svg = write_svg(mark.name, binary, color_name, path_data)
            files.append(str(svg.relative_to(BRAND_ROOT)))
            pdf = write_pdf(svg, mark.name, color_name)
            files.append(str(pdf.relative_to(BRAND_ROOT)))
            files.extend(
                str(path.relative_to(BRAND_ROOT))
                for path in write_pngs(mark, alpha, color_name, small_alpha)
            )
        files.extend(
            str(path.relative_to(BRAND_ROOT))
            for path in write_treatments(mark, alpha)
        )
        manifest["marks"][mark.name] = {
            "source": f"masters/{mark.source}",
            "sizes": mark.sizes,
            "files": sorted(files),
        }
        if mark.name == "icon":
            icon_alpha = alpha
            icon_small_alpha = small_alpha

    if icon_alpha is None or icon_small_alpha is None:
        raise RuntimeError("Icon master was not exported")
    favicon_files = write_favicons(icon_alpha, icon_small_alpha)
    manifest["favicon_files"] = [
        str(path.relative_to(BRAND_ROOT)) for path in favicon_files
    ]

    manifest_path = EXPORT_ROOT / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {len(list(EXPORT_ROOT.rglob('*')))} package entries to {EXPORT_ROOT}")


if __name__ == "__main__":
    main()
