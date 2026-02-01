--[[
  Lesson 01: 変数とデータ型

  Luaの基本的なデータ型:
  - nil      : 値が存在しないことを表す
  - boolean  : true または false
  - number   : 整数も小数も全て number（Lua 5.1）
  - string   : 文字列
  - table    : 配列・辞書・オブジェクト全てを表現（後のレッスンで詳しく）
  - function : 関数も第一級オブジェクト
]]

-- ========================================
-- 変数の宣言
-- ========================================

-- グローバル変数（local をつけない）
greeting = "Hello"

-- ローカル変数（推奨：スコープを限定できる）
local message = "World"

-- 複数同時代入
local x, y, z = 1, 2, 3

-- 値より変数が多い場合、余りは nil になる
local a, b, c = 10, 20
print("c の値:", c)  --> nil

-- ========================================
-- データ型の確認
-- ========================================

print(type(nil))        --> nil
print(type(true))       --> boolean
print(type(42))         --> number
print(type(3.14))       --> number
print(type("hello"))    --> string
print(type(print))      --> function

-- ========================================
-- 文字列操作
-- ========================================

local str1 = "Hello"
local str2 = 'World'  -- シングルクォートも可

-- 文字列結合は .. を使う（+ ではない！）
local combined = str1 .. " " .. str2
print(combined)  --> Hello World

-- 文字列の長さは # を使う
print(#combined)  --> 11

-- 複数行文字列
local multiline = [[
これは
複数行の
文字列です
]]
print(multiline)

-- ========================================
-- 数値操作
-- ========================================

local num = 10
print(num + 5)   --> 15
print(num - 3)   --> 7
print(num * 2)   --> 20
print(num / 4)   --> 2.5
print(num % 3)   --> 1 (剰余)
print(num ^ 2)   --> 100 (累乗)

-- 文字列から数値への変換
local str_num = "42"
print(tonumber(str_num) + 8)  --> 50

-- 数値から文字列への変換
print(tostring(100) .. " points")  --> 100 points

-- ========================================
-- nil と boolean
-- ========================================

-- Luaでは nil と false のみが偽、それ以外は全て真
-- 注意: 0 や "" (空文字) も真として扱われる！

local value = nil
if value then
  print("value は真")
else
  print("value は偽")  --> こちらが出力
end

local zero = 0
if zero then
  print("0 は真として扱われる")  --> こちらが出力
end

print("===== Lesson 01 完了 =====")
