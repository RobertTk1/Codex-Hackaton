const fs = require('fs');
const path = require('path');
const { pathToFileURL } = require('url');
const { chromium } = require('playwright');
const sharp = require('sharp');

const sourceDir = __dirname;
const packetDir = path.resolve(sourceDir, '..');
const htmlPath = path.join(sourceDir, 'brandbook.html');
const outputDir = path.join(packetDir, 'pages', 'source');
const contactSheetPath = path.join(packetDir, 'references', 't008-source-contact-sheet.png');

const outputNames = [
  'page-01-logo-dark.png',
  'page-02-logo-light.png',
  'page-03-contents.png',
  'page-04-logo-usage.png',
  'page-05-logo-avoid.png',
  'page-06-primary-colors.png',
  'page-07-secondary-colors.png',
  'page-08-buttons-links.png',
  'page-09-elements.png',
  'page-10-wcag.png',
  'page-11-business-card.png',
  'page-12-billboard.png',
  'page-13-browser-favicon.png',
  'page-14-x.png',
  'page-15-linkedin.png',
  'page-16-tshirt.png',
  'page-17-merchandise.png',
  'page-18-typography.png',
  'page-19-type-avoid.png',
];

async function render() {
  fs.mkdirSync(outputDir, { recursive: true });
  for (const name of fs.readdirSync(outputDir)) {
    if (/^page-\d{2}-.*\.png$/.test(name)) {
      fs.unlinkSync(path.join(outputDir, name));
    }
  }

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({
    viewport: { width: 1600, height: 1000 },
    deviceScaleFactor: 1,
  });

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
    });

    const pages = page.locator('section.page');
    const count = await pages.count();
    if (count !== outputNames.length) {
      throw new Error(`Expected ${outputNames.length} pages, found ${count}`);
    }

    for (let index = 0; index < count; index += 1) {
      const outputPath = path.join(outputDir, outputNames[index]);
      await pages.nth(index).screenshot({ path: outputPath, type: 'png', animations: 'disabled' });
    }
  } finally {
    await browser.close();
  }

  const thumbWidth = 320;
  const thumbHeight = 200;
  const columns = 5;
  const rows = 4;
  const composites = [];

  for (let index = 0; index < outputNames.length; index += 1) {
    const thumb = await sharp(path.join(outputDir, outputNames[index]))
      .resize(thumbWidth, thumbHeight, { fit: 'cover' })
      .png()
      .toBuffer();
    composites.push({
      input: thumb,
      left: (index % columns) * thumbWidth,
      top: Math.floor(index / columns) * thumbHeight,
    });
  }

  await sharp({
    create: {
      width: columns * thumbWidth,
      height: rows * thumbHeight,
      channels: 3,
      background: '#F4F3F1',
    },
  }).composite(composites).png().toFile(contactSheetPath);

  process.stdout.write(`Rendered ${outputNames.length} source previews and ${contactSheetPath}\n`);
}

render().catch((error) => {
  process.stderr.write(`${error.stack || error.message}\n`);
  process.exitCode = 1;
});
