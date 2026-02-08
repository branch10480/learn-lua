--[[
  Exercise 02: エラーハンドリング

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: pcall の基本
-- ========================================

local function risky_function(x)
  if x < 0 then
    error("negative value: " .. x)
  end
  return x * 2
end

-- TODO: pcall を使って risky_function(5) を呼び出し、結果を取得
local ok1, result1 = pcall(risky_function, 5)

assert(ok1 == true, "ok1 は true のはずです")
assert(result1 == 10, "result1 は 10 のはずです")

-- TODO: pcall を使って risky_function(-3) を呼び出し、エラーをキャッチ
local ok2, err2 = pcall(risky_function, -3)

assert(ok2 == false, "ok2 は false のはずです")
assert(type(err2) == "string", "err2 はエラーメッセージ文字列のはずです")
print("問題1: OK")

-- ========================================
-- 問題 2: 安全な型変換
-- ========================================

-- TODO: 安全に文字列を数値に変換する関数を作成
-- 変換できれば数値を返す
-- 変換できなければ第2引数の default 値を返す（default が nil なら 0）
local function safe_tonumber(s, default)
  -- **注意** tonumber()は変換できない場合でもエラーを投げない
  local converted= tonumber(s)
  if not converted then
    return default or 0
  else
    return converted
  end
end

assert(safe_tonumber("42") == 42, "safe_tonumber('42') が正しくありません")
assert(safe_tonumber("3.14") == 3.14, "safe_tonumber('3.14') が正しくありません")
assert(safe_tonumber("abc") == 0, "safe_tonumber('abc') はデフォルト 0 のはずです")
assert(safe_tonumber("abc", -1) == -1, "safe_tonumber('abc', -1) は -1 のはずです")
assert(safe_tonumber(nil, 99) == 99, "safe_tonumber(nil, 99) は 99 のはずです")
print("問題2: OK")

-- ========================================
-- 問題 3: pcall + require パターン
-- ========================================

-- TODO: 存在しないモジュール "nonexistent_plugin" を安全に読み込む
-- 読み込みに失敗した場合、fallback にデフォルトのテーブルを設定する
-- デフォルトテーブル: { enabled = false, name = "fallback" }

local plugin = nil
local fallback = nil

-- ここから下に実装
local ok
ok, plugin = pcall(require, "nonexistent_plugin")
if not ok then
  fallback = { enabled = false, name = "fallback" }
end
-- ここまで

assert(fallback ~= nil, "fallback が nil です")
assert(fallback.enabled == false, "fallback.enabled が正しくありません")
assert(fallback.name == "fallback", "fallback.name が正しくありません")
print("問題3: OK")

-- ========================================
-- 問題 4: xpcall とエラーハンドラ
-- ========================================

-- TODO: xpcall を使って以下の関数を呼び、カスタムエラーハンドラで
-- エラーメッセージの先頭に "[ERROR] " を付けて返す

local function buggy_function()
  error("something went wrong")
end

local ok4, result4 = nil, nil

-- ここから下に実装
ok4, result4 = xpcall(
  buggy_function,
  function (err) return "[ERROR]" .. err end
)
-- ここまで

assert(ok4 == false, "ok4 は false のはずです")
assert(result4:find("^%[ERROR%]"), "result4 は '[ERROR] ' で始まるはずです")
assert(result4:find("something went wrong"), "元のエラーメッセージが含まれていません")
print("問題4: OK")

-- ========================================
-- 問題 5: バリデーション関数
-- ========================================

-- TODO: ユーザー情報を検証する関数を作成
-- validate_user(user) は:
--   user が nil なら error("user is required")
--   user.name が nil なら error("name is required")
--   user.age が数値でなければ error("age must be a number")
--   user.age が 0 未満なら error("age must be non-negative")
--   全て OK なら true を返す

local function validate_user(user)
  if user == nil then error("user is required") end
  if user.name == nil then error("name is required") end
  if type(user.age) ~= "number" then error("age must be a number") end
  if user.age < 0 then error("age must be non-negative") end
  return true
end

-- 正常ケース
assert(validate_user({name = "Alice", age = 25}) == true, "正常な入力で true を返すはずです")

-- 異常ケース
local ok5a, err5a = pcall(validate_user, nil)
assert(not ok5a, "nil で error が発生するはずです")

local ok5b, err5b = pcall(validate_user, {age = 25})
assert(not ok5b, "name なしで error が発生するはずです")

local ok5c, err5c = pcall(validate_user, {name = "Bob", age = "young"})
assert(not ok5c, "age が文字列で error が発生するはずです")

local ok5d, err5d = pcall(validate_user, {name = "Charlie", age = -5})
assert(not ok5d, "age が負で error が発生するはずです")
print("問題5: OK")

-- ========================================
-- 問題 6: 安全なネストアクセス
-- ========================================

-- TODO: ネストしたテーブルに安全にアクセスする関数を作成
-- safe_get(t, key1, key2, ...) は:
--   t[key1][key2]... と順にアクセスする
--   途中で nil に当たったら nil を返す（エラーにならない）
-- ヒント: select("#", ...) で可変長引数の個数を取得できる
--         select(i, ...) で i 番目以降の引数を取得できる

local function safe_get(t, ...)
  if t == nil then return nil end

  local args = {...}
  local tmp = t
  for _, v in ipairs(args) do
    if tmp[v] == nil then
      return nil
    end
    tmp = tmp[v]
  end
  return tmp
end

local data = {
  user = {
    profile = {
      name = "Alice",
      address = {
        city = "Tokyo"
      }
    }
  }
}

assert(safe_get(data, "user", "profile", "name") == "Alice", "safe_get で name にアクセスできません")
assert(safe_get(data, "user", "profile", "address", "city") == "Tokyo", "safe_get で city にアクセスできません")
assert(safe_get(data, "user", "settings", "theme") == nil, "存在しないパスは nil を返すはずです")
assert(safe_get(data, "nonexistent") == nil, "存在しないキーは nil を返すはずです")
assert(safe_get(nil, "key") == nil, "nil テーブルは nil を返すはずです")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: 安全なプラグインローダー
-- ========================================

-- TODO: 複数のモジュール名を受け取り、それぞれ安全に読み込む関数を作成
-- load_plugins(names) は:
--   names: モジュール名の配列（例: {"mathutil", "nonexistent", "another"}）
--   戻り値: { loaded = { name = module, ... }, errors = { name = err_msg, ... } }
--
-- 同ディレクトリの mathutil.lua を利用する

local dir = arg[0]:match("(.*/)")  or "./"
package.path = dir .. "../01_modules/?.lua;" .. package.path

local function load_plugins(names)
  local result = {
    loaded = {},
    errors = {},
  }
  for _, name in ipairs(names) do
    local ok, mod = pcall(require, name)
    if not ok then
      result.errors[name] = mod
    else
      result.loaded[name] = mod
    end
  end
  return result
end

local result = load_plugins({"mathutil", "nonexistent_module", "another_missing"})

assert(result.loaded.mathutil ~= nil, "mathutil は読み込めるはずです")
assert(result.loaded.mathutil.add(1, 2) == 3, "mathutil.add が動作しません")
assert(result.errors.nonexistent_module ~= nil, "nonexistent_module はエラーのはずです")
assert(result.errors.another_missing ~= nil, "another_missing はエラーのはずです")
assert(result.loaded.nonexistent_module == nil, "nonexistent_module は loaded に含まれないはずです")

print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
