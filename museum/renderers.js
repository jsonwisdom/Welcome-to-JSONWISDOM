// Deterministic mathematical artworks for JSONWisdom Museum
// Pure computation: no canvas, no floating-point nondeterminism assumptions beyond IEEE-754 double
// Output: Uint8Array of width * height * 4 RGBA bytes, fixed 200x200
// Browser-compatible. Node hashing is in compute-hashes.js

const WIDTH = 200;
const HEIGHT = 200;

function mulberry32(seed) {
  return function() {
    let t = seed += 0x6D2B79F5;
    t = Math.imul(t ^ t >>> 15, t | 1);
    t ^= t + Math.imul(t ^ t >>> 7, t | 61);
    return ((t ^ t >>> 14) >>> 0) / 4294967296;
  };
}

// Pure integer hash noise — identical in Node and browser
function noise2d(x, y, seed) {
  let n = (Math.floor(x * 1000) * 374761393) ^ (Math.floor(y * 1000) * 668265263) ^ (seed * 1274126177);
  n = (n ^ (n >>> 13)) * 1274126177;
  n = n ^ (n >>> 16);
  return ((n >>> 0) % 10000) / 10000;
}

export function renderJulia(params) {
  const {
    cRe = -0.8,
    cIm = 0.156,
    maxIter = 128,
    zoom = 3.0,
    offsetX = 0,
    offsetY = 0,
    palette = 'classic'
  } = params;

  const pixels = new Uint8Array(WIDTH * HEIGHT * 4);

  for (let py = 0; py < HEIGHT; py++) {
    for (let px = 0; px < WIDTH; px++) {
      let zx = ((px / WIDTH) - 0.5) * zoom + offsetX;
      let zy = ((py / HEIGHT) - 0.5) * zoom + offsetY;
      let iter = 0;

      while (zx * zx + zy * zy < 4.0 && iter < maxIter) {
        const xtemp = zx * zx - zy * zy + cRe;
        zy = 2.0 * zx * zy + cIm;
        zx = xtemp;
        iter++;
      }

      const t = iter / maxIter;
      let r, g, b;
      if (iter === maxIter) {
        r = g = b = 0;
      } else if (palette === 'classic') {
        r = Math.floor(255 * Math.sin(t * Math.PI));
        g = Math.floor(255 * Math.sin(t * Math.PI * 1.5));
        b = Math.floor(255 * t);
      } else {
        r = Math.floor(255 * t);
        g = Math.floor(128 * (1 - t));
        b = Math.floor(255 * (1 - t));
      }

      const idx = (py * WIDTH + px) * 4;
      pixels[idx] = r;
      pixels[idx + 1] = g;
      pixels[idx + 2] = b;
      pixels[idx + 3] = 255;
    }
  }
  return pixels;
}

export function renderFlowField(params) {
  const {
    seed = 42,
    steps = 80,
    particles = 400,
    zoom = 2.5,
    offsetX = 0,
    offsetY = 0,
    palette = 'flow'
  } = params;

  const pixels = new Uint8Array(WIDTH * HEIGHT * 4);
  // Black background
  for (let i = 3; i < pixels.length; i += 4) pixels[i] = 255;

  const rng = mulberry32(seed);
  const scale = zoom;

  for (let p = 0; p < particles; p++) {
    let x = (rng() - 0.5) * scale + offsetX;
    let y = (rng() - 0.5) * scale + offsetY;

    for (let s = 0; s < steps; s++) {
      const n = noise2d(x * 3.0, y * 3.0, seed);
      // 8-direction integer lookup — no Math.sin/cos
      const dir = Math.floor(n * 8) % 8;
      const dx = [0, 1, 1, 1, 0, -1, -1, -1][dir];
      const dy = [-1, -1, 0, 1, 1, 1, 0, -1][dir];
      const vx = dx * 0.02;
      const vy = dy * 0.02;

      x += vx;
      y += vy;

      const px = Math.floor(((x - offsetX) / scale + 0.5) * WIDTH);
      const py = Math.floor(((y - offsetY) / scale + 0.5) * HEIGHT);

      if (px >= 0 && px < WIDTH && py >= 0 && py < HEIGHT) {
        const idx = (py * WIDTH + px) * 4;
        const intensity = Math.min(255, pixels[idx] + 8);
        if (palette === 'flow') {
          pixels[idx] = intensity;           // R
          pixels[idx + 1] = Math.floor(intensity * 0.6); // G
          pixels[idx + 2] = 255 - intensity; // B
        } else {
          pixels[idx] = intensity;
          pixels[idx + 1] = intensity;
          pixels[idx + 2] = intensity;
        }
      }
    }
  }
  return pixels;
}

export async function sha256(pixels) {
  const hashBuffer = await crypto.subtle.digest('SHA-256', pixels);
  return Array.from(new Uint8Array(hashBuffer))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}
