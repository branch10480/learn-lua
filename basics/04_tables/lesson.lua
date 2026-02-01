--[[
  Lesson 04: テーブル

  テーブルはLuaの唯一のデータ構造であり、以下の全てを表現:
  - 配列（リスト）
  - 辞書（ハッシュマップ）
  - オブジェクト
  - 名前空間/モジュール

  重要: Luaの配列は 1 から始まる！（0ではない）
]]

-- ========================================
-- 配列としてのテーブル
-- ========================================

-- 配列の作成
local fruits = {"apple", "banana", "cherry"}

-- 要素へのアクセス（1-indexed!）
print(fruits[1])  --> apple
print(fruits[2])  --> banana
print(fruits[3])  --> cherry
print(fruits[0])  --> nil（存在しない）

-- 配列の長さは # で取得
print("長さ:", #fruits)  --> 3

-- 要素の追加
fruits[4] = "date"
table.insert(fruits, "elderberry")  -- 末尾に追加
table.insert(fruits, 2, "avocado")  -- 位置2に挿入

print("追加後:", table.concat(fruits, ", "))

-- 要素の削除
table.remove(fruits, 2)  -- 位置2を削除
print("削除後:", table.concat(fruits, ", "))

-- ========================================
-- 辞書（連想配列）としてのテーブル
-- ========================================

local person = {
  name = "Taro",
  age = 25,
  city = "Tokyo"
}

-- アクセス方法1: ドット記法
print(person.name)  --> Taro

-- アクセス方法2: ブラケット記法
print(person["age"])  --> 25

-- 動的なキーにはブラケット記法が必要
local key = "city"
print(person[key])  --> Tokyo

-- 新しいキーの追加
person.country = "Japan"
person["job"] = "Engineer"

-- キーの削除
person.city = nil

-- ========================================
-- 混合テーブル
-- ========================================

-- 配列部分と辞書部分を混在可能
local mixed = {
  "first",           -- [1] = "first"
  "second",          -- [2] = "second"
  name = "mixed",    -- 名前付きキー
  value = 100
}

print(mixed[1])      --> first
print(mixed.name)    --> mixed

-- # は配列部分のみカウント
print("#mixed:", #mixed)  --> 2

-- ========================================
-- テーブルのイテレーション
-- ========================================

local data = {10, 20, 30, x = 100, y = 200}

-- ipairs: 配列部分のみ（1, 2, 3... の連続したキー）
print("\nipairs:")
for i, v in ipairs(data) do
  print("  ", i, v)
end
-- 出力: 1 10, 2 20, 3 30

-- pairs: 全てのキー（順序不定）
print("\npairs:")
for k, v in pairs(data) do
  print("  ", k, v)
end
-- 出力: 1 10, 2 20, 3 30, x 100, y 200（順序は不定）

-- ========================================
-- テーブルは参照型
-- ========================================

local original = {1, 2, 3}
local reference = original  -- コピーではなく参照

reference[1] = 999
print("original[1]:", original[1])  --> 999（元のテーブルも変更される）

-- 浅いコピーを作るには明示的にコピー
local function shallow_copy(t)
  local copy = {}
  for k, v in pairs(t) do
    copy[k] = v
  end
  return copy
end

local copied = shallow_copy(original)
copied[1] = 1
print("original[1]:", original[1])  --> 999（変更されない）
print("copied[1]:", copied[1])      --> 1

-- ========================================
-- テーブルをオブジェクトとして使う
-- ========================================

local Dog = {}

function Dog.new(name)
  local self = {
    name = name,
    energy = 100
  }

  function self.bark()
    print(self.name .. ": ワン!")
  end

  function self.run()
    self.energy = self.energy - 10
    print(self.name .. " が走った! エネルギー: " .. self.energy)
  end

  return self
end

local pochi = Dog.new("ポチ")
pochi.bark()  --> ポチ: ワン!
pochi.run()   --> ポチ が走った! エネルギー: 90

-- ========================================
-- 便利なテーブル関数
-- ========================================

local nums = {5, 2, 8, 1, 9}

-- ソート（破壊的）
table.sort(nums)
print("ソート後:", table.concat(nums, ", "))  --> 1, 2, 5, 8, 9

-- カスタムソート
table.sort(nums, function(a, b) return a > b end)
print("降順:", table.concat(nums, ", "))  --> 9, 8, 5, 2, 1

-- テーブルの結合（配列のみ）
local words = {"Hello", "Lua", "World"}
print(table.concat(words, "-"))  --> Hello-Lua-World

-- ========================================
-- ネストしたテーブル
-- ========================================

local users = {
  {name = "Alice", scores = {90, 85, 88}},
  {name = "Bob", scores = {75, 80, 70}},
}

print(users[1].name)         --> Alice
print(users[1].scores[1])    --> 90
print(users[2].scores[3])    --> 70

print("===== Lesson 04 完了 =====")
