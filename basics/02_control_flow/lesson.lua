--[[
  Lesson 02: 制御構造

  Luaの制御構造:
  - if / elseif / else
  - while
  - repeat-until（do-while相当）
  - for（数値for、汎用for）
  - break（ループ脱出）
  ※ continue は存在しない！
]]

-- ========================================
-- if 文
-- ========================================

local score = 75

if score >= 90 then
  print("優")
elseif score >= 70 then
  print("良")  --> これが出力
elseif score >= 50 then
  print("可")
else
  print("不可")
end

-- 論理演算子: and, or, not（&& || ! ではない）
local age = 20
local has_license = true

if age >= 18 and has_license then
  print("運転できます")
end

if not has_license then
  print("免許が必要です")
end

-- ========================================
-- while ループ
-- ========================================

local count = 1
while count <= 3 do
  print("while:", count)
  count = count + 1  -- Lua には += がない！
end

-- ========================================
-- repeat-until（条件が真になるまで繰り返す）
-- ========================================

local n = 1
repeat
  print("repeat:", n)
  n = n + 1
until n > 3  -- 条件が true になったら終了

-- ========================================
-- 数値 for ループ
-- ========================================

-- for 変数 = 開始, 終了, ステップ do
-- ステップを省略すると 1

print("1から5まで:")
for i = 1, 5 do
  print("  i =", i)
end

print("10から2まで（-2ずつ）:")
for i = 10, 2, -2 do
  print("  i =", i)
end

-- ========================================
-- 汎用 for ループ（イテレータ）
-- ========================================

-- ipairs: 配列部分を順番に（1, 2, 3...）
local fruits = {"apple", "banana", "cherry"}
for index, value in ipairs(fruits) do
  print(index, value)
end
-- 出力:
-- 1  apple
-- 2  banana
-- 3  cherry

-- pairs: テーブル全体（順序不定）
local person = {name = "Taro", age = 25, city = "Tokyo"}
for key, value in pairs(person) do
  print(key, "=", value)
end

-- ========================================
-- break（ループ脱出）
-- ========================================

print("break の例:")
for i = 1, 10 do
  if i > 5 then
    break  -- ループを抜ける
  end
  print("  i =", i)
end

-- 注意: Lua には continue がない！
-- 代わりに条件を工夫するか、goto を使う（Lua 5.2以降）

-- continue の代替パターン
print("continue 相当の処理:")
for i = 1, 5 do
  if i ~= 3 then  -- 3 以外の時だけ処理
    print("  i =", i)
  end
end

-- ========================================
-- 比較演算子
-- ========================================

-- 等しい: ==
-- 等しくない: ~= （!= ではない！）
-- 大小: < > <= >=

local a, b = 10, 20
print(a == b)   --> false
print(a ~= b)   --> true（!=ではなく~=）
print(a < b)    --> true

print("===== Lesson 02 完了 =====")
