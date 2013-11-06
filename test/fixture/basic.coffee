a = 1
b = 1

foo = ->
  a = 2
  c = 2

foo = ->
  c = 2
  bar = ->
    b = 3
    baz = ->
        c = 4