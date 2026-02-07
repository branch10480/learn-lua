--[[
  Exercise 03: 関数

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: 基本的な関数
-- ========================================

-- TODO: 2つの数値を受け取り、大きい方を返す関数 max_of_two を作成
local function max_of_two(a, b)
  return math.max(a, b)
end

print("max_of_two(3, 7):", max_of_two(3, 7))
print("max_of_two(10, 5):", max_of_two(10, 5))
assert(max_of_two(3, 7) == 7, "max_of_two(3, 7) が正しくありません")
assert(max_of_two(10, 5) == 10, "max_of_two(10, 5) が正しくありません")

-- ========================================
-- 問題 2: 複数の戻り値
-- ========================================

-- TODO: 2つの数値を受け取り、和と差を両方返す関数を作成
-- 例: sum_and_diff(10, 3) -> 13, 7
local function sum_and_diff(a, b)
  return a + b, a - b
end

local s, d = sum_and_diff(10, 3)
print("sum_and_diff(10, 3):", s, d)
assert(s == 13 and d == 7, "sum_and_diff が正しくありません")

-- ========================================
-- 問題 3: デフォルト引数パターン
-- ========================================

-- TODO: 挨拶を返す関数を作成
-- greeting が省略されたら "Hello" を使う
-- 例: make_greeting("World") -> "Hello, World!"
-- 例: make_greeting("World", "Hi") -> "Hi, World!"
local function make_greeting(name, greeting)
  local result = greeting or "Hello"
  return result .. ", " .. name .. "!"
end

print(make_greeting("Lua"))
print(make_greeting("Lua", "Hey"))
assert(make_greeting("World") == "Hello, World!", "デフォルト挨拶が正しくありません")
assert(make_greeting("World", "Hi") == "Hi, World!", "カスタム挨拶が正しくありません")

-- ========================================
-- 問題 4: 可変長引数
-- ========================================

-- TODO: 任意の数の文字列を受け取り、スペースで結合して返す関数
-- 例: join_strings("a", "b", "c") -> "a b c"
local function join_strings(...)
  local args = {...}
  return table.concat(args, " ")
end

print(join_strings("Hello", "Lua", "World"))
assert(join_strings("a", "b", "c") == "a b c", "join_strings が正しくありません")

-- ========================================
-- 問題 5: 高階関数
-- ========================================

-- TODO: 関数と配列を受け取り、各要素に関数を適用した新しい配列を返す
-- 例: map({1, 2, 3}, function(x) return x * 2 end) -> {2, 4, 6}
local function map(arr, func)
  local new = {}
  for i, v in ipairs(arr) do
    new[i] = func(v)
  end
  return new
end

local numbers = {1, 2, 3, 4, 5}
local doubled = map(numbers, function(x) return x * 2 end)

print("map result:", table.concat(doubled, ", "))
assert(doubled[1] == 2 and doubled[3] == 6, "map が正しくありません")

-- ========================================
-- 問題 6: クロージャ
-- ========================================

-- TODO: 初期値を受け取り、呼び出すたびにその値を加算していく関数を返す
-- 例:
--   local adder = make_adder(10)
--   adder(5)  -> 15 (10 + 5)
--   adder(3)  -> 18 (15 + 3)
local function make_adder(initial)
  local tmp = initial
  return function (x)
    tmp = tmp + x
    return tmp
  end
end

local adder = make_adder(10)
local result1 = adder(5)
local result2 = adder(3)
print("adder results:", result1, result2)
assert(result1 == 15, "最初の加算が正しくありません")
assert(result2 == 18, "2回目の加算が正しくありません")

-- ========================================
-- チャレンジ問題: 関数合成
-- ========================================

-- TODO: 2つの関数を受け取り、合成した新しい関数を返す
-- compose(f, g) は、x に対して f(g(x)) を計算する関数を返す
local function compose(f, g)
  return function (x)
    return f(g(x))
  end
end

local add_one = function(x) return x + 1 end
local square = function(x) return x * x end

local add_then_square = compose(square, add_one)  -- (x+1)^2
print("compose test:", add_then_square(4))  -- (4+1)^2 = 25
assert(add_then_square(4) == 25, "compose が正しくありません")

print("\n===== 全ての問題をクリアしました！ =====")
