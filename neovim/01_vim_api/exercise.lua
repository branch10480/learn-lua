--[[
  Exercise 01: vim.api の基本

  TODO コメントの部分を埋めてください。
  完成したら `nvim -l exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: バッファに行を設定
-- ========================================

-- TODO: 現在のバッファに以下の3行を設定してください
-- "line1", "line2", "line3"
-- ヒント: vim.api.nvim_buf_set_lines を使う

local buf = vim.api.nvim_get_current_buf()

-- ここに実装

local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
assert(#lines == 3, "行数が3ではありません: " .. #lines)
assert(lines[1] == "line1", "1行目が 'line1' ではありません")
assert(lines[2] == "line2", "2行目が 'line2' ではありません")
assert(lines[3] == "line3", "3行目が 'line3' ではありません")
print("問題1: OK")

-- ========================================
-- 問題 2: 行の追加
-- ========================================

-- TODO: バッファの末尾に "line4" と "line5" を追加してください
-- ヒント: nvim_buf_set_lines の start/end に -1 を指定

-- ここに実装

local lines2 = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
assert(#lines2 == 5, "行数が5ではありません: " .. #lines2)
assert(lines2[4] == "line4", "4行目が 'line4' ではありません")
assert(lines2[5] == "line5", "5行目が 'line5' ではありません")
print("問題2: OK")

-- ========================================
-- 問題 3: 行の置換
-- ========================================

-- TODO: 2行目（"line2"）を "replaced" に置換してください
-- ヒント: 0-indexed で start=1, end=2

-- ここに実装

local line2 = vim.api.nvim_buf_get_lines(buf, 1, 2, false)
assert(line2[1] == "replaced", "2行目が 'replaced' ではありません: " .. tostring(line2[1]))
assert(vim.api.nvim_buf_line_count(buf) == 5, "行数が変わってしまいました")
print("問題3: OK")

-- ========================================
-- 問題 4: 行の削除
-- ========================================

-- TODO: 3行目（現在 "line3"）を削除してください
-- ヒント: 空テーブル {} で置換すると削除になる

-- ここに実装

assert(vim.api.nvim_buf_line_count(buf) == 4, "行数が4ではありません")
local after_delete = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
assert(after_delete[1] == "line1", "1行目が変わってしまいました")
assert(after_delete[2] == "replaced", "2行目が変わってしまいました")
assert(after_delete[3] == "line4", "3行目が 'line4' ではありません")
assert(after_delete[4] == "line5", "4行目が 'line5' ではありません")
print("問題4: OK")

-- ========================================
-- 問題 5: vim.inspect でテーブルを文字列化
-- ========================================

-- TODO: 以下のテーブルを vim.inspect で文字列に変換してください
local data = { name = "neovim", version = 9 }

local result = nil  -- ここを修正

assert(type(result) == "string", "result が文字列ではありません")
assert(result:find("neovim"), "result に 'neovim' が含まれていません")
assert(result:find("9"), "result に '9' が含まれていません")
print("問題5: OK")

-- ========================================
-- 問題 6: vim.tbl_deep_extend でマージ
-- ========================================

-- TODO: defaults と user_config を vim.tbl_deep_extend でマージしてください
-- user_config の値が優先されるようにする（"force" モード）
-- 注意: 第2引数に空テーブル {} を渡して元テーブルを変更しないようにする

local defaults = {
  indent = 2,
  theme = "dark",
  plugins = { lsp = true, treesitter = false },
}
local user_config = {
  indent = 4,
  plugins = { treesitter = true },
}

local merged = nil  -- ここを修正

assert(merged.indent == 4, "indent が 4 ではありません")
assert(merged.theme == "dark", "theme がデフォルト値ではありません")
assert(merged.plugins.lsp == true, "plugins.lsp が true ではありません")
assert(merged.plugins.treesitter == true, "plugins.treesitter が true ではありません")
-- 元テーブルが変更されていないことを確認
assert(defaults.indent == 2, "defaults が変更されてしまいました")
print("問題6: OK")

-- ========================================
-- 問題 7: vim.split と vim.trim
-- ========================================

-- TODO: 以下の文字列をカンマで分割し、各要素の前後の空白を除去してください
local input = "  apple , banana ,  cherry  "

-- ステップ1: vim.split でカンマ区切りに分割
local parts = nil  -- ここを修正

-- ステップ2: 各要素に vim.trim を適用
local trimmed = {}
-- ここに実装（for ループで parts を回して vim.trim を適用）

assert(#trimmed == 3, "要素数が3ではありません")
assert(trimmed[1] == "apple", "1番目が 'apple' ではありません: " .. tostring(trimmed[1]))
assert(trimmed[2] == "banana", "2番目が 'banana' ではありません: " .. tostring(trimmed[2]))
assert(trimmed[3] == "cherry", "3番目が 'cherry' ではありません: " .. tostring(trimmed[3]))
print("問題7: OK")

-- ========================================
-- チャレンジ問題: バッファ操作の総合
-- ========================================

-- TODO: 以下の操作を順番に行ってください
-- 1. バッファの内容を全てクリアする
-- 2. 以下の行を設定: "# Title", "", "paragraph 1", "paragraph 2", "", "## Subtitle"
-- 3. 空行（""）の行番号（1-indexed）をテーブルに集める
-- 4. "## Subtitle" を "## New Subtitle" に置換する

-- ここから実装

-- ステップ 1: バッファクリア

-- ステップ 2: 行を設定

-- ステップ 3: 空行の行番号を集める
local empty_lines = {}

-- ステップ 4: "## Subtitle" を置換

-- ここまで

local final = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
assert(#final == 6, "行数が6ではありません: " .. #final)
assert(final[1] == "# Title", "1行目が正しくありません")
assert(#empty_lines == 2, "空行の数が2ではありません")
assert(empty_lines[1] == 2, "最初の空行は2行目のはず")
assert(empty_lines[2] == 5, "2番目の空行は5行目のはず")
assert(final[6] == "## New Subtitle", "6行目が '## New Subtitle' ではありません")
print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
