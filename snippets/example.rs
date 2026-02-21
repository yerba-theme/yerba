use std::collections::HashMap;
use std::fmt;

const MAX_STEEP_MINUTES: u32 = 15;

#[derive(Debug, Clone)]
enum Origin {
    Argentina,
    Brazil,
    Paraguay,
    Other(String),
}

#[derive(Debug, Clone)]
struct Blend {
    name: String,
    origin: Origin,
    weight_grams: f64,
    steep_minutes: u32,
    smoked: bool,
}

impl fmt::Display for Blend {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{} ({:?}, {:.1}g, {}min)",
            self.name, self.origin, self.weight_grams, self.steep_minutes)
    }
}

impl Blend {
    fn new(name: &str, origin: Origin, grams: f64, minutes: u32) -> Self {
        Self {
            name: name.to_string(),
            origin,
            weight_grams: grams,
            steep_minutes: minutes.min(MAX_STEEP_MINUTES),
            smoked: false,
        }
    }

    fn with_smoke(mut self) -> Self {
        self.smoked = true;
        self
    }
}

fn rank_by_weight(blends: &[Blend]) -> Vec<&Blend> {
    let mut sorted: Vec<&Blend> = blends.iter().collect();
    sorted.sort_by(|a, b| b.weight_grams.partial_cmp(&a.weight_grams).unwrap());
    sorted
}

fn group_by_origin(blends: &[Blend]) -> HashMap<String, Vec<&Blend>> {
    let mut map: HashMap<String, Vec<&Blend>> = HashMap::new();
    for blend in blends {
        let key = format!("{:?}", blend.origin);
        map.entry(key).or_default().push(blend);
    }
    map
}

fn main() {
    let blends = vec![
        Blend::new("Canarias", Origin::Brazil, 50.0, 5),
        Blend::new("Taragui", Origin::Argentina, 40.0, 8),
        Blend::new("Pajarito", Origin::Paraguay, 35.5, 6).with_smoke(),
        Blend::new("Kurupi", Origin::Paraguay, 28.0, 10),
        Blend::new("Sara", Origin::Brazil, 45.0, 7),
    ];

    // rank heaviest first
    println!("-- by weight --");
    for (i, blend) in rank_by_weight(&blends).iter().enumerate() {
        println!("  {}. {}", i + 1, blend);
    }

    // group by country of origin
    println!("\n-- by origin --");
    for (origin, group) in &group_by_origin(&blends) {
        let names: Vec<&str> = group.iter().map(|b| b.name.as_str()).collect();
        println!("  {}: {}", origin, names.join(", "));
    }

    let total: f64 = blends.iter().map(|b| b.weight_grams).sum();
    let smoked: usize = blends.iter().filter(|b| b.smoked).count();

    println!("\ntotal: {:.1}g | smoked: {}/{}", total, smoked, blends.len());
}
