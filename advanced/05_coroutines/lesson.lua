--[[
  Lesson 05: コルーチン

  この章で学ぶこと:
  - コルーチンの概念（中断・再開可能な関数）
  - coroutine.create / resume / yield
  - coroutine.wrap（簡易版）
  - コルーチンの状態
  - イテレータとしてのコルーチン
  - プロデューサー・コンシューマーパターン
]]

-- ========================================
-- コルーチンとは
-- ========================================

-- コルーチンは「中断・再開」ができる関数
-- 途中で実行を止め（yield）、後から続き（resume）を実行できる
-- スレッドと違い「協調的」（自分で制御を返す）

-- ========================================
-- coroutine.create / resume / yield
-- ========================================

-- coroutine.create: コルーチンを作成
-- coroutine.resume: コルーチンを実行（再開）
-- coroutine.yield: 実行を中断して値を返す

local co = coroutine.create(function()
  print("  ステップ 1")
  coroutine.yield()  -- ここで中断
  print("  ステップ 2")
  coroutine.yield()  -- ここで中断
  print("  ステップ 3")
end)

print("コルーチンの基本:")
coroutine.resume(co)  --> ステップ 1（yield で中断）
coroutine.resume(co)  --> ステップ 2（yield で中断）
coroutine.resume(co)  --> ステップ 3（関数終了）

-- ========================================
-- yield で値を返す / resume で値を渡す
-- ========================================

local co2 = coroutine.create(function(x)
  -- 最初の resume の引数が x に入る
  print("  受信:", x)
  local y = coroutine.yield(x * 2)  -- x*2 を返し、次の resume の引数を受け取る
  print("  受信:", y)
  return y + 10  -- 最後の resume の戻り値になる
end)

print("\n値の送受信:")
-- resume の戻り値: ok(bool), yield/returnの値
local ok, result1 = coroutine.resume(co2, 5)    -- x = 5
print("  yield から:", result1)                   --> 10 (5 * 2)

local ok, result2 = coroutine.resume(co2, 100)  -- y = 100
print("  return から:", result2)                  --> 110 (100 + 10)

-- ========================================
-- coroutine.wrap
-- ========================================

-- wrap は create + resume を簡略化する
-- 通常の関数のように呼べるコルーチンを返す

local counter = coroutine.wrap(function()
  local i = 1
  while true do
    coroutine.yield(i)
    i = i + 1
  end
end)

print("\ncoroutine.wrap:")
print("  1回目:", counter())  --> 1
print("  2回目:", counter())  --> 2
print("  3回目:", counter())  --> 3

-- ========================================
-- コルーチンの状態
-- ========================================

-- coroutine.status(co) で状態を確認
-- suspended: 中断中（yield 後、または開始前）
-- running:   実行中
-- dead:      終了済み
-- normal:    他のコルーチンを resume している状態

local co3 = coroutine.create(function()
  coroutine.yield()
end)

print("\nコルーチンの状態:")
print("  開始前:", coroutine.status(co3))   --> suspended
coroutine.resume(co3)
print("  yield後:", coroutine.status(co3))  --> suspended
coroutine.resume(co3)
print("  終了後:", coroutine.status(co3))   --> dead

-- dead なコルーチンを resume するとエラー
local ok, err = coroutine.resume(co3)
print("  dead を resume:", ok, err)  --> false, cannot resume dead coroutine

-- ========================================
-- イテレータとしてのコルーチン
-- ========================================

-- coroutine.wrap でカスタムイテレータを簡単に作れる

-- range イテレータ
local function range(start, stop, step)
  step = step or 1
  return coroutine.wrap(function()
    local i = start
    while i <= stop do
      coroutine.yield(i)
      i = i + step
    end
  end)
end

print("\nrange イテレータ:")
local nums = {}
for i in range(1, 10, 3) do
  table.insert(nums, i)
end
print("  range(1, 10, 3):", table.concat(nums, ", "))  --> 1, 4, 7, 10

-- フィボナッチイテレータ
local function fibonacci(n)
  return coroutine.wrap(function()
    local a, b = 0, 1
    for _ = 1, n do
      coroutine.yield(a)
      a, b = b, a + b
    end
  end)
end

local fibs = {}
for f in fibonacci(8) do
  table.insert(fibs, f)
end
print("  fibonacci(8):", table.concat(fibs, ", "))  --> 0, 1, 1, 2, 3, 5, 8, 13

-- ========================================
-- プロデューサー・コンシューマーパターン
-- ========================================

-- データの生成と消費を分離するパターン

local function producer(items)
  return coroutine.wrap(function()
    for _, item in ipairs(items) do
      coroutine.yield(item)
    end
  end)
end

local function filter(source, predicate)
  return coroutine.wrap(function()
    for item in source do
      if predicate(item) then
        coroutine.yield(item)
      end
    end
  end)
end

local function map(source, transform)
  return coroutine.wrap(function()
    for item in source do
      coroutine.yield(transform(item))
    end
  end)
end

-- パイプライン: 数値リスト → 偶数フィルタ → 2倍
print("\nパイプライン:")
local data = producer({1, 2, 3, 4, 5, 6, 7, 8})
local evens = filter(data, function(x) return x % 2 == 0 end)
local doubled = map(evens, function(x) return x * 2 end)

local results = {}
for v in doubled do
  table.insert(results, v)
end
print("  結果:", table.concat(results, ", "))  --> 4, 8, 12, 16

-- ========================================
-- Neovimでの活用
-- ========================================

-- Neovimではコルーチンを直接使うことは少ないが、
-- 以下のような場面で内部的に使われている:
--
-- vim.schedule(callback)
--   → メインループに処理を予約（コルーチンの resume に相当）
--
-- plenary.async（telescope.nvim等が使用）
--   → コルーチンベースの非同期処理ライブラリ
--   → await / async パターンをLuaで実現
--
-- 例:
--[[
  local async = require("plenary.async")

  async.void(function()
    local result = async.wrap(vim.fn.jobstart, 2)({
      "git", "status"
    })
    -- 非同期処理の結果を待つ
  end)()
]]

print("\n===== Lesson 05 完了 =====")
