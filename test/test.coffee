fs = require 'fs'
assert = require('chai').assert
CoffeeScript = require 'coffee-script'
Rule = require '../index.coffee'

suite 'lintNode().', ->
    setup ->
        @rule = new Rule()

    suite 'Basic example.', ->
        setup ->
            source = fs.readFileSync("#{__dirname}/fixture/basic.coffee").toString()
            ast = CoffeeScript.nodes source
            @errors = @rule.lintNode ast

        test 'There are three errors', ->
            assert.equal @errors.length, 3

        test 'First error is between first and fifth line', ->
            assert.equal @errors[0].upper.locationData.first_line, 0
            assert.equal @errors[0].lower.locationData.first_line, 4

        test 'Second error is between second and eleventh line', ->
            assert.equal @errors[1].upper.locationData.first_line, 1
            assert.equal @errors[1].lower.locationData.first_line, 10

        test 'First error is on variable"a"', ->
            assert.equal @errors[0].variable, 'a'

        test 'Scope level diff of second error is 2', ->
            assert.equal @errors[1].lower.scope_level - @errors[1].upper.scope_level, 2

        test 'Scope levels for third error are correct', ->
            assert.equal @errors[2].upper.scope_level, 2
            assert.equal @errors[2].lower.scope_level, 4

    suite 'Object literal.', ->
        setup ->
            source = fs.readFileSync("#{__dirname}/fixture/objectLiteral.coffee").toString()
            ast = CoffeeScript.nodes source
            @errors = @rule.lintNode ast

        test 'There is only one error', ->
            assert.equal @errors.length, 1

    suite 'Object property.', ->
        setup ->
            source = fs.readFileSync("#{__dirname}/fixture/objectProperty.coffee").toString()
            ast = CoffeeScript.nodes source
            @errors = @rule.lintNode ast

        test 'There is only one error', ->
            assert.equal @errors.length, 1