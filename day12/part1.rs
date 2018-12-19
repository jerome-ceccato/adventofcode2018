use std::fs;
use std::string::String;
use std::io::BufRead;
use std::io::BufReader;
use std::collections::HashMap;

struct Game {
    state: HashMap<i32, bool>,
    table: HashMap<u8, bool>,
}

fn read_initial_state(line: String) -> HashMap<i32, bool> {
    let mut state = HashMap::new();
    let initial = &line["initial state: ".len()..];

    for (i, c) in initial.chars().enumerate() {
        let index = i as i32;
        match c {
            '#' => state.insert(index, true),
            _ => None
        };
    }

    state
}

fn read_table_entry(line: String) -> (u8, bool) {
    let bytes = line.as_bytes();
    let pack = |bytes: &[u8], pos: usize| -> u8 {
        ((bytes[pos] == ('#' as u8)) as u8) << pos
    };
    let encoded = [0, 1, 2, 3, 4].iter().fold(0, |acc, x| acc | pack(bytes, *x));
    let is_plant = bytes[9] == '#' as u8;

    (encoded, is_plant)
}

fn read_file(filename: &str) -> Game {
    let file = fs::File::open(filename).expect("no input");
    let contents = BufReader::new(&file);
    let mut game = Game { state: HashMap::new(), table: HashMap::new() };

    for line in contents.lines() {
        let l = line.unwrap();

        if l.starts_with("initial state: ") {
            game.state = read_initial_state(l);
        }
        else if l.len() >= 10 {
            let (encoded, is_plant) = read_table_entry(l);
            game.table.insert(encoded, is_plant);
        }
    }

    game
}

fn encode(pos: i32, game: &Game) -> u8 {
    let pack = |state: &HashMap<i32, bool>, pos: &i32, i: &i32| -> i32 {
        (match state.get(pos) {
            Some(true) => 1,
            _ => 0
        }) << i
    };
    let encoded = [0, 1, 2, 3, 4].iter().fold(0, |acc, x| {
        acc | pack(&game.state, &(pos + x - 2), x)
    });

    encoded as u8
}

fn run_once(game: &Game) -> HashMap<i32, bool> {
    let mut next_state = HashMap::new();
    let min = game.state.keys().min().unwrap_or(&0) - 2;
    let max = game.state.keys().max().unwrap_or(&0) + 2;

    for i in min..max {
        match game.table.get(&encode(i, game)) {
            Some(true) => next_state.insert(i, true),
            _ => None
        };
    }

    next_state
}

fn solve(game: &Game) -> i32 {
    game.state.keys().sum()
}

fn main() {
    let steps = 20;
    let mut game = read_file("input");

    for _ in 0..steps {
        game.state = run_once(&game);
    }

    println!("{}", solve(&game));
}
