--[[
  Exercise 04: vim.fn（Vimscript 関数呼び出し）

  TODO コメントの部分を埋めてください。
  完成したら `nvim -l exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: ファイルパスの操作
-- ========================================

-- TODO: vim.fn.fnamemodify を使って以下の値を取得してください
local filepath = "/home/user/project/config/init.lua"

-- ファイル名だけ取得（"init.lua"）
local filename = nil  -- ここを修正

-- ディレクトリ部分を取得（"/home/user/project/config"）
local dirname = nil  -- ここを修正

-- 拡張子を取得（"lua"）
local ext = nil  -- ここを修正

assert(filename == "init.lua", "filename が 'init.lua' ではありません: " .. tostring(filename))
assert(dirname == "/home/user/project/config", "dirname が正しくありません: " .. tostring(dirname))
assert(ext == "lua", "ext が 'lua' ではありません: " .. tostring(ext))
print("問題1: OK")

-- ========================================
-- 問題 2: 文字列操作
-- ========================================

-- TODO: vim.fn.substitute を使って文字列を置換してください
local original = "Hello World Hello"

-- "Hello" を全て "Hi" に置換（flags に "g" を指定）
local replaced = nil  -- ここを修正

assert(replaced == "Hi World Hi", "置換結果が正しくありません: " .. tostring(replaced))
print("問題2: OK")

-- ========================================
-- 問題 3: 大文字小文字変換
-- ========================================

-- TODO: 以下の文字列を加工してください

local input = "hello WORLD"

-- 全て大文字にする
local upper = nil  -- ここを修正

-- 全て小文字にする
local lower = nil  -- ここを修正

assert(upper == "HELLO WORLD", "大文字変換が正しくありません")
assert(lower == "hello world", "小文字変換が正しくありません")
print("問題3: OK")

-- ========================================
-- 問題 4: split と join
-- ========================================

-- TODO: パス文字列を分解して再構築してください
local path_str = "src/components/Button.tsx"

-- "/" で分割してリストにする
local parts = nil  -- ここを修正

-- リストを " > " で結合する
local breadcrumb = nil  -- ここを修正

assert(#parts == 3, "parts の要素数が3ではありません")
assert(parts[1] == "src", "parts[1] が 'src' ではありません")
assert(parts[2] == "components", "parts[2] が正しくありません")
assert(parts[3] == "Button.tsx", "parts[3] が正しくありません")
assert(breadcrumb == "src > components > Button.tsx", "breadcrumb が正しくありません: " .. tostring(breadcrumb))
print("問題4: OK")

-- ========================================
-- 問題 5: system でコマンド実行
-- ========================================

-- TODO: vim.fn.system を使って "echo neovim" を実行し、
-- 結果から前後の空白を除去して変数に格納してください
-- ヒント: vim.trim() で前後の空白（改行含む）を除去

local cmd_result = nil  -- ここを修正

assert(cmd_result == "neovim", "コマンド結果が 'neovim' ではありません: " .. tostring(cmd_result))
print("問題5: OK")

-- ========================================
-- 問題 6: executable でコマンドの存在確認
-- ========================================

-- TODO: vim.fn.executable を使って以下を確認してください
-- "nvim" コマンドが使えるかどうかを boolean で返す
-- ヒント: executable は 1 or 0 を返す → == 1 で boolean に変換

local has_nvim = nil  -- ここを修正

assert(type(has_nvim) == "boolean", "has_nvim が boolean ではありません")
assert(has_nvim == true, "nvim が実行可能ではありません")
print("問題6: OK")

-- ========================================
-- 問題 7: stdpath で標準パスを取得
-- ========================================

-- TODO: Neovim の設定ディレクトリパスを取得してください
-- ヒント: vim.fn.stdpath("config")

local config_dir = nil  -- ここを修正

assert(type(config_dir) == "string", "config_dir が文字列ではありません")
assert(#config_dir > 0, "config_dir が空です")
print("問題7: OK (config_dir = " .. config_dir .. ")")

-- ========================================
-- チャレンジ問題: ファイル情報取得関数
-- ========================================

-- TODO: ファイルパスから詳細情報を返す関数を作成してください
-- 仕様:
-- 1. file_info(path) 関数を作成
-- 2. 以下のキーを持つテーブルを返す:
--    - name: ファイル名（例: "init.lua"）
--    - dir: ディレクトリ（例: "/home/user"）
--    - ext: 拡張子（例: "lua"）
--    - stem: 拡張子を除いたファイル名（例: "init"）
--    ヒント: stem は fnamemodify(path, ":t:r") で取得可能

local function file_info(path)
  -- ここを実装
end

local info = file_info("/home/user/projects/app/main.py")
assert(info.name == "main.py", "name が正しくありません: " .. tostring(info.name))
assert(info.dir == "/home/user/projects/app", "dir が正しくありません: " .. tostring(info.dir))
assert(info.ext == "py", "ext が正しくありません: " .. tostring(info.ext))
assert(info.stem == "main", "stem が正しくありません: " .. tostring(info.stem))

local info2 = file_info("/etc/nginx/nginx.conf")
assert(info2.name == "nginx.conf", "name が正しくありません")
assert(info2.ext == "conf", "ext が正しくありません")
assert(info2.stem == "nginx", "stem が正しくありません")
print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
