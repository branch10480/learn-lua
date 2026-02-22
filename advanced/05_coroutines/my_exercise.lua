--[[
  Exercise 05: コルーチン

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: 基本的なコルーチン
-- ========================================

-- TODO: 1, 2, 3 を順番に yield するコルーチンを作成
-- coroutine.create を使う

local co = nil  -- ここを修正

-- ここから下に実装
co = coroutine.create(function ()
  coroutine.yield(1)
  coroutine.yield(2)
  return 3
end)
-- ここまで

local ok1, v1 = coroutine.resume(co)
local ok2, v2 = coroutine.resume(co)
local ok3, v3 = coroutine.resume(co)

assert(v1 == 1, "1回目の yield が正しくありません")
assert(v2 == 2, "2回目の yield が正しくありません")
assert(v3 == 3, "3回目の yield が正しくありません")
assert(coroutine.status(co) == "dead", "コルーチンが終了していません")
print("問題1: OK")

-- ========================================
-- 問題 2: 値の送受信
-- ========================================

-- TODO: resume で受け取った値を2倍にして yield するコルーチンを作成
-- 3回の yield を行い、毎回受け取った値を2倍にして返す

local doubler = nil  -- ここを修正

-- ここから下に実装
doubler = coroutine.create(function (x)
  local counter = 1
  local num = x
  while true do
    if counter == 3 then return num * 2 end
    num = coroutine.yield(num * 2)
    counter = counter + 1
  end
end)
-- ここまで

local _, r1 = coroutine.resume(doubler, 5)
assert(r1 == 10, "5 の2倍が正しくありません: " .. tostring(r1))

local _, r2 = coroutine.resume(doubler, 7)
assert(r2 == 14, "7 の2倍が正しくありません: " .. tostring(r2))

local _, r3 = coroutine.resume(doubler, 0)
assert(r3 == 0, "0 の2倍が正しくありません: " .. tostring(r3))
print("問題2: OK")

-- ========================================
-- 問題 3: coroutine.wrap
-- ========================================

-- TODO: coroutine.wrap を使って、アルファベットを順に返すイテレータを作成
-- letters(start, finish): start から finish までの文字を返す
-- 例: letters("a", "d") → "a", "b", "c", "d"
-- ヒント: string.byte で文字→数値、string.char で数値→文字

local function letters(start, finish)
  return coroutine.wrap(function ()
    local c = start
    while true do
      coroutine.yield(c)

      if c == finish then
        return nil
      end

      c = string.char(string.byte(c) + 1)
    end
  end)
end

local result3 = {}
for ch in letters("a", "e") do
  table.insert(result3, ch)
end

assert(table.concat(result3) == "abcde", "letters が正しくありません: " .. table.concat(result3))

local result3b = {}
for ch in letters("x", "z") do
  table.insert(result3b, ch)
end
assert(table.concat(result3b) == "xyz", "letters(x, z) が正しくありません")
print("問題3: OK")

-- ========================================
-- 問題 4: range イテレータ
-- ========================================

-- TODO: range(start, stop, step) イテレータをコルーチンで実装
-- step のデフォルト値は 1
-- start から stop まで step ずつ増加する値を yield

local function range(start, stop, step)
  return coroutine.wrap(function ()
    local i = start
    local step = step or 1
    while true do
      coroutine.yield(i)
      if i + step > stop then
        return nil
      end
      i = i + step
    end
  end)
end

local r4a = {}
for i in range(1, 5) do
  table.insert(r4a, i)
end
assert(#r4a == 5, "range(1, 5) の要素数が正しくありません")
assert(r4a[1] == 1 and r4a[5] == 5, "range(1, 5) の値が正しくありません")

local r4b = {}
for i in range(0, 10, 3) do
  table.insert(r4b, i)
end
assert(#r4b == 4, "range(0, 10, 3) の要素数が正しくありません: " .. #r4b)
assert(r4b[1] == 0 and r4b[4] == 9, "range(0, 10, 3) の値が正しくありません")
print("問題4: OK")

-- ========================================
-- 問題 5: パイプライン
-- ========================================

-- TODO: コルーチンを使ったパイプライン関数を2つ作成
-- filter_co(source, predicate): source から条件を満たす要素だけを返す
-- map_co(source, transform): source の各要素を変換して返す
-- source は for ループで回せるイテレータ関数

local function from_table(t)
  return coroutine.wrap(function()
    for _, v in ipairs(t) do
      coroutine.yield(v)
    end
  end)
end

local function filter_co(source, predicate)
  return coroutine.wrap(function ()
    for v in source do
      if predicate(v) then
        coroutine.yield(v)
      end
    end
    return nil
  end)
end

local function map_co(source, transform)
  return coroutine.wrap(function ()
    for v in source do
      coroutine.yield(transform(v))
    end
    return nil
  end)
end

-- パイプライン: [1..8] → 奇数のみ → 3倍
local src = from_table({1, 2, 3, 4, 5, 6, 7, 8})
local odds = filter_co(src, function(x) return x % 2 == 1 end)
local tripled = map_co(odds, function(x) return x * 3 end)

local r5 = {}
for v in tripled do
  table.insert(r5, v)
end

assert(#r5 == 4, "パイプラインの要素数が正しくありません: " .. #r5)
assert(r5[1] == 3, "r5[1] が正しくありません")
assert(r5[2] == 9, "r5[2] が正しくありません")
assert(r5[3] == 15, "r5[3] が正しくありません")
assert(r5[4] == 21, "r5[4] が正しくありません")
print("問題5: OK")

-- ========================================
-- 問題 6: 状態マシン
-- ========================================

-- TODO: コルーチンで信号機の状態マシンを実装
-- green → yellow → red → green → ... の順で遷移する
-- next_state() を呼ぶたびに次の状態の文字列を返す
-- coroutine.wrap を使う

local function create_traffic_light()
  return coroutine.wrap(function ()
    local states = {
      "green",
      "yellow",
      "red",
    }
    local i = 1
    while true do
      coroutine.yield(states[i])
      i = i + 1
      if i > 3 then i = 1 end
    end
  end)
end

local next_state = create_traffic_light()

assert(next_state() == "green", "最初は green のはずです")
assert(next_state() == "yellow", "2番目は yellow のはずです")
assert(next_state() == "red", "3番目は red のはずです")
assert(next_state() == "green", "4番目は green のはずです（ループ）")
assert(next_state() == "yellow", "5番目は yellow のはずです")
assert(next_state() == "red", "6番目は red のはずです")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: タスクスケジューラー
-- ========================================

-- TODO: 複数のコルーチンを順番に実行するスケジューラーを作成
-- 仕様:
-- 1. Scheduler.new() でスケジューラーを作成
-- 2. Scheduler:add_task(func) でタスク（関数）を追加
--    タスクは coroutine.create で包む
-- 3. Scheduler:run() で全タスクを実行
--    各タスクを1回ずつ resume し、dead でないものを次のラウンドに回す
--    全タスクが dead になったら終了
-- 4. Scheduler:get_log() で実行ログの配列を返す
--    タスク内で coroutine.yield(message) するたびに message がログに記録される

local Scheduler = {}
Scheduler.__index = Scheduler

-- ここから下に実装
function Scheduler.new()
  return setmetatable({ tasks = {}, logs = {} }, Scheduler)
end

function Scheduler:add_task(func)
  table.insert(self.tasks, coroutine.create(func))
end

function Scheduler:run()
  local co_count = #self.tasks
  local dead_count = 0
  while true do
    for _, co in ipairs(self.tasks) do
      if coroutine.status(co) == "dead" then
        dead_count = dead_count + 1
      else
        local _, message = coroutine.resume(co)
        if message ~= nil then
          table.insert(self.logs, message)
        end
      end
    end

    if dead_count == co_count then
      break
    end

    dead_count = 0
  end
end

function Scheduler:get_log()
  return self.logs
end

-- ここまで

local sched = Scheduler.new()

sched:add_task(function()
  coroutine.yield("A-1")
  coroutine.yield("A-2")
  coroutine.yield("A-3")
end)

sched:add_task(function()
  coroutine.yield("B-1")
  coroutine.yield("B-2")
end)

sched:add_task(function()
  coroutine.yield("C-1")
end)

sched:run()

local log = sched:get_log()
-- ラウンド1: A-1, B-1, C-1
-- ラウンド2: A-2, B-2（C は dead）
-- ラウンド3: A-3（B は dead）
assert(#log == 6, "ログの数が正しくありません: " .. #log)
assert(log[1] == "A-1", "log[1] が正しくありません: " .. tostring(log[1]))
assert(log[2] == "B-1", "log[2] が正しくありません: " .. tostring(log[2]))
assert(log[3] == "C-1", "log[3] が正しくありません: " .. tostring(log[3]))
assert(log[4] == "A-2", "log[4] が正しくありません: " .. tostring(log[4]))
assert(log[5] == "B-2", "log[5] が正しくありません: " .. tostring(log[5]))
assert(log[6] == "A-3", "log[6] が正しくありません: " .. tostring(log[6]))

print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
