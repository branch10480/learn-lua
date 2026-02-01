--[[
  Exercise 01: 変数とデータ型

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: 変数の宣言
-- ========================================

-- TODO: ローカル変数 name に自分の名前を代入してください
local name = nil  -- ここを修正

-- TODO: ローカル変数 age に数値で年齢を代入してください
local age = nil  -- ここを修正

print("名前:", name)
print("年齢:", age)

-- ========================================
-- 問題 2: 文字列結合
-- ========================================

local first_name = "Taro"
local last_name = "Yamada"

-- TODO: first_name と last_name を結合して full_name を作成
-- 期待値: "Taro Yamada"（間にスペースを入れる）
local full_name = nil  -- ここを修正

print("フルネーム:", full_name)
assert(full_name == "Taro Yamada", "full_name が正しくありません")

-- ========================================
-- 問題 3: 型変換
-- ========================================

local price_str = "1500"
local tax_rate = 0.1

-- TODO: price_str を数値に変換し、税込価格を計算
-- 期待値: 1650 (1500 + 1500 * 0.1)
local total_price = nil  -- ここを修正

print("税込価格:", total_price)
assert(total_price == 1650, "total_price が正しくありません")

-- ========================================
-- 問題 4: 文字列の長さ
-- ========================================

local message = "Hello, Lua!"

-- TODO: message の文字数を取得して length に代入
local length = nil  -- ここを修正

print("文字数:", length)
assert(length == 11, "length が正しくありません")

-- ========================================
-- 問題 5: 複数同時代入
-- ========================================

-- TODO: 一行で x, y, z にそれぞれ 100, 200, 300 を代入
local x, y, z  -- ここを修正（= 以降を追加）

print("x:", x, "y:", y, "z:", z)
assert(x == 100 and y == 200 and z == 300, "x, y, z が正しくありません")

-- ========================================
-- 問題 6: type() の使用
-- ========================================

local mystery_value = "42"

-- TODO: mystery_value の型を取得して value_type に代入
local value_type = nil  -- ここを修正

print("型:", value_type)
assert(value_type == "string", "value_type が正しくありません")

print("\n===== 全ての問題をクリアしました！ =====")
