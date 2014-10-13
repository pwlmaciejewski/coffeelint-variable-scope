# coffeelint-variable-scope [![NPM version](https://badge.fury.io/js/coffeelint-variable-scope.svg)](http://badge.fury.io/js/coffeelint-variable-scope) [![Build Status](https://secure.travis-ci.org/fragphace/coffeelint-variable-scope.png?branch=master)](http://travis-ci.org/fragphace/coffeelint-variable-scope)

<table>
<tr> 
<td>Package</td><td>coffeelint-variable-scope</td>
</tr>
<tr>
<td>Description</td>
<td>[CoffeeLint](http://www.coffeelint.org/) rule that warns you about overwriting outer scope variable.</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.10</td>
</tr>
</table>

## Example

```
  ✗ ./level.coffee
     ⚡ #1-8: Outer scope variable overwrite. a.

✗ Lint! » 2 errors and 1 warning in 2 files
```

**Means**: Variable `a` assigned in `1st` line and overwriten in `8th` line of `level.coffee` file.

## Installation

```
npm install coffeelint-variable-scope
```

## Usage

Put this in your coffeelint config:

```
"variable_scope": {
    "module": "coffeelint-variable-scope",
    "scopeDiff": 1
}
```

## Options

`scopeDiff` - Reports an error if upper and lower variable 
assign scope level difference is equal/bigger than `scopeDiff`. Default: `1`.

## Ignore errors

You can "bless" certain assignments as intentional via a special 
`coffeelint-variable-scope-ignore` annotation in code. Below code
will not produce any coffeelint errors:

```
    a = 1
    ###coffeelint-variable-scope-ignore###
    a = 2
```

Notes:

* It needs to be a **block** comment
* It will ignore the next **assignment** (not line) in the code block

## Test

```
npm test
```

## Changelog

`0.0.2` `2014-10-13`

* Added `coffeelint-variable-scope-ingore` blessing
* Bug fixes

`0.0.1` `2013-11-07` 
Initial release