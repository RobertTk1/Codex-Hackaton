const fs = require('fs');
const path = require('path');
const { pathToFileURL } = require('url');
const { spawnSync } = require('child_process');
const { chromium } = require('playwright');
const sharp = require('sharp');

const sourceDir = __dirname;
const packetDir = path.resolve(sourceDir, '..');
const htmlPath = path.join(sourceDir, 'brandbook.html');
const pdfPath = path.join(packetDir, 'Magic-Mirror-Brandbook.pdf');
const previewDir = path.join(packetDir, 'pages', 'pdf');
const contactSheetPath = path.join(packetDir, 'pages', 'contact-sheet.png');
const pdftoppm = process.env.PDFTOPPM_BIN || 'pdftoppm';

async function renderPdf() {
  fs.mkdirSync(previewDir, { recursive: true });
  for (const name of fs.readdirSync(previewDir)) {
    if (/^(?:page|_rendered)-\d+\.png$/.test(name)) {
      fs.unlinkSync(path.join(previewDir, name));
    }
  }

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1056, height: 816 }, deviceScaleFactor: 1 });
  try {
    await page.goto(pathToFileURL(htmlPath).href, { waitUntil: 'load' });
    await page.evaluate(async () => {
      await document.fonts.ready;
      await Promise.all(Array.from(document.images).map((img) => {
        if (img.complete && img.naturalWidth > 0) return Promise.resolve();
        return new Promise((resolve, reject) => {
          img.addEventListener('load', resolve, { once: true });
          img.addEventListener('error', () => reject(new Error(`Failed image: ${img.src}`)), { once: true });
        });
      }));
      if (!document.getElementById('wcag-matrix')?.children.length) {
        throw new Error('WCAG matrix did not render before PDF generation');
      }
    });
    await page.emulateMedia({ media: 'print' });
    await page.pdf({
      path: pdfPath,
      printBackground: true,
      preferCSSPageSize: true,
      displayHeaderFooter: false,
      tagged: true,
      outline: true,
    });
  } finally {
    await browser.close();
  }

  const prefix = path.join(previewDir, '_rendered');
  const result = spawnSync(pdftoppm, ['-png', '-r', '192', pdfPath, prefix], { encoding: 'utf8' });
  if (result.status !== 0) {
    throw new Error(`pdftoppm failed (${result.status}): ${result.stderr || result.stdout}`);
  }

  const rendered = fs.readdirSync(previewDir)
    .map((name) => ({ name, match: name.match(/^_rendered-(\d+)\.png$/) }))
    .filter((item) => item.match)
    .sort((first, second) => Number(first.match[1]) - Number(second.match[1]));
  if (rendered.length !== 19) {
    throw new Error(`Expected 19 rendered PDF pages, found ${rendered.length}`);
  }

  const pagePaths = [];
  for (let index = 0; index < rendered.length; index += 1) {
    const finalName = `page-${String(index + 1).padStart(2, '0')}.png`;
    const finalPath = path.join(previewDir, finalName);
    fs.renameSync(path.join(previewDir, rendered[index].name), finalPath);
    pagePaths.push(finalPath);
  }

  const thumbWidth = 264;
  const thumbHeight = 204;
  const columns = 5;
  const rows = 4;
  const composites = [];
  for (let index = 0; index < pagePaths.length; index += 1) {
    const thumb = await sharp(pagePaths[index]).resize(thumbWidth, thumbHeight, { fit: 'cover' }).png().toBuffer();
    composites.push({ input: thumb, left: (index % columns) * thumbWidth, top: Math.floor(index / columns) * thumbHeight });
  }
  await sharp({
    create: { width: columns * thumbWidth, height: rows * thumbHeight, channels: 3, background: '#F4F3F1' },
  }).composite(composites).png().toFile(contactSheetPath);

  process.stdout.write(`Rendered ${pdfPath}, ${pagePaths.length} PDF previews, and ${contactSheetPath}\n`);
}

renderPdf().catch((error) => {
  process.stderr.write(`${error.stack || error.message}\n`);
  process.exitCode = 1;
});
