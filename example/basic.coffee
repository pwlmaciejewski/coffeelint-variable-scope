a = 1
b = 2

foo = ->
  a = 2

foo = ->
  a = 4
  c = 3

# if b is 2 and c = 3 then a = 3

foo()