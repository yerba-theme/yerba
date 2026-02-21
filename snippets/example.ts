const STEEP_ROUNDS = 12;
const WATER_TEMP = 70.0;

type Flavor = "earthy" | "smoky" | "citrus" | "herbal";

interface Blend {
  name: string;
  origin: string;
  grams: number;
  flavors: Flavor[];
  smoked?: boolean;
}

class MateSession {
  private blends: Blend[] = [];
  private round = 0;

  constructor(readonly owner: string) {}

  add(blend: Blend): this {
    this.blends.push(blend);
    return this;
  }

  get totalGrams(): number {
    return this.blends.reduce((sum, b) => sum + b.grams, 0);
  }

  steep(): { blend: string; strength: number } | null {
    if (this.blends.length === 0) return null;

    this.round++;
    const strength = Math.max(0, 1 - this.round / (STEEP_ROUNDS + 1));
    const blend = this.blends[this.round % this.blends.length];

    return { blend: blend.name, strength };
  }
}

function filterByFlavor(blends: Blend[], flavor: Flavor): Blend[] {
  return blends.filter((b) => b.flavors.includes(flavor));
}

function formatBlend(blend: Blend): string {
  const tags = blend.flavors.join(", ");
  return `${blend.name} — ${blend.grams}g from ${blend.origin} [${tags}]`;
}

// regex to validate blend names: letters, spaces, accented chars
const VALID_NAME = /^[\p{L}\s'-]+$/u;

async function loadBlends(path: string): Promise<Blend[]> {
  const resp = await fetch(path);
  if (!resp.ok) {
    throw new Error(`failed to load blends: ${resp.status}`);
  }
  const data: Blend[] = await resp.json();
  return data.filter((b) => VALID_NAME.test(b.name));
}

// demo
const blends: Blend[] = [
  { name: "Canarias", origin: "Brazil", grams: 50.0, flavors: ["earthy"] },
  { name: "Taragüí", origin: "Argentina", grams: 40.0, flavors: ["earthy", "smoky"] },
  { name: "Pajarito", origin: "Paraguay", grams: 35.5, flavors: ["citrus", "herbal"] },
  { name: "Kurupi", origin: "Paraguay", grams: 28.0, flavors: ["herbal"] },
];

for (const blend of blends) {
  console.log(formatBlend(blend));
}

const earthy = filterByFlavor(blends, "earthy");
console.log(`\nearthy: ${earthy.map((b) => b.name).join(", ")}`);

const session = new MateSession("Sebastián");
for (const b of blends) session.add(b);

console.log(`\ntotal: ${session.totalGrams}g`);

for (let i = 0; i < 6; i++) {
  const result = session.steep();
  if (result) {
    console.log(`  round ${i + 1}: ${result.blend} @ ${(result.strength * 100).toFixed(0)}%`);
  }
}
