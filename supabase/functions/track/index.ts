import "@supabase/functions-js/edge-runtime.d.ts";

const BACKEND_URL = "https://rastro-back.onrender.com";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  // handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  const apiKey = Deno.env.get("RASTRO_API_KEY");
  if (!apiKey) {
    return new Response(JSON.stringify({ error: "Server misconfiguration" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  try {
    const { tracking_number, courier } = await req.json();

    if (!tracking_number || !courier) {
      return new Response(
        JSON.stringify({ error: "tracking_number and courier are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const url = `${BACKEND_URL}/api/track?id=${encodeURIComponent(tracking_number)}&courier=${encodeURIComponent(courier)}`;

    const backendRes = await fetch(url, {
      headers: { "x-api-key": apiKey },
    });

    const data = await backendRes.json();

    // Always return 200 from the proxy — the tracking result's
    // "success" field already indicates whether tracking was found.
    // This avoids FunctionException in the Flutter client for 404s.
    return new Response(JSON.stringify(data), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(
      JSON.stringify({ error: `Proxy error: ${e.message}` }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
