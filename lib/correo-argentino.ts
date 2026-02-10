import type { TrackingEvent, TrackingResponse } from './andreani-scraper';

// correo argentino api endpoint
// [Inference] based on common correo argentino tracking patterns
const CORREO_API_URL = 'https://www.correoargentino.com.ar/formularios/ondnc';

// user agent for requests
const USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

// parse date string to standardized format
function parseDate(dateStr: string): { date: string; time: string } {
  const cleaned = dateStr.trim();
  // try to extract date and time parts
  const match = cleaned.match(/(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4})\s*(\d{1,2}:\d{2})?/);
  return {
    date: match?.[1] || cleaned,
    time: match?.[2] || ''
  };
}

// scrape correo argentino using their tracking api
// [Unverified] api endpoint and response format need verification
export async function scrapeCorreoArgentino(trackingNumber: string): Promise<TrackingResponse> {
  try {
    // correo argentino uses a form-based api
    const formData = new URLSearchParams();
    formData.append('id', trackingNumber);

    const response = await fetch(CORREO_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': USER_AGENT,
        'Accept': 'application/json, text/html, */*',
        'Origin': 'https://www.correoargentino.com.ar',
        'Referer': 'https://www.correoargentino.com.ar/seguimiento'
      },
      body: formData.toString()
    });

    if (!response.ok) {
      return {
        success: false,
        courier: 'correo_argentino',
        trackingNumber,
        status: 'error',
        events: [],
        error: `HTTP error: ${response.status}`
      };
    }

    const contentType = response.headers.get('content-type') || '';

    // try to parse as json first
    if (contentType.includes('application/json')) {
      const data = await response.json();
      return parseJsonResponse(data, trackingNumber);
    }

    // fallback to html parsing
    const html = await response.text();
    return parseHtmlResponse(html, trackingNumber);

  } catch (error) {
    return {
      success: false,
      courier: 'correo_argentino',
      trackingNumber,
      status: 'error',
      events: [],
      error: error instanceof Error ? error.message : 'Request failed'
    };
  }
}

// parse json api response
// [Unverified] structure based on common patterns
function parseJsonResponse(data: unknown, trackingNumber: string): TrackingResponse {
  // handle array response
  const records = Array.isArray(data) ? data : (data as Record<string, unknown>)?.data;

  if (!records || !Array.isArray(records) || records.length === 0) {
    return {
      success: false,
      courier: 'correo_argentino',
      trackingNumber,
      status: 'not_found',
      events: [],
      error: 'No tracking data found'
    };
  }

  const events: TrackingEvent[] = records.map((item: Record<string, unknown>) => {
    const { date, time } = parseDate(String(item.fecha || item.date || ''));
    return {
      date,
      time,
      status: String(item.estado || item.status || item.descripcion || ''),
      location: String(item.sucursal || item.location || item.planta || ''),
      description: String(item.descripcion || item.description || item.motivo || '')
    };
  });

  return {
    success: true,
    courier: 'correo_argentino',
    trackingNumber,
    status: events[0]?.status || 'unknown',
    events
  };
}

// parse html response using regex (no cheerio dependency)
// [Unverified] html structure needs verification
function parseHtmlResponse(html: string, trackingNumber: string): TrackingResponse {
  const events: TrackingEvent[] = [];

  // look for table rows with tracking data
  const rowRegex = /<tr[^>]*>[\s\S]*?<\/tr>/gi;
  const cellRegex = /<td[^>]*>([\s\S]*?)<\/td>/gi;
  const rows = html.match(rowRegex) || [];

  for (const row of rows) {
    const cells: string[] = [];
    let cellMatch;
    while ((cellMatch = cellRegex.exec(row)) !== null) {
      // strip html tags
      const text = cellMatch[1].replace(/<[^>]*>/g, '').trim();
      cells.push(text);
    }
    cellRegex.lastIndex = 0;

    if (cells.length >= 3) {
      const { date, time } = parseDate(cells[0]);
      events.push({
        date,
        time,
        status: cells[1] || '',
        location: cells[2] || '',
        description: cells.slice(1).join(' - ')
      });
    }
  }

  // check for not found message
  if (html.toLowerCase().includes('no se encontr') ||
      html.toLowerCase().includes('sin resultados') ||
      events.length === 0) {
    return {
      success: false,
      courier: 'correo_argentino',
      trackingNumber,
      status: 'not_found',
      events: [],
      error: 'Tracking not found'
    };
  }

  return {
    success: true,
    courier: 'correo_argentino',
    trackingNumber,
    status: events[0]?.status || 'unknown',
    events
  };
}
