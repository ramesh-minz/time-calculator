# ⏱️ Time Calculator (Ruby)

A powerful, human-friendly **advanced time calculator** written in **Ruby**.  
It understands time like humans do — durations, clock formats, and math — all in one expression.

> Parse, calculate, and format time with ease.

---

## ✨ Features

- ✅ Natural time expressions
- ✅ Supports `HH:MM`, `MM:SS`, `HH:MM:SS`
- ✅ Time units: `d h m s`
- ✅ Combined units: `1h30m`, `1h 30m 15s`
- ✅ Arithmetic operators: `+ - * /`
- ✅ Parentheses and operator precedence
- ✅ Unary minus: `-10m`, `-(2h + 30m)`
- ✅ Duration ÷ Duration → ratio
- ✅ Clean CLI output
- ✅ Fully tested with **Minitest**

---

## 📦 Installation

Clone the repository:

    git clone https://github.com/ramesh-minz/time-calculator.git
    cd time-calculator

Install dependencies:

    bundle install

---

## 🚀 Usage

Run from the command line:

    ruby bin/timecalc "EXPRESSION"

### Examples

Add durations:

    ruby bin/timecalc "1h + 30m + 15s"

Parentheses + multiplication:

    ruby bin/timecalc "(2h + 30m) * 3"

Mix clock format and units:

    ruby bin/timecalc "1:20:30 + 45m - 10s"

Duration ratio:

    ruby bin/timecalc "90m / 30m"

Unary minus:

    ruby bin/timecalc "-10m + 2m"

---

## 🧠 Supported Time Formats

### ⏰ Clock literals

- `HH:MM` (example: `02:30`)
- `MM:SS` (example: `10:45`)
- `HH:MM:SS` (example: `01:02:03`)

Note: The parser auto-detects `MM:SS` when both parts are `<= 59`.  
Otherwise, `HH:MM` is assumed.

---

### ⏳ Duration units

- `d` — days
- `h` — hours
- `m` — minutes
- `s` — seconds

Valid combinations:

- `2h`
- `1.5h`
- `1h30m`
- `1h 30m 15s`

---

## ➗ Arithmetic Rules

- `duration + duration` → duration
- `duration - duration` → duration
- `duration * scalar` → duration
- `scalar * duration` → duration
- `duration / scalar` → duration
- `duration / duration` → scalar ratio

---

## 🧪 Running Tests

    bundle exec rake test

---

## 📁 Project Structure

    time-calculator/
    ├── bin/
    │   └── timecalc
    ├── lib/
    │   └── time_calculator/
    │       ├── tokenizer.rb
    │       ├── parser.rb
    │       ├── evaluator.rb
    │       ├── duration.rb
    │       └── version.rb
    ├── test/
    │   └── test_time_calculator.rb
    ├── README.md
    ├── LICENSE
    └── time-calculator.gemspec

---

## 🛣️ Roadmap

- [ ] Custom output formats (`2h 30m`, ISO-8601)
- [ ] Timezone support
- [ ] Ruby gem release
- [ ] Web / API wrapper

---

## 📜 License

MIT License © 2025 Ramesh Minz

---

## ⭐ Contributing

Pull requests are welcome.  
If you find a bug or have an idea, open an issue or submit a PR.

---

Made with ❤️ and Ruby
