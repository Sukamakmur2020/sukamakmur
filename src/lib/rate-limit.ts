// In-memory rate limiter using a Map. 
// Note: In a serverless environment (like Vercel), this state is kept per-instance 
// and may reset when instances scale down, but it's effective for preventing rapid burst spam.

type RateLimitEntry = {
  count: number;
  resetAt: number;
};

const rateLimitMap = new Map<string, RateLimitEntry>();

export function checkRateLimit(ip: string, limit: number, windowMs: number): { success: boolean; headers: Record<string, string> } {
  const now = Date.now();
  const entry = rateLimitMap.get(ip);

  // Clean up expired entries occasionally (basic garbage collection to prevent memory leaks)
  if (rateLimitMap.size > 1000) {
    for (const [key, val] of rateLimitMap.entries()) {
      if (now > val.resetAt) rateLimitMap.delete(key);
    }
  }

  if (!entry || now > entry.resetAt) {
    rateLimitMap.set(ip, { count: 1, resetAt: now + windowMs });
    return {
      success: true,
      headers: {
        'X-RateLimit-Limit': limit.toString(),
        'X-RateLimit-Remaining': (limit - 1).toString(),
        'X-RateLimit-Reset': new Date(now + windowMs).toISOString(),
      },
    };
  }

  if (entry.count >= limit) {
    return {
      success: false,
      headers: {
        'X-RateLimit-Limit': limit.toString(),
        'X-RateLimit-Remaining': '0',
        'X-RateLimit-Reset': new Date(entry.resetAt).toISOString(),
      },
    };
  }

  entry.count += 1;
  return {
    success: true,
    headers: {
      'X-RateLimit-Limit': limit.toString(),
      'X-RateLimit-Remaining': (limit - entry.count).toString(),
      'X-RateLimit-Reset': new Date(entry.resetAt).toISOString(),
    },
  };
}
