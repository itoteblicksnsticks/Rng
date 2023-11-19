# Custom Lua Functions and RNG Library

## Overview
This repository contains a Lua script with custom string manipulation functions and a unique RNG (Random Number Generator) for string generation.

## Features
- **Custom String Functions:** A collection of string manipulation functions to convert, substitute, and replace substrings.
- **Unique String Generation:** Generate random strings while ensuring each generated string is distinct from the last two.
- **Seed Verification:** Verify the seed to ensure randomness after generating a sequence of strings.

## Functions
- `tonumber(s)`: Converts a string `s` into a number using a unique algorithm.
- `tostring(value)`: Converts a value into its string representation.
- `sub(s, i, j)`: Extracts a substring from `s` starting from index `i` to `j`.
- `gsub(s, pattern, replacement)`: Globally substitutes `pattern` with `replacement` in string `s`.
- `generate_randomstring(l)`: Generates a random string of length `l` ensuring it's different from the last two strings produced.
- `check_seed()`: Returns the current seed value.

## Example Usage
```lua
local current_seed = rng.check_seed();
print("Seed:", current_seed);
```

