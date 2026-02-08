--[[
  Lesson 01: モジュールとrequire

  この章で学ぶこと:
  - require の仕組みとモジュールの読み込み
  - モジュールの作り方（local M = {} パターン）
  - package.path とモジュール検索
  - モジュールのキャッシュ
  - setup() パターン（Neovimプラグインで頻出）
]]

-- 同ディレクトリのモジュールを読み込めるようにする
--
-- arg[0] は実行中のスクリプトのファイルパス
--   例: /path/to/advanced/01_modules/lesson.lua
-- 「:」はメソッド呼び出し構文（シンタックスシュガー）
--   シンタックスシュガー = 書き方を簡単にするための構文上のショートカット
--   動作は全く同じだが、より短く・読みやすく書ける
--   arg[0]:match("(.*/)")  は string.match(arg[0], "(.*/)") と同じ
--   「:」を使うと自分自身を第1引数として自動的に渡してくれる
--   関数定義でも使える: function M:greet(msg) → self が暗黙の第1引数になる
-- :match("(.*/)" は最後の "/" までを抜き出す（= ディレクトリ部分の取得）
--   例: /path/to/advanced/01_modules/
-- or "./" はマッチしなかった場合のフォールバック（カレントディレクトリ）
local dir = arg[0]:match("(.*/)")  or "./"
--
-- package.path は require() がモジュールを探すときに使うパスのリスト
-- 形式: "./?.lua;/usr/local/share/lua/5.1/?.lua;..." のようにセミコロン区切り
--   "?" は require("mathutil") の "mathutil" に置き換わるプレースホルダー
--   ";" は各パスの区切り文字
--
-- dir .. "?.lua;" で "/path/to/01_modules/?.lua;" というテンプレートを作り、
-- 既存の package.path の先頭に追加する
-- → require("mathutil") 時に /path/to/01_modules/mathutil.lua を最優先で探す
-- → どのディレクトリから実行しても、同じフォルダのモジュールを読み込める
package.path = dir .. "?.lua;" .. package.path

-- ========================================
-- require の基本
-- ========================================

-- require はモジュール（別の .lua ファイル）を読み込む関数
-- モジュールが return した値を受け取る

local mathutil = require("mathutil")
print("3 + 5 =", mathutil.add(3, 5))       --> 8
print("10 / 3 =", mathutil.div(10, 3))     --> 3.3333...

-- ========================================
-- モジュールとは何か
-- ========================================

-- モジュール = 変更可能なシングルトンオブジェクト（テーブル）
--
-- シングルトン: require すると常に同じ1つのテーブルが返される
--   local m1 = require("mathutil")
--   local m2 = require("mathutil")
--   print(m1 == m2)  --> true（同じもの）
--
-- クラスとの違い:
--   クラスは new() するたびに別のインスタンスを作れる「設計図」
--   モジュールは常に1つしか存在しない
--
-- 「変更可能」: モジュールはただのテーブルなので後から上書きできる
--   M.add = function(a, b) return 0 end  -- 上書き可能（保護機構はない）

-- ========================================
-- モジュールの作り方
-- ========================================

-- 最も一般的なパターン:
--   local M = {}
--   function M.func_name() ... end
--   return M

-- mathutil.lua の中身はまさにこのパターン:
--[[
  local M = {}
  function M.add(a, b) return a + b end
  function M.sub(a, b) return a - b end
  return M
]]

-- Neovimプラグインもほぼ全てこのパターンで書かれている
-- 例: require("telescope").setup({})

-- ========================================
-- モジュールのキャッシュ
-- ========================================

-- require は同じモジュールを2回読み込まない（キャッシュされる）
local m1 = require("mathutil")
local m2 = require("mathutil")
print("同じオブジェクト?", m1 == m2)  --> true

-- キャッシュは package.loaded に格納される
print("キャッシュ確認:", package.loaded["mathutil"] ~= nil)  --> true

-- キャッシュをクリアすると再読み込みできる
-- package.loaded["mathutil"] = nil
-- local m3 = require("mathutil")  -- 再度ファイルを実行する

-- ========================================
-- package.path とモジュール検索
-- ========================================

-- require("foo") はどこからファイルを探す？
-- package.path に定義されたパターンを順番に試す
print("\npackage.path:")
-- gmatch (global match): パターンに一致する部分を繰り返し取り出すイテレータ関数
--   match  → 最初の1つだけ返す
--   gmatch → 全てのマッチを順番に返す
--   find   → マッチした位置（開始・終了）を返す
--
-- "[^;]+" の意味:
--   [^;] → ";" 以外の任意の1文字（^ は [] の先頭にあると「否定」を意味する）
--   +    → 1個以上の繰り返し
--   → セミコロン区切りの文字列を1つずつ分割して取り出している
--
-- 注意: Luaのパターンは正規表現ではない（似ているが別物）
--   正規表現との主な違い:
--     エスケープ: \d ではなく %d（数字）、%a（アルファベット）のように % を使う
--     OR (a|b) や 繰り返し回数 {2,5} はLuaパターンにはない
for path in package.path:gmatch("[^;]+") do
  print("  " .. path)
end

-- パターン中の ? がモジュール名に置換される
-- 例: "./?.lua" で require("foo") → "./foo.lua" を探す

-- Neovimでは lua/ ディレクトリが自動的にパスに含まれる
-- ~/.config/nvim/lua/plugins.lua → require("plugins")
-- ~/.config/nvim/lua/plugins/init.lua → require("plugins")

-- ========================================
-- do...end ブロックによるスコープ
-- ========================================

-- モジュールを使わなくてもスコープを分離できる
do
  local secret = "この変数はブロック外からアクセスできない"
  print("ブロック内:", secret)
end
-- print(secret)  --> nil（アクセス不可）

-- ========================================
-- プライベート関数とパブリック関数
-- ========================================

-- モジュール内で local 宣言した関数は外部からアクセスできない
-- M に登録した関数だけが公開される

--[[
  local M = {}

  -- プライベート: モジュール外からアクセス不可
  local function validate(x)
    return type(x) == "number"
  end

  -- パブリック: M.safe_add() として外部から呼べる
  function M.safe_add(a, b)
    if not validate(a) or not validate(b) then
      error("numbers required")
    end
    return a + b
  end

  return M
]]

-- ========================================
-- setup() パターン
-- ========================================

-- Neovimプラグインで最も頻出するパターン
-- デフォルト設定をユーザーの設定で上書きする

--[[
  local M = {}

  -- デフォルト設定
  local defaults = {
    enabled = true,
    max_items = 50,
    theme = "dark",
  }

  -- 現在の設定
  M.config = {}

  function M.setup(opts)
    -- opts が nil でも動くようにする
    opts = opts or {}
    -- デフォルト値とマージ
    for k, v in pairs(defaults) do
      if opts[k] ~= nil then
        M.config[k] = opts[k]
      else
        M.config[k] = v
      end
    end
  end

  return M
]]

-- 使い方:
-- local plugin = require("my_plugin")
-- plugin.setup({ theme = "light" })
-- print(plugin.config.theme)       --> "light"
-- print(plugin.config.max_items)   --> 50（デフォルト値）

-- Neovimでよく見る書き方:
-- require("telescope").setup({ defaults = { ... } })
-- require("nvim-cmp").setup({ sources = { ... } })

print("\n===== Lesson 01 完了 =====")
