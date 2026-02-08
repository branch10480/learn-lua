--[[
  Exercise 01: モジュールとrequire

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- 同ディレクトリのモジュールを読み込めるようにする
local dir = arg[0]:match("(.*/)")  or "./"
package.path = dir .. "?.lua;" .. package.path

-- ========================================
-- 問題 1: モジュールの読み込み
-- ========================================

-- TODO: mathutil モジュールを require で読み込む
local mathutil = require("mathutil")

assert(mathutil ~= nil, "mathutil が読み込めていません")
assert(mathutil.add(2, 3) == 5, "mathutil.add が正しくありません")
assert(mathutil.mul(4, 5) == 20, "mathutil.mul が正しくありません")
print("問題1: OK")

-- ========================================
-- 問題 2: モジュールのキャッシュ確認
-- ========================================

-- TODO: package.loaded を使って mathutil がキャッシュされているか確認
local is_cached = package.loaded["mathutil"] ~= nil  -- ここを修正（true/false を返す式にする）

assert(is_cached == true, "mathutil がキャッシュされていません")

-- TODO: mathutil を再度 require して、同じオブジェクトか確認
local mathutil2 = require("mathutil")

assert(mathutil == mathutil2, "キャッシュされたオブジェクトと異なります")
print("問題2: OK")

-- ========================================
-- 問題 3: 基本的なモジュール作成
-- ========================================

-- TODO: 以下の機能を持つモジュール（テーブル）を作成
-- greet(name): "Hello, <name>!" を返す
-- farewell(name): "Goodbye, <name>!" を返す

local greeter = {}

-- ここから下に実装

greeter.greet = function (name)
  return "Hello, " .. name .. "!"
end

function greeter.farewell(name)
  return "Goodbye, " .. name .. "!"
end

-- ここまで

assert(greeter.greet("Alice") == "Hello, Alice!", "greet が正しくありません")
assert(greeter.farewell("Bob") == "Goodbye, Bob!", "farewell が正しくありません")
print("問題3: OK")

-- ========================================
-- 問題 4: プライベート関数とパブリック関数
-- ========================================

-- TODO: 以下の仕様のモジュールを作成
-- プライベート関数 validate(x): x が数値なら true を返す
-- パブリック関数 M.safe_sqrt(x):
--   validate で検証し、数値でなければ nil, "not a number" を返す
--   負の数なら nil, "negative number" を返す
--   それ以外は math.sqrt(x) を返す

local M = {}

-- ここから下に実装

local function validate(x)
  return type(x) == "number"
end

function M.safe_sqrt(x)
  if not validate(x) then
    return nil, "not a number"
  elseif x < 0 then
    return nil, "negative number"
  else
    return math.sqrt(x)
  end
end
-- ここまで

local result1 = M.safe_sqrt(16)
assert(result1 == 4, "safe_sqrt(16) が正しくありません")

local result2, err2 = M.safe_sqrt("abc")
assert(result2 == nil, "safe_sqrt('abc') は nil を返すべきです")
assert(err2 == "not a number", "エラーメッセージが正しくありません")

local result3, err3 = M.safe_sqrt(-1)
assert(result3 == nil, "safe_sqrt(-1) は nil を返すべきです")
assert(err3 == "negative number", "エラーメッセージが正しくありません")
print("問題4: OK")

-- ========================================
-- 問題 5: setup() パターン
-- ========================================

-- TODO: setup() パターンでデフォルト設定をマージする関数を作成
-- デフォルト設定:{ width = 80, height = 24, color = "white" }
-- setup(opts) で opts のキーだけ上書きする

local screen = {
  config = {}
}

-- ここから下に実装

screen.defaults = { width = 80, height = 24, color = "white" }

function screen.setup(x)
  local opts = x or {}
  for k, v in pairs(screen.defaults) do
    if opts[k] ~= nil then
      screen.config[k] = opts[k]
    else
      screen.config[k] = v
    end
  end
end

-- ここまで

-- デフォルト設定のテスト
screen.setup()
assert(screen.config.width == 80, "デフォルトの width が正しくありません")
assert(screen.config.height == 24, "デフォルトの height が正しくありません")
assert(screen.config.color == "white", "デフォルトの color が正しくありません")

-- カスタム設定のテスト
screen.setup({ width = 120, color = "blue" })
assert(screen.config.width == 120, "カスタムの width が正しくありません")
assert(screen.config.height == 24, "height はデフォルトのままのはずです")
assert(screen.config.color == "blue", "カスタムの color が正しくありません")
print("問題5: OK")

-- ========================================
-- 問題 6: do...end スコープ
-- ========================================

-- TODO: do...end ブロックを使って、ブロック内でのみ有効な変数を作成
-- ブロック内で counter = 0 を定義し、1〜10を足し合わせて result に格納
-- ブロック外の result_from_block に結果を代入する

local result_from_block = 0

-- ここから下に実装
do
  local counter = 0
  for i = 1, 10 do
    counter = counter + i
  end
  result_from_block = counter
end
-- ここまで

assert(result_from_block == 55, "result_from_block が正しくありません（期待値: 55）")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: プラグイン風モジュール
-- ========================================

-- TODO: Neovimプラグイン風の完全なモジュールを作成
-- 仕様:
-- 1. counter モジュールを作成（local Counter = {}）
-- 2. デフォルト設定: { start = 0, step = 1 }
-- 3. Counter.setup(opts) でデフォルト設定とマージ
-- 4. Counter.new() で新しいカウンターインスタンスを返す
--    インスタンスは { value = config.start } を持つ
-- 5. Counter.increment(instance) で instance.value に config.step を加算
-- 6. Counter.get_value(instance) で instance.value を返す

local Counter = {}

-- ここから下に実装
Counter.defaults = { start = 0, step = 1 }
Counter.config = {}

function Counter.setup(x)
  local opts = x or {}
  for k, v in pairs(Counter.defaults) do
    if opts[k] ~= nil then
      Counter.config[k] = opts[k]
    else
      Counter.config[k] = v
    end
  end
end

function Counter.new()
  local self = {
    value = Counter.config.start
  }
  return self
end

function Counter:increment()
  self.value = self.value + Counter.config.step
end

function Counter:get_value()
  return self.value
end


-- ここまで

-- テスト: デフォルト設定
Counter.setup()
local c1 = Counter.new()
assert(Counter.get_value(c1) == 0, "初期値が正しくありません")
Counter.increment(c1)
Counter.increment(c1)
assert(Counter.get_value(c1) == 2, "increment 後の値が正しくありません")

-- テスト: カスタム設定
Counter.setup({ start = 10, step = 5 })
local c2 = Counter.new()
assert(Counter.get_value(c2) == 10, "カスタム初期値が正しくありません")
Counter.increment(c2)
assert(Counter.get_value(c2) == 15, "カスタム step の increment が正しくありません")

print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
