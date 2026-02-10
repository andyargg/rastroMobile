import type { VercelRequest, VercelResponse } from '@vercel/node';
import { scrapeAndreani } from '../lib/andreani-scraper';
import { scrapeCorreoArgentino } from '../lib/correo-argentino';

// cors headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

// supported couriers
const SUPPORTED_COURIERS = ['andreani', 'correo_argentino', 'correo'];

export default async function handler(req: VercelRequest, res: VercelResponse) {
  // handle preflight
  if (req.method === 'OPTIONS') {
    return res.status(200).json({});
  }

  // set cors headers
  Object.entries(corsHeaders).forEach(([key, value]) => {
    res.setHeader(key, value);
  });

  // only allow GET
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { id, courier, debug } = req.query;

  // validate params
  if (!id || typeof id !== 'string') {
    return res.status(400).json({ error: 'Missing tracking id parameter' });
  }

  if (!courier || typeof courier !== 'string') {
    return res.status(400).json({
      error: 'Missing courier parameter',
      supported: SUPPORTED_COURIERS
    });
  }

  const courierLower = courier.toLowerCase();

  try {
    let result;

    switch (courierLower) {
      case 'andreani':
        result = await scrapeAndreani(id, debug === 'true');
        break;
      case 'correo_argentino':
      case 'correo':
        result = await scrapeCorreoArgentino(id);
        break;
      default:
        return res.status(400).json({
          error: `Unsupported courier: ${courier}`,
          supported: SUPPORTED_COURIERS
        });
    }

    // remove raw html from response unless debug mode
    if (!debug && result.rawHtml) {
      delete result.rawHtml;
    }

    return res.status(result.success ? 200 : 404).json(result);

  } catch (error) {
    console.error('Track API error:', error);
    return res.status(500).json({
      success: false,
      error: error instanceof Error ? error.message : 'Internal server error'
    });
  }
}
