from dataclasses import dataclass, field
from enum import Enum
from typing import Iterator

MATE_TEMP_CELSIUS = 70.0
STEEP_ROUNDS = 12


class Flavor(Enum):
    EARTHY = "earthy"
    SMOKY = "smoky"
    CITRUS = "citrus"
    HERBAL = "herbal"


@dataclass
class YerbaMate:
    name: str
    origin: str
    weight: float
    flavors: list[Flavor] = field(default_factory=list)

    @property
    def label(self) -> str:
        tags = ", ".join(f.value for f in self.flavors)
        return f"{self.name} [{tags}]" if tags else self.name

    def steep(self, rounds: int = STEEP_ROUNDS) -> Iterator[str]:
        """Yield a description for each round of steeping."""
        for n in range(1, rounds + 1):
            strength = max(0.0, 1.0 - n / (rounds + 1))
            yield f"round {n:>2}: {self.name} @ {strength:.0%} strength"

    def __str__(self) -> str:
        return f"{self.label} — {self.weight:.1f}g from {self.origin}"


def build_collection() -> list[YerbaMate]:
    return [
        YerbaMate("Canarias", "Brazil", 50.0, [Flavor.EARTHY]),
        YerbaMate("Taragui", "Argentina", 40.0, [Flavor.EARTHY, Flavor.SMOKY]),
        YerbaMate("Pajarito", "Paraguay", 35.5, [Flavor.CITRUS, Flavor.HERBAL]),
        YerbaMate("Kurupi", "Paraguay", 28.0, [Flavor.HERBAL]),
    ]


def find_by_flavor(collection: list[YerbaMate], flavor: Flavor) -> list[YerbaMate]:
    return [m for m in collection if flavor in m.flavors]


def summarize(collection: list[YerbaMate]) -> dict[str, object]:
    total = sum(m.weight for m in collection)
    origins = {m.origin for m in collection}
    return {"count": len(collection), "total_grams": total, "origins": origins}


if __name__ == "__main__":
    mates = build_collection()

    for mate in mates:
        print(mate)

    print()
    earthy = find_by_flavor(mates, Flavor.EARTHY)
    print(f"earthy blends: {', '.join(m.name for m in earthy)}")

    # steep the first one as a demo
    print()
    for line in mates[0].steep(rounds=6):
        print(f"  {line}")

    stats = summarize(mates)
    print(f"\n{stats['count']} blends, {stats['total_grams']:.1f}g total")
