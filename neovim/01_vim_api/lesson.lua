--[[
  Lesson 01: vim.api の基本

  この章で学ぶこと:
  - vim.api の概要と命名規則
  - バッファ操作（行の取得・設定・追加）
  - ウィンドウ・カーソル操作
  - vim.cmd（Vimscript コマンドの実行）
  - vim.inspect（テーブルの可視化）
  - vim.notify（メッセージ通知）

  実行方法: nvim -l lesson.lua
  （Neovim の Lua ランタイムが必要です）
]]

-- ========================================
-- vim.api の概要
-- ========================================

-- vim.api は Neovim の C API への Lua バインディング
-- 全ての関数は nvim_ プレフィックスで始まる
-- 命名規則:
--   nvim_buf_*    : バッファ操作
--   nvim_win_*    : ウィンドウ操作
--   nvim_tabpage_*: タブページ操作
--   nvim_*        : グローバル操作

print("=== vim.api の基本 ===\n")

-- ========================================
-- バッファ操作
-- ========================================

-- 現在のバッファ番号を取得
local buf = vim.api.nvim_get_current_buf()
print("現在のバッファ番号:", buf)

-- バッファに行を設定
-- nvim_buf_set_lines(buf, start, end, strict, lines)
-- start/end は 0-indexed、end は exclusive
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
  "Hello, Neovim!",
  "This is line 2",
  "This is line 3",
})

-- バッファの行数を取得
local line_count = vim.api.nvim_buf_line_count(buf)
print("行数:", line_count)  --> 3

-- バッファの行を取得
-- nvim_buf_get_lines(buf, start, end, strict)
local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
print("\nバッファの内容:")
for i, line in ipairs(lines) do
  print("  " .. i .. ": " .. line)
end

-- 特定の範囲だけ取得（0-indexed, end exclusive）
local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
print("\n1行目:", first_line[1])

-- 行を追加（末尾に挿入）
-- end に -1 を指定し、start も -1 にすると末尾に追加
vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "追加された行" })
print("追加後の行数:", vim.api.nvim_buf_line_count(buf))  --> 4

-- 行を置換（2行目を差し替え）
vim.api.nvim_buf_set_lines(buf, 1, 2, false, { "置換された2行目" })
local updated = vim.api.nvim_buf_get_lines(buf, 1, 2, false)
print("置換後の2行目:", updated[1])

-- 行を削除（3行目を削除）
vim.api.nvim_buf_set_lines(buf, 2, 3, false, {})
print("削除後の行数:", vim.api.nvim_buf_line_count(buf))

-- ========================================
-- バッファの情報取得
-- ========================================

-- バッファ名（ファイルパス）
local name = vim.api.nvim_buf_get_name(buf)
print("\nバッファ名:", name)

-- バッファのオプション取得
-- nvim_get_option_value(name, opts) を使う
local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
print("filetype:", ft)

-- バッファが変更されているか
local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
print("modified:", modified)

-- ========================================
-- ウィンドウ操作
-- ========================================

print("\n=== ウィンドウ操作 ===")

-- 現在のウィンドウ
local win = vim.api.nvim_get_current_win()
print("現在のウィンドウ:", win)

-- ウィンドウの幅と高さ
local width = vim.api.nvim_win_get_width(win)
local height = vim.api.nvim_win_get_height(win)
print("ウィンドウサイズ:", width .. "x" .. height)

-- カーソル位置の取得（{row, col} で 1-indexed row, 0-indexed col）
local cursor = vim.api.nvim_win_get_cursor(win)
print("カーソル位置: 行=" .. cursor[1] .. " 列=" .. cursor[2])

-- カーソル位置の設定
vim.api.nvim_win_set_cursor(win, { 1, 0 })  -- 1行目の先頭へ
print("移動後: 行=" .. vim.api.nvim_win_get_cursor(win)[1])

-- ========================================
-- vim.cmd: Vimscript コマンドの実行
-- ========================================

print("\n=== vim.cmd ===")

-- 文字列でコマンドを実行
vim.cmd("set number")
print("number:", vim.api.nvim_get_option_value("number", { win = win }))

-- 複数コマンドを実行
vim.cmd([[
  set tabstop=4
  set shiftwidth=4
]])

-- vim.cmd.xxx() 形式（Neovim 0.9+）
-- vim.cmd.echo('"Hello"')  -- :echo "Hello" と同等
-- vim.cmd.set("expandtab") -- :set expandtab と同等

-- ========================================
-- vim.inspect: テーブルの可視化
-- ========================================

print("\n=== vim.inspect ===")

-- テーブルを見やすい文字列に変換
local tbl = { a = 1, b = { 2, 3 }, c = "hello" }
print(vim.inspect(tbl))
--> { a = 1, b = { 2, 3 }, c = "hello" }

-- ネストしたテーブルも見やすく表示
local nested = {
  name = "plugin",
  config = {
    enabled = true,
    options = { "opt1", "opt2" },
  },
}
print(vim.inspect(nested))

-- デバッグ時に非常に便利
-- print() と組み合わせてよく使う
local lines_debug = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
print("バッファ内容:", vim.inspect(lines_debug))

-- ========================================
-- vim.notify: メッセージ通知
-- ========================================

print("\n=== vim.notify ===")

-- vim.notify(msg, level, opts)
-- level は vim.log.levels で定義
-- headless モードでは print と同様に出力される
vim.notify("通常のメッセージ", vim.log.levels.INFO)
vim.notify("警告メッセージ", vim.log.levels.WARN)
vim.notify("エラーメッセージ", vim.log.levels.ERROR)

-- GUIでは noice.nvim 等のプラグインでリッチな通知になる

-- ========================================
-- よく使うユーティリティ
-- ========================================

print("\n=== ユーティリティ ===")

-- vim.tbl_keys: テーブルのキー一覧
local keys = vim.tbl_keys({ a = 1, b = 2, c = 3 })
print("keys:", vim.inspect(keys))

-- vim.tbl_values: テーブルの値一覧
local values = vim.tbl_values({ a = 1, b = 2, c = 3 })
print("values:", vim.inspect(values))

-- vim.tbl_deep_extend: テーブルのディープマージ
-- "force" は後の値で上書き、"keep" は既存値を保持
local defaults = { a = 1, b = 2, nested = { x = 10 } }
local overrides = { b = 99, c = 3, nested = { y = 20 } }
local merged = vim.tbl_deep_extend("force", {}, defaults, overrides)
print("merged:", vim.inspect(merged))
--> { a = 1, b = 99, c = 3, nested = { x = 10, y = 20 } }

-- vim.startswith / vim.endswith
print("startswith:", vim.startswith("hello world", "hello"))  --> true
print("endswith:", vim.endswith("test.lua", ".lua"))           --> true

-- vim.split: 文字列を分割
local parts = vim.split("a,b,c", ",")
print("split:", vim.inspect(parts))  --> { "a", "b", "c" }

-- vim.trim: 前後の空白を除去
print("trim:", '"' .. vim.trim("  hello  ") .. '"')  --> "hello"

print("\n===== Lesson 01 完了 =====")
