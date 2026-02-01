--[[
  Exercise 02: 制御構造

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: if 文の条件分岐
-- ========================================

local temperature = 28

-- TODO: 温度に応じてメッセージを設定
-- 30以上: "暑い"
-- 20以上30未満: "快適"
-- 20未満: "寒い"
local weather_message = nil  -- ここにif文を書いて値を設定

-- ここから下に if 文を書いてください
--
if temperature >= 30 then
    weather_message = "暑い"
elseif temperature >= 20 then
    weather_message = "快適"
else
    weather_message = "寒い"
end

-- ここまで

print("気温:", temperature, "->", weather_message)
assert(weather_message == "快適", "weather_message が正しくありません")

-- ========================================
-- 問題 2: 論理演算子
-- ========================================

local is_weekend = true
local is_holiday = false

-- TODO: 週末または祝日なら "休み"、そうでなければ "仕事" を設定
-- ヒント: or を使う
local day_type = nil  -- ここを修正

-- ここから下に処理を書いてください

if is_weekend or is_holiday then
    day_type = "休み"
else
    day_type = "仕事"
end

-- ここまで

print("今日は:", day_type)
assert(day_type == "休み", "day_type が正しくありません")

-- ========================================
-- 問題 3: 数値 for ループ
-- ========================================

-- TODO: 1から10までの合計を計算して sum に代入
-- 期待値: 55 (1+2+3+...+10)
local sum = 0

-- ここから下に for 文を書いてください

for i = 1, 10 do
    sum = sum + i
end

-- ここまで

print("1から10の合計:", sum)
assert(sum == 55, "sum が正しくありません")

-- ========================================
-- 問題 4: while ループ
-- ========================================

-- TODO: 2の累乗を計算し、100を超えるまでの最大値を求める
-- 期待値: 64 (2, 4, 8, 16, 32, 64, 128 のうち100以下の最大)
local power_of_two = 1

-- ここから下に while 文を書いてください

while power_of_two * 2 <= 100 do
    power_of_two = power_of_two * 2
end

-- ここまで

print("100以下の2の累乗の最大値:", power_of_two)
assert(power_of_two == 64, "power_of_two が正しくありません")

-- ========================================
-- 問題 5: break の使用
-- ========================================

local numbers = {3, 7, 2, 9, 5, 1, 8}

-- TODO: 配列から最初に見つかる偶数を探す
-- 期待値: 2
local first_even = nil

-- ここから下に for 文と break を書いてください

for index, value in ipairs(numbers) do
    if value % 2 == 0 then
        first_even = value
        break
    end
end

-- ここまで

print("最初の偶数:", first_even)
assert(first_even == 2, "first_even が正しくありません")

-- ========================================
-- 問題 6: 不等号演算子
-- ========================================

local x = 10
local y = 10

-- TODO: x と y が等しくないかどうかを判定
-- ヒント: Lua では != ではなく ~= を使う
local not_equal = x ~= y  -- ここを修正

print("x ~= y:", not_equal)
assert(not_equal == false, "not_equal が正しくありません")

-- ========================================
-- チャレンジ問題: FizzBuzz
-- ========================================

-- TODO: 1から15までの FizzBuzz を実行
-- 3の倍数なら "Fizz"、5の倍数なら "Buzz"、
-- 両方の倍数なら "FizzBuzz"、それ以外は数値を出力

print("\n--- FizzBuzz ---")
-- ここから下に FizzBuzz を実装してください

for i = 1, 15 do
    if i % 15 == 0 then
        print("FizzBuzz")
    elseif i % 3 == 0 then
        print("Fizz")
    elseif i % 5 == 0 then
        print("Buzz")
    else
        print(i)
    end
end

-- ここまで

print("\n===== 全ての問題をクリアしました！ =====")
