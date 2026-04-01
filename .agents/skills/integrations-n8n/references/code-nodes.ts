/**
 * n8n Supreme Code Guide (JS & Python)
 * 
 * Expert guidance for writing high-performance, robust code in n8n Code nodes.
 * JS is the RECOMMENDED language for 95% of use cases.
 */

// --- SECTION 1: JAVASCRIPT EXCELLENCE (RECOMMENDED) ---

/**
 * Basic Template: Run Once for All Items
 */
async function processData() {
  const items = $input.all(); // Access all input items
  
  const processed = items.map(item => {
    // Webhook data is ALWAYS under .body
    const data = item.json.body || item.json; 
    
    return {
      json: {
        ...data,
        processed: true,
        timestamp: DateTime.now().toISO(), // Built-in Luxon
      }
    };
  });

  return processed; // Must return Array<{json: {}}>
}

/**
 * Critical JS Helpers
 * - $helpers.httpRequest({ method: 'GET', url: '...' })
 * - DateTime (Luxon) for all date math
 * - $jmespath(object, 'path.to.data')
 */

// --- SECTION 2: PYTHON PATTERNS (BETA) ---

/**
 * Use Python ONLY IF:
 * 1. You need specific standard libs (re, hashlib, statistics).
 * 2. You are doing complex math better suited to Python.
 * 
 * LIMITATION: No external libraries (requests, pandas, etc.) are available.
 */

/*
# Python Template
from datetime import datetime

items = _input.all()
processed = []

for item in items:
    # Webhook data is under ["body"]
    data = item["json"].get("body", item["json"])
    
    processed.append({
        "json": {
            **data,
            "processed": True,
            "ts": datetime.now().isoformat()
        }
    })

return processed
*/

// --- SECTION 3: THE "SUPREMO" RULES ---

/**
 * 1. RETURN FORMAT: Always return a list of objects with a 'json' key.
 *    ✅ [{ json: { id: 1 } }]
 *    ❌ { id: 1 }
 * 
 * 2. DATA ACCESS:
 *    - JS: $input.all(), $input.first(), $input.item
 *    - Python: _input.all(), _input.first(), _input.item
 * 
 * 3. WEBHOOK NESTING:
 *    Incoming webhook data => item.json.body.field
 * 
 * 4. PERFORMANCE:
 *    - Use "Run Once for All Items" mode for bulk processing.
 *    - Use "Run Once for Each Item" ONLY if calling unique APIs per item.
 */

/**
 * 5. ERROR HANDLING:
 *    Always use try/catch or guard clauses for undefined inputs.
 */
try {
  const first = $input.first().json;
  if (!first) throw new Error("No data received");
} catch (e) {
  return [{ json: { error: e.message } }];
}
