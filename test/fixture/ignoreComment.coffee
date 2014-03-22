a = 1
b = 1

foo = ->
  a = 2
  c = 2

foo = ->
  c = 2
  bar = ->
    ###coffeelint-variable-scope-ignore###
    b = 3 
    baz = ->
        ###just some comment###
        c = 4