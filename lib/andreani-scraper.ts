import puppeteerCore from 'puppeteer-core';

// tracking event structure
export interface TrackingEvent {
  date: string;
  time: string;
  status: string;
  location: string;
  description: string;
}

// tracking response structure
export interface TrackingResponse {
  success: boolean;
  courier: string;
  trackingNumber: string;
  status: string;
  events: TrackingEvent[];
  error?: string;
  rawHtml?: string; // for debugging
}

const ANDREANI_URL = 'https://www.andreani.com/envio';

// chrome user agent to avoid bot detection
const USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

// get browser instance based on environment
async function getBrowser() {
  const chromePath = process.env.PUPPETEER_EXECUTABLE_PATH;

  // render/docker: use system chromium
  if (chromePath) {
    return puppeteerCore.launch({
      executablePath: chromePath,
      headless: true,
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu'
      ]
    });
  }

  // local: use full puppeteer
  const puppeteer = await import('puppeteer');
  return puppeteer.default.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
}

// scrape andreani tracking page
// [Unverified] css selectors need to be confirmed with real page inspection
export async function scrapeAndreani(trackingNumber: string, debug = false): Promise<TrackingResponse> {
  let browser = null;

  try {
    browser = await getBrowser();
    const page = await browser.newPage();

    // set user agent to avoid bot detection
    await page.setUserAgent(USER_AGENT);
    page.setDefaultNavigationTimeout(25000);

    // block unnecessary resources to speed up loading
    await page.setRequestInterception(true);
    page.on('request', (req) => {
      const blockedTypes = ['image', 'stylesheet', 'font', 'media'];
      if (blockedTypes.includes(req.resourceType())) {
        req.abort();
      } else {
        req.continue();
      }
    });

    await page.goto(`${ANDREANI_URL}/${trackingNumber}`, {
      waitUntil: 'networkidle0' // wait until no network activity
    });

    // wait for page content to render (next.js hydration)
    await page.waitForFunction(
      () => document.body.innerText.length > 200,
      { timeout: 15000 }
    ).catch(() => null);

    // extra wait for slow javascript rendering
    await new Promise(r => setTimeout(r, 3000));

    // [Unverified] selectors based on common patterns, need real page inspection
    const events = await page.evaluate(() => {
      // try multiple selector patterns
      const selectors = [
        '[class*="timeline"] > div',
        '[class*="timeline-item"]',
        '[class*="tracking"] li',
        '[class*="evento"]',
        '[class*="step"]',
        '[class*="estado-item"]',
        '[class*="history"] > div',
        '[class*="movimiento"]'
      ];

      let items: Element[] = [];
      for (const sel of selectors) {
        const found = document.querySelectorAll(sel);
        if (found.length > 0) {
          items = Array.from(found);
          break;
        }
      }

      return items.map(el => ({
        date: el.querySelector('[class*="date"], [class*="fecha"]')?.textContent?.trim() || '',
        time: el.querySelector('[class*="time"], [class*="hora"]')?.textContent?.trim() || '',
        status: el.querySelector('[class*="status"], [class*="estado"], [class*="title"], h3, h4')?.textContent?.trim() || '',
        location: el.querySelector('[class*="location"], [class*="lugar"], [class*="sucursal"], [class*="direccion"]')?.textContent?.trim() || '',
        description: el.textContent?.trim().substring(0, 500) || '' // limit length
      }));
    });

    // get current status from page header
    const currentStatus = await page.evaluate(() => {
      const statusEl = document.querySelector(
        '[class*="estado-actual"], [class*="current-status"], [class*="status-main"], h1, h2'
      );
      return statusEl?.textContent?.trim() || '';
    });

    // check if tracking not found
    const notFound = await page.evaluate(() => {
      const text = document.body.textContent?.toLowerCase() || '';
      return text.includes('no encontr') ||
             text.includes('no existe') ||
             text.includes('not found') ||
             text.includes('número inválido');
    });

    // get raw html for debugging if needed
    const rawHtml = debug ? await page.content() : undefined;

    if (notFound || events.length === 0) {
      return {
        success: false,
        courier: 'andreani',
        trackingNumber,
        status: 'not_found',
        events: [],
        error: 'Tracking not found or no events available',
        rawHtml
      };
    }

    return {
      success: true,
      courier: 'andreani',
      trackingNumber,
      status: currentStatus || events[0]?.status || 'unknown',
      events,
      rawHtml
    };

  } catch (error) {
    return {
      success: false,
      courier: 'andreani',
      trackingNumber,
      status: 'error',
      events: [],
      error: error instanceof Error ? error.message : 'Scraping failed'
    };
  } finally {
    if (browser) await browser.close();
  }
}
