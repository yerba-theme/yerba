# Yerba Mate Brewing Guide

A simple reference for preparing the **perfect mate**. Whether you prefer
*traditional* or modern methods, the basics remain the same.

## Equipment

1. Gourd (calabaza or ceramic)
2. Bombilla (metal filtered straw)
3. Thermos with hot water at ~70°C

## Steps

### Prepare the Gourd

Fill the gourd about **two-thirds** full with yerba. Tilt the gourd to one
side so the yerba forms a slope — this creates a *hollow* near the bombilla.

### Add Water

> Never use boiling water. The ideal temperature is between 65°C and 80°C.
> Boiling water will scorch the leaves and turn the mate bitter.

Pour a small amount of cool water into the hollow first. Wait 30 seconds,
then add hot water from the thermos.

### Steep and Serve

Pass the gourd to the first drinker. Each person drinks the full gourd
before refilling. A good yerba can last **12–15 rounds** before losing
strength.

## Blends Worth Trying

| Name     | Origin    | Notes              |
|----------|-----------|--------------------|
| Canarias | Brazil    | Earthy, smooth     |
| Taragui  | Argentina | Classic, bold      |
| Pajarito | Paraguay  | Citrus, refreshing |

## Links

- [Yerba Mate on Wikipedia](https://en.wikipedia.org/wiki/Yerba_mate)
- [Brewing Tips](https://example.com/brewing)

---

See the project source at `snippets/example.md` or read the full
[README](../README.md) for installation instructions.

~~This section is outdated and no longer applies.~~

```python
# quick steep calculation
rounds = 12
strengths = [max(0, 1 - n / (rounds + 1)) for n in range(1, rounds + 1)]
```
