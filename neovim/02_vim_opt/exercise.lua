--[[
  Exercise 02: vim.opt（オプション設定）

  TODO コメントの部分を埋めてください。
  完成したら `nvim -l exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: 基本的なオプション設定
-- ========================================

-- TODO: 以下のオプションを vim.opt で設定してください
-- tabstop = 4, shiftwidth = 4, expandtab = true

-- ここに実装

assert(vim.opt.tabstop:get() == 4, "tabstop が 4 ではありません")
assert(vim.opt.shiftwidth:get() == 4, "shiftwidth が 4 ではありません")
assert(vim.opt.expandtab:get() == true, "expandtab が true ではありません")
print("問題1: OK")

-- ========================================
-- 問題 2: vim.o を使ったオプション設定
-- ========================================

-- TODO: vim.o を使って以下を設定してください
-- number = true, relativenumber = true

-- ここに実装

assert(vim.o.number == true, "number が true ではありません")
assert(vim.o.relativenumber == true, "relativenumber が true ではありません")
print("問題2: OK")

-- ========================================
-- 問題 3: vim.bo でバッファオプション設定
-- ========================================

-- TODO: 現在のバッファの filetype を "markdown" に設定してください
-- ヒント: vim.bo[buf].filetype を使う

local buf = vim.api.nvim_get_current_buf()

-- ここに実装

assert(vim.bo[buf].filetype == "markdown", "filetype が 'markdown' ではありません")
print("問題3: OK")

-- ========================================
-- 問題 4: リスト型オプションの操作
-- ========================================

-- TODO: 以下の手順で wildignore オプションを操作してください
-- ステップ1: wildignore を { "*.o", "*.pyc" } に設定
-- ステップ2: "*.class" を append で追加
-- ステップ3: "*.o" を remove で削除

-- ステップ1
-- ここに実装

-- ステップ2
-- ここに実装

-- ステップ3
-- ここに実装

local wl = vim.opt.wildignore:get()
local has_pyc = false
local has_class = false
local has_o = false
for _, v in ipairs(wl) do
  if v == "*.pyc" then has_pyc = true end
  if v == "*.class" then has_class = true end
  if v == "*.o" then has_o = true end
end
assert(has_pyc, "*.pyc が含まれていません")
assert(has_class, "*.class が含まれていません")
assert(not has_o, "*.o がまだ含まれています")
print("問題4: OK")

-- ========================================
-- 問題 5: vim.g でグローバル変数を設定
-- ========================================

-- TODO: 以下のグローバル変数を設定してください
-- mapleader = " "（スペース）
-- my_plugin_enabled = true

-- ここに実装

assert(vim.g.mapleader == " ", "mapleader がスペースではありません")
assert(vim.g.my_plugin_enabled == true, "my_plugin_enabled が true ではありません")
print("問題5: OK")

-- ========================================
-- 問題 6: vim.opt:get() で値を取得
-- ========================================

-- TODO: 以下のオプションを設定し、:get() で取得して変数に格納してください

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- scrolloff の値を取得して scrolloff_val に格納
local scrolloff_val = nil  -- ここを修正

-- signcolumn の値を取得して sign_val に格納
local sign_val = nil  -- ここを修正

assert(scrolloff_val == 8, "scrolloff が 8 ではありません")
assert(sign_val == "yes", "signcolumn が 'yes' ではありません")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: init.lua 風の設定関数
-- ========================================

-- TODO: オプション設定をまとめて行う関数 setup_options を作成してください
-- 仕様:
-- 1. テーブルを受け取る: { opt = {}, g = {} }
-- 2. opt の中身を vim.opt に設定
-- 3. g の中身を vim.g に設定
-- ヒント: pairs でテーブルをイテレートする

local function setup_options(config)
  -- ここを実装
end

-- テスト用にオプションをリセット
vim.opt.cursorline = false
vim.opt.swapfile = true
vim.g.test_var = nil

setup_options({
  opt = {
    cursorline = true,
    swapfile = false,
    wrap = false,
  },
  g = {
    test_var = "hello",
    another_var = 42,
  },
})

assert(vim.opt.cursorline:get() == true, "cursorline が設定されていません")
assert(vim.opt.swapfile:get() == false, "swapfile が設定されていません")
assert(vim.opt.wrap:get() == false, "wrap が設定されていません")
assert(vim.g.test_var == "hello", "test_var が設定されていません")
assert(vim.g.another_var == 42, "another_var が設定されていません")
print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
