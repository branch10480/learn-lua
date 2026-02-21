--[[
  Lesson 03: vim.keymap（キーマッピング）

  この章で学ぶこと:
  - vim.keymap.set() の基本
  - モード指定（n, i, v, x, s, o, t, c）
  - オプション（silent, noremap, desc, buffer, expr）
  - Lua 関数をコールバックとして使う
  - vim.keymap.del() でマッピングを削除

  実行方法: nvim -l lesson.lua
]]

-- ========================================
-- vim.keymap.set() の基本
-- ========================================

print("=== vim.keymap.set() の基本 ===\n")

-- 構文: vim.keymap.set(mode, lhs, rhs, opts)
-- mode: モード文字列またはテーブル
-- lhs:  入力キー（左辺）
-- rhs:  実行される動作（右辺）
-- opts: オプションテーブル（省略可）

-- 基本的なノーマルモードのマッピング
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "ファイル保存" })

-- ★ Vimscript の nnoremap と同等
-- デフォルトで noremap = true（再帰マッピングしない）

-- ========================================
-- モード指定
-- ========================================

print("=== モード指定 ===")

-- 各モードの文字列:
-- "n" : ノーマルモード
-- "i" : インサートモード
-- "v" : ビジュアルモード + セレクトモード
-- "x" : ビジュアルモード（セレクトモードを含まない）
-- "s" : セレクトモード
-- "o" : オペレータ待機モード
-- "t" : ターミナルモード
-- "c" : コマンドラインモード
-- ""  : ノーマル + ビジュアル + オペレータ待機

-- ノーマルモード
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "終了" })

-- インサートモード（jk で Esc）
vim.keymap.set("i", "jk", "<Esc>", { desc = "ノーマルモードに戻る" })

-- ビジュアルモード（選択範囲をインデント後、選択を維持）
vim.keymap.set("v", "<", "<gv", { desc = "インデント減（選択維持）" })
vim.keymap.set("v", ">", ">gv", { desc = "インデント増（選択維持）" })

-- 複数モードを同時指定（テーブルで渡す）
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "クリップボードにヤンク" })

print("各モードのマッピングを設定しました")

-- ========================================
-- Lua 関数をコールバックに使う
-- ========================================

print("\n=== Lua 関数コールバック ===")

-- rhs に文字列の代わりに Lua 関数を渡せる
-- これが Neovim Lua 設定の最大の利点

vim.keymap.set("n", "<leader>h", function()
  print("Hello from Lua!")
end, { desc = "Lua でメッセージ表示" })

-- 引数を使った例
vim.keymap.set("n", "<leader>t", function()
  local time = os.date("%H:%M:%S")
  vim.notify("現在時刻: " .. time, vim.log.levels.INFO)
end, { desc = "現在時刻を通知" })

-- バッファの情報を使う例
vim.keymap.set("n", "<leader>i", function()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local ft = vim.bo.filetype
  local lines = vim.api.nvim_buf_line_count(buf)
  vim.notify(string.format("File: %s\nType: %s\nLines: %d", name, ft, lines))
end, { desc = "バッファ情報を表示" })

print("Lua コールバックのマッピングを設定しました")

-- ========================================
-- オプション
-- ========================================

print("\n=== オプション ===")

-- 主なオプション:
-- desc    : マッピングの説明（:map で表示される）
-- silent  : コマンドラインにコマンドを表示しない（デフォルト: false）
-- noremap : 再帰マッピングしない（デフォルト: true）
-- buffer  : バッファローカルなマッピング
-- expr    : rhs の戻り値をキー入力として使う
-- remap   : noremap の逆（true で再帰マッピング有効）

-- silent: コマンドラインに表示しない
vim.keymap.set("n", "<leader>s", ":nohlsearch<CR>", {
  silent = true,
  desc = "検索ハイライト消去",
})

-- buffer: 現在のバッファだけに有効
vim.keymap.set("n", "<leader>b", function()
  print("バッファローカルなマッピング")
end, {
  buffer = true,  -- buffer = 0 も同義（現在のバッファ）
  desc = "バッファローカル",
})

-- 特定のバッファに設定
-- vim.keymap.set("n", "<leader>x", ..., { buffer = buf_number })

-- expr: 戻り値をキー入力として解釈
-- 例: 折り返し表示時に gj/gk を使うが、count が指定されたら j/k を使う
vim.keymap.set("n", "j", function()
  if vim.v.count > 0 then
    return "j"
  else
    return "gj"
  end
end, { expr = true, desc = "スマートな下移動" })

print("オプション付きのマッピングを設定しました")

-- ========================================
-- vim.keymap.del() でマッピングを削除
-- ========================================

print("\n=== vim.keymap.del() ===")

-- マッピングの削除
-- vim.keymap.del(mode, lhs, opts)

-- まず設定してから削除
vim.keymap.set("n", "<leader>z", ":echo 'test'<CR>", { desc = "テスト" })
vim.keymap.del("n", "<leader>z")
print("マッピングを削除しました")

-- バッファローカルなマッピングの削除
-- vim.keymap.del("n", "<leader>x", { buffer = buf_number })

-- ========================================
-- 実践的なキーマッピング例
-- ========================================

print("\n=== 実践的な設定例 ===")

-- リーダーキーの設定（vim.keymap より先に設定する）
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ウィンドウ移動
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })

-- バッファ移動
vim.keymap.set("n", "[b", ":bprevious<CR>", { silent = true, desc = "前のバッファ" })
vim.keymap.set("n", "]b", ":bnext<CR>", { silent = true, desc = "次のバッファ" })

-- 行の移動（ビジュアルモード）
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "行を下に移動" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "行を上に移動" })

-- ペースト時にレジスタを上書きしない
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "レジスタ保持ペースト" })

-- 全選択
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "全選択" })

print("実践的なマッピングを設定しました")

-- ========================================
-- マッピングの確認方法
-- ========================================

print("\n=== マッピングの確認 ===")

-- vim.api.nvim_get_keymap(mode) で全マッピングを取得
local maps = vim.api.nvim_get_keymap("n")
print("ノーマルモードのマッピング数:", #maps)

-- バッファローカルなマッピング
local buf_maps = vim.api.nvim_buf_get_keymap(0, "n")
print("バッファローカルマッピング数:", #buf_maps)

-- 特定のマッピングの情報を確認
-- :verbose nmap <leader>w  -- Vimscript で確認する方法

print("\n===== Lesson 03 完了 =====")
