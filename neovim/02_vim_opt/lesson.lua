--[[
  Lesson 02: vim.opt（オプション設定）

  この章で学ぶこと:
  - vim.o / vim.opt / vim.bo / vim.wo の違い
  - オプションの設定と取得
  - vim.opt のメソッド（append, prepend, remove, get）
  - vim.g / vim.b / vim.w（変数スコープ）

  実行方法: nvim -l lesson.lua
]]

-- ========================================
-- オプション設定の4つの方法
-- ========================================

print("=== オプション設定の方法 ===\n")

-- 1. vim.o: Vimscript の :set と同等（文字列ベース）
vim.o.number = true
vim.o.tabstop = 4
print("vim.o.number:", vim.o.number)      --> true
print("vim.o.tabstop:", vim.o.tabstop)    --> 4

-- 2. vim.opt: よりリッチなインターフェース（メソッド付き）
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- vim.opt は Option オブジェクトを返す → :get() で値を取得
print("vim.opt.shiftwidth:", vim.opt.shiftwidth:get())  --> 4

-- 3. vim.bo: バッファローカルオプション（buffer option）
local buf = vim.api.nvim_get_current_buf()
vim.bo[buf].filetype = "lua"
-- vim.bo.filetype でも現在のバッファに対して設定可能
print("vim.bo.filetype:", vim.bo[buf].filetype)

-- 4. vim.wo: ウィンドウローカルオプション（window option）
local win = vim.api.nvim_get_current_win()
vim.wo[win].number = true
vim.wo[win].relativenumber = true
print("vim.wo.number:", vim.wo[win].number)

-- ★ 使い分けの目安:
-- vim.opt  : 一般的な設定に最適（メソッドが便利）
-- vim.o    : シンプルに値を設定/取得したい場合
-- vim.bo   : バッファ固有の設定（filetype 等）
-- vim.wo   : ウィンドウ固有の設定（number, wrap 等）

-- ========================================
-- vim.opt の基本的な使い方
-- ========================================

print("\n=== vim.opt の基本 ===")

-- 数値オプション
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- 真偽値オプション
vim.opt.expandtab = true    -- タブをスペースに変換
vim.opt.number = true       -- 行番号を表示
vim.opt.relativenumber = true -- 相対行番号
vim.opt.wrap = false        -- 行の折り返しなし
vim.opt.ignorecase = true   -- 検索時に大文字小文字を無視
vim.opt.smartcase = true    -- 大文字が含まれれば区別する

-- 文字列オプション
vim.opt.signcolumn = "yes"  -- サイン列を常に表示
vim.opt.encoding = "utf-8"

print("tabstop:", vim.opt.tabstop:get())
print("expandtab:", vim.opt.expandtab:get())

-- ========================================
-- vim.opt のリスト型オプション
-- ========================================

print("\n=== リスト型オプション ===")

-- リスト型のオプション（カンマ区切り）
-- wildignore, backupdir, path 等

-- 設定
vim.opt.wildignore = { "*.o", "*.pyc", "__pycache__" }
print("wildignore:", vim.inspect(vim.opt.wildignore:get()))

-- append: 末尾に追加
vim.opt.wildignore:append("*.class")
print("append後:", vim.inspect(vim.opt.wildignore:get()))

-- prepend: 先頭に追加
vim.opt.wildignore:prepend("*.swp")
print("prepend後:", vim.inspect(vim.opt.wildignore:get()))

-- remove: 特定の値を削除
vim.opt.wildignore:remove("*.pyc")
print("remove後:", vim.inspect(vim.opt.wildignore:get()))

-- ========================================
-- vim.opt のマップ型オプション
-- ========================================

print("\n=== マップ型オプション ===")

-- listchars のようなマップ型オプション
vim.opt.listchars = {
  tab = ">>",
  trail = ".",
  nbsp = "+",
}
print("listchars:", vim.inspect(vim.opt.listchars:get()))

-- ========================================
-- vim.g / vim.b / vim.w / vim.t（変数スコープ）
-- ========================================

print("\n=== 変数スコープ ===")

-- vim.g: グローバル変数（g: に相当）
-- プラグインの設定でよく使う
vim.g.mapleader = " "         -- リーダーキーをスペースに
vim.g.maplocalleader = "\\"   -- ローカルリーダー

print("mapleader:", vim.inspect(vim.g.mapleader))

-- vim.g でプラグイン設定の例
vim.g.loaded_netrw = 1        -- netrw を無効化
vim.g.loaded_netrwPlugin = 1

-- vim.b: バッファローカル変数（b: に相当）
vim.b.my_buffer_var = "hello"
print("buffer var:", vim.b.my_buffer_var)

-- vim.w: ウィンドウローカル変数（w: に相当）
vim.w.my_window_var = 42
print("window var:", vim.w.my_window_var)

-- 変数の削除は nil を代入
vim.g.loaded_netrw = nil

-- ★ 重要: vim.g と vim.opt の違い
-- vim.g はユーザー定義変数（g:xxx）
-- vim.opt は Vim のオプション（:set xxx）
-- 例: vim.g.mapleader はユーザー変数
--     vim.opt.number は Vim のオプション

-- ========================================
-- 実践: よく使う設定の例
-- ========================================

print("\n=== 実践的な設定例 ===")

-- インデント設定
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- 検索設定
vim.opt.hlsearch = true       -- 検索結果をハイライト
vim.opt.incsearch = true      -- インクリメンタルサーチ
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UI設定
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true     -- カーソル行をハイライト
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true  -- True Color サポート
vim.opt.scrolloff = 8         -- スクロール時の余白行数
vim.opt.sidescrolloff = 8

-- ファイル設定
vim.opt.swapfile = false      -- スワップファイルを作らない
vim.opt.backup = false
vim.opt.undofile = true       -- undo 履歴をファイルに保存

-- 分割設定
vim.opt.splitbelow = true     -- 水平分割は下に開く
vim.opt.splitright = true     -- 垂直分割は右に開く

-- クリップボード
vim.opt.clipboard = "unnamedplus"  -- システムクリップボードを使用

print("設定完了")
print("number:", vim.opt.number:get())
print("tabstop:", vim.opt.tabstop:get())
print("clipboard:", vim.inspect(vim.opt.clipboard:get()))

print("\n===== Lesson 02 完了 =====")
