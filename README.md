coffeelint-variable-scope
=========================

[http://www.coffeelint.org/](CoffeeLint) rule that warns you when you accidentally 
overwrite outer scope variable.

```
  ✗ ./level.coffee
     ⚡ #1-8: Outer scope variable overwrite. a.

✗ Lint! » 2 errors and 1 warning in 1 file
```

**Means**: Variable `a` assigned in `1st` line and overwriten in `8th` line of `level.coffee` file.

## Installation

`npm install coffeelint-variable-scope`

## Usage

Put this in your coffeelint config:

```
"variable_scope": {
    "module": "coffeelint-variable-scope",
    "scopeDiff": 1
}
```

## Options

`**scopeDiff**` - Reports an error if upper and lower variable 
assign scope level difference is equal/bigger than `scopeDiff`. Default: 1.

## Test

`npm test`