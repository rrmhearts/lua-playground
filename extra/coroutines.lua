function foo (a)
      print("foo", a) -- a is 2
      return coroutine.yield(2*a) -- 2*2 == 4
end

co = coroutine.create(function (a,b)
      print("co-body", a, b) -- 1, 10
      local r = foo(a+1) -- returns 4! control handed back
      print("co-body", r) -- prints `co-body r`
      local r, s = coroutine.yield(a+b, a-b) -- yields 2 values, `1+10, 1-10`==`11, -9`
      print("co-body", r, s) -- r,s are set to x, y, NOT the values put into yield (those are returned)
      -- ^^ prints, `co-body x y`
      return b, "end"
end)

print("main", coroutine.resume(co, 1, 10)) -- return value is SUCCESS, value == true, 4
print("main", coroutine.resume(co, "r")) -- returns to `main 11 -9`
-- In Lua, values passed to coroutine.resume() act as the arguments to the function, 
-- or if the coroutine is already running, they are returned by coroutine.yield().
print("main", coroutine.resume(co, "x", "y")) -- x, y are passed into the return of the last yield
-- ^^ returns to `main 10 end` because b is 10 from earlier
print("main", coroutine.resume(co, "x", "y")) -- the coroutine has already ended, failure returns false
