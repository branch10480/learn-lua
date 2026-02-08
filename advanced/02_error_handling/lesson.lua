--[[
  Lesson 02: エラーハンドリング

  この章で学ぶこと:
  - error() でエラーを発生させる
  - pcall（保護呼び出し）でエラーをキャッチする
  - xpcall でカスタムエラーハンドラを使う
  - pcall + require パターン（Neovimで最頻出）
  - assert の仕組み
]]

-- ========================================
-- error() でエラーを発生させる
-- ========================================

-- error() は実行を中断してエラーを発生させる
-- error("メッセージ") が基本形

local function divide(a, b)
  if b == 0 then
    error("ゼロで割ることはできません")
  end
  return a / b
end

-- 正常な呼び出し
print("10 / 3 =", divide(10, 3))  --> 3.3333...

-- error() の第2引数でエラーレベルを指定できる
-- error("msg", 1) → 呼び出し元の位置を表示（デフォルト）
-- error("msg", 2) → その上の呼び出し元
-- error("msg", 0) → 位置情報なし

-- ========================================
-- pcall（保護呼び出し）
-- ========================================

-- pcall は "protected call" の略
-- エラーが起きてもプログラムが停止しない

-- 基本形: local ok, result = pcall(関数, 引数...)
-- 成功時: ok = true,  result = 戻り値
-- 失敗時: ok = false, result = エラーメッセージ

local ok, result = pcall(divide, 10, 3)
print("\n成功時: ok =", ok, "result =", result)  --> true, 3.3333...

local ok2, err = pcall(divide, 10, 0)
print("失敗時: ok =", ok2, "err =", err)  --> false, エラーメッセージ

-- よく使うパターン: エラー時にデフォルト値を使う
local ok3, value = pcall(divide, 10, 0)
if not ok3 then
  value = 0  -- デフォルト値
  print("エラーが発生したのでデフォルト値を使用:", value)
end

-- ========================================
-- pcall + require パターン（Neovim最頻出）
-- ========================================

-- Neovim設定でプラグインを読み込むとき、
-- プラグインが未インストールの場合にエラーで止まらないようにする

--[[
  Neovimでの実際の使い方:

  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("telescope is not installed", vim.log.levels.WARN)
    return
  end
  telescope.setup({ ... })
]]

-- 実際に存在しないモジュールで試す
local ok4, mod = pcall(require, "this_module_does_not_exist")
print("\n存在しないモジュール: ok =", ok4)  --> false
print("エラー:", mod)

-- ========================================
-- xpcall（カスタムエラーハンドラ）
-- ========================================

-- xpcall はエラー発生時に独自のハンドラ関数を実行できる
-- xpcall(関数, エラーハンドラ, 引数...)
-- ※ Lua 5.1 では xpcall(関数, エラーハンドラ) のみ（引数なし）

local function error_handler(err)
  return "カスタムエラー: " .. err
end

-- Lua 5.1 互換の書き方（引数を渡す場合はクロージャを使う）
local ok5, result5 = xpcall(
  function() return divide(10, 0) end,
  error_handler
)
print("\nxpcall 結果:", ok5, result5)

-- debug.traceback をエラーハンドラとして使うと
-- エラー発生箇所のスタックトレースが得られる
local ok6, trace = xpcall(
  function() return divide(10, 0) end,
  debug.traceback
)
print("\nスタックトレース:")
print(trace)

-- ========================================
-- assert の仕組み
-- ========================================

-- assert(value, message) は:
-- value が true（nil/false 以外）なら value を返す
-- value が false/nil なら error(message) を呼ぶ

-- つまり assert は内部的にはこう動く:
--[[
  function assert(v, msg)
    if not v then
      error(msg or "assertion failed!")
    end
    return v
  end
]]

-- 値を受け取るのにも使える
local n = assert(tonumber("42"), "数値に変換できません")
print("\nassert で値を受け取る:", n)  --> 42

-- pcall + assert の組み合わせ
local ok7, err7 = pcall(function()
  assert(tonumber("abc"), "数値に変換できません")
end)
print("pcall + assert:", ok7, err7)  --> false, エラーメッセージ

-- ========================================
-- エラーハンドリングのパターン集
-- ========================================

-- パターン1: デフォルト値
local function safe_tonumber(s, default)
  local n = tonumber(s)
  if n == nil then
    return default or 0
  end
  return n
end

print("\nsafe_tonumber('42') =", safe_tonumber("42"))      --> 42
print("safe_tonumber('abc') =", safe_tonumber("abc"))      --> 0
print("safe_tonumber('abc', -1) =", safe_tonumber("abc", -1))  --> -1

-- パターン2: ok, value パターン（多値返却）
local function parse_int(s)
  local n = tonumber(s)
  if n == nil then
    return nil, "'" .. s .. "' は数値ではありません"
  end
  return math.floor(n)
end

local val, err = parse_int("hello")
if not val then
  print("パースエラー:", err)
end

print("\n===== Lesson 02 完了 =====")
