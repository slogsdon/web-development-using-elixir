#Language basic knowledge
## "Hello, Elixir"

```
$ iex
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [async-threads:10] [kernel-poll:false]

Interactive Elixir (1.2.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

```elixir
iex(1)> IO.puts "hello, elixir!"
hello, elixir!
:ok
```

## Erlang foundation

```erlang
1> Base = "hello, erlang".
"hello, erlang"
2> Base.
"hello, erlang"
3> 3 + 3.
6
4> "hello, erlang".
"hello, erlang"
5> [104, 101, 108, 108, 111, 44, 32, 101, 114, 108, 97, 110, 103].
"hello, erlang"
6> <<"hello, erlang">>.
<<"hello, erlang">>
7> <<104, 101, 108, 108, 111, 44, 32, 101, 114, 108, 97, 110, 103>>.
<<"hello, erlang">>
8> [Base, 33].
["hello, erlang",33]
9> [Base, Base].
["hello, erlang","hello, erlang"]
10> erlang:iolist_to_binary([Base, <<33>>]).
<<"hello, erlang!">>
11> erlang:iolist_to_binary([Base, 33]).
<<"hello, erlang!">>
12> Fun = fun (B, C) -> erlang:iolist_to_binary([B, C]) end.
#Fun<erl_eval.12.50752066>
13> Fun("hello, erlang", 33).
<<"hello, erlang!">>
14> q().
ok
15>
```

### Basic module

```erlang
-module(stringer).
-export([concat/2]).

concat(S, C) when is_list(S) ->
  S ++ [C];
concat(B, C) ->
  erlang:iolist_to_binary([B, C]).
```

## Elixir foundation

```elixir
iex(1)> base = "hello, elixir"
"hello, elixir"
iex(2)> base
"hello, elixir"
iex(3)> 3 + 3
6
iex(4)> 'hello, elixir'
'hello, elixir'
iex(5)> [104, 101, 108, 108, 111, 44, 32, 101, 108, 105, 120, 105, 114]
'hello, elixir'
iex(6)> "hello, elixir"
"hello, elixir"
iex(7)> <<104, 101, 108, 108, 111, 44, 32, 101, 108, 105, 120, 105, 114>>
"hello, elixir"
iex(8)> [base, 33]
["hello, elixir", 33]
iex(9)> [base, base]
["hello, elixir", "hello, elixir"]
iex(10)> :erlang.iolist_to_binary([base, <<33>>])
"hello, elixir!"
iex(11)> :erlang.iolist_to_binary([base, 33])
"hello, elixir!"
iex(12)> fun = fn (b, c) -> :erlang.iolist_to_binary([b, c]) end
#Function<12.50752066/2 in :erl_eval.expr/5>
iex(13)> fun.("hello, elixir", 33)
"hello, elixir!"
iex(14)>
BREAK: (a)bort (c)ontinue (p)roc info (i)nfo (l)oaded
       (v)ersion (k)ill (D)b-tables (d)istribution
^C
```

### Basic module

```elixir
defmodule Stringer do
  def concat(l, c) when is_list(l) do
    l ++ [c]
  end
  def concat(b, c) do
    :erlang.iolist_to_binary([b, c])
  end
end
```

## Control statements, pattern matching, and functions

```elixir
if conditional do
  block1
else
  block2
end
```

```elixir
case conditional do
  true -> block1
  false -> block2
end
```

```elixir
cond do
  conditional1 -> block1
  conditional2 -> block2
  conditional3 -> block3
end
```

With `case`, non-boolean values can be matched.

```elixir
case value do
  {:ok, v} -> block1
  {:error, reason} -> block2
  _ -> block3
end
```

```elixir
def fun1(value) do
  case value do
    {:ok, v} -> block1
    {:error, reason} -> block2
    _ -> block3
  end
end
```

Can reduce the complexity by moving the pattern matching to the function definitions

```elixir
def fun1({:ok, v}) do
  block1
end
def fun1({:error, reason}) do
  block2
end
def fun1(_) do
  block3
end
```

## Data structures

```elixir
# lists
[1, 2, 3, 4]
[1 | [2 | [3 | [4 | []]]]]
[ head | tail ] # head is list item and tail is list of >= 0 items
[ {:prop1, value1},
  {:prop2, value2} ] # proplist
[ prop1: value1,
  prop2: value2 ] # keyword list
```

```elixir
# map
%{ prop1: value1,
   prop2: value2}
%{ "prop1": value1,
   "prop2": value2 }
%{ my_map | prop1: updated_value1 }
```

```elixir
defmodule MyStruct do
  defstruct prop1: default_value1,
            prop2: default_value2
end

struct(MyStruct, prop1: value1,
                 prop2: value2)
%{ __struct__: MyStruct,
   prop1: value1,
   prop2: value2 }
%{ my_struct | prop1: updated_value1 }
```

```elixir
iex(1)> defmodule MyStruct do
...(1)> defstruct prop1: nil, prop2: nil
...(1)> end
{:module, MyStruct,
 <<70, 79, 82, 49, 0, 0, 5, 24, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 0, 133, 131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115, 95, 118, 49, 108, 0, 0, 0, 4, 104, 2, ...>>,
 %MyStruct{prop1: nil, prop2: nil}}
iex(2)> s = struct(MyStruct)
%MyStruct{prop1: nil, prop2: nil}
iex(3)> s.__struct__
MyStruct
iex(4)> Enum.map s, fn p -> IO.inspect p end
** (Protocol.UndefinedError) protocol Enumerable not implemented for %MyStruct{prop1: nil, prop2: nil}
    (elixir) lib/enum.ex:1: Enumerable.impl_for!/1
    (elixir) lib/enum.ex:116: Enumerable.reduce/3
    (elixir) lib/enum.ex:1477: Enum.reduce/3
    (elixir) lib/enum.ex:1092: Enum.map/2
iex(4)> Map.keys s
[:__struct__, :prop1, :prop2]
iex(5)> %{__struct__: MyStruct, prop1: nil, prop2: nil}
%MyStruct{prop1: nil, prop2: nil}
```

## Concurrency

```elixir
# processes
pid = spawn(fn -> :timer.sleep(1000) end)
pid = spawn_link(fn -> :timer.sleep(1000) end)
{pid, ref} = spawn_monitor(fn -> :timer.sleep(1000) end)
```

```elixir
# message passing
send(pid, message)
receive do
  message1 -> block1
  message2 -> block2
end
receive do
  message1 -> block1
  message2 -> block2
after
  timeout -> block3 # in ms
end
```

## Object-oriented vs. functional actors

```ruby
irb(main):001:0> "HELLO".downcase
=> "hello"
```

```elixir
iex(1)> String.downcase("HELLO")
"hello"
```

```ruby
irb(main):001:0> "HELLO".downcase.capitalize
=> "Hello"
```

```elixir
iex(1)> String.capitalize(String.downcase("HELLO"))
"Hello"
```

```elixir
iex(2)> "HELLO" |> String.downcase |> String.capitalize
"Hello"
```

```ruby
irb(main):001:0> "hello, ruby".concat(33)
=> "hello, ruby!"
irb(main):002:0> "hello, ruby".send(:concat, 33)
=> "hello, ruby!"
```

```elixir
iex(1)> pid = spawn_link(Stringer, :loop, ["hello, elixir"])
#PID<0.98.0>
iex(2)> send pid, {:concat, 33}
{:ok, "hello, elixir!"}
{:ok, "hello, elixir!"}
```

## Summary
