import express from 'express';
import { scrapeAndreani } from './lib/andreani-scraper';

const app = express();
const PORT = process.env.PORT || 3000;

// health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

// tracking endpoint
app.get('/api/track', async (req, res) => {
  const { id, courier, debug } = req.query;

  if (!id || typeof id !== 'string') {
    return res.status(400).json({
      success: false,
      error: 'Missing tracking id parameter'
    });
  }

  const courierName = (courier as string)?.toLowerCase() || 'andreani';

  try {
    if (courierName === 'andreani') {
      const result = await scrapeAndreani(id, debug === 'true');
      return res.json(result);
    }

    return res.status(400).json({
      success: false,
      error: `Courier "${courierName}" not supported`
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: error instanceof Error ? error.message : 'Internal server error'
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
