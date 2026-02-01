--[[
  Lesson 03: 関数

  Luaの関数の特徴:
  - 第一級オブジェクト（変数に代入、引数として渡せる）
  - 複数の戻り値を返せる
  - クロージャをサポート
  - 可変長引数
]]

-- ========================================
-- 基本的な関数定義
-- ========================================

-- 標準的な定義
function greet(name)
  return "Hello, " .. name .. "!"
end

print(greet("Lua"))  --> Hello, Lua!

-- ローカル関数（推奨）
local function add(a, b)
  return a + b
end

print(add(3, 5))  --> 8

-- 無名関数を変数に代入
local multiply = function(a, b)
  return a * b
end

print(multiply(4, 6))  --> 24

-- ========================================
-- 複数の戻り値
-- ========================================

local function min_max(a, b, c)
  local min = math.min(a, b, c)
  local max = math.max(a, b, c)
  return min, max  -- 複数の値を返す
end

local minimum, maximum = min_max(5, 2, 8)
print("最小:", minimum, "最大:", maximum)  --> 最小: 2 最大: 8

-- 一部だけ受け取ることも可能
local only_min = min_max(5, 2, 8)  -- 最初の戻り値のみ
print("最小のみ:", only_min)  --> 2

-- ========================================
-- デフォルト引数（Luaにはないので or で代用）
-- ========================================

local function greet_with_default(name)
  name = name or "Guest"  -- nil なら "Guest" を使う
  return "Welcome, " .. name
end

print(greet_with_default())         --> Welcome, Guest
print(greet_with_default("Taro"))   --> Welcome, Taro

-- ========================================
-- 可変長引数
-- ========================================

local function sum_all(...)
  local args = {...}  -- 可変長引数をテーブルに
  local total = 0
  for _, v in ipairs(args) do
    total = total + v
  end
  return total
end

print(sum_all(1, 2, 3))        --> 6
print(sum_all(10, 20, 30, 40)) --> 100

-- select で引数の数を取得
local function count_args(...)
  return select("#", ...)  -- 引数の数
end

print("引数の数:", count_args("a", "b", "c"))  --> 3

-- ========================================
-- 関数は第一級オブジェクト
-- ========================================

-- 関数を引数として渡す
local function apply_twice(func, value)
  return func(func(value))
end

local function double(x)
  return x * 2
end

print(apply_twice(double, 5))  --> 20 (5*2=10, 10*2=20)

-- 関数を返す関数
local function make_multiplier(factor)
  return function(x)
    return x * factor
  end
end

local triple = make_multiplier(3)
print(triple(7))  --> 21

-- ========================================
-- クロージャ
-- ========================================

local function create_counter()
  local count = 0  -- この変数は関数の外からアクセスできない
  return function()
    count = count + 1
    return count
  end
end

local counter = create_counter()
print(counter())  --> 1
print(counter())  --> 2
print(counter())  --> 3

-- 別のカウンターは独立
local counter2 = create_counter()
print(counter2()) --> 1

-- ========================================
-- テーブルのメソッド風記法
-- ========================================

local calculator = {}

function calculator.add(a, b)
  return a + b
end

-- コロン記法（self が自動的に渡される）
function calculator:multiply(value)
  -- self は calculator 自身を指す
  return value * (self.factor or 1)
end

calculator.factor = 10
print(calculator.add(2, 3))      --> 5
print(calculator:multiply(5))    --> 50

print("===== Lesson 03 完了 =====")
