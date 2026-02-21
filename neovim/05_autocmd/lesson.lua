--[[
  Lesson 05: autocmd と augroup

  この章で学ぶこと:
  - vim.api.nvim_create_autocmd() の基本
  - イベントの種類（BufEnter, BufWritePre, FileType 等）
  - vim.api.nvim_create_augroup() でグループ化
  - コールバック関数とパターン
  - 実践的な autocmd の例

  実行方法: nvim -l lesson.lua
]]

-- ========================================
-- autocmd の概要
-- ========================================

print("=== autocmd の基本 ===\n")

-- autocmd は「特定のイベントが発生したときに自動実行するコマンド」
-- Vimscript: autocmd BufWritePre *.lua echo "Saving Lua file"
-- Lua: vim.api.nvim_create_autocmd("BufWritePre", { ... })

-- ========================================
-- vim.api.nvim_create_autocmd()
-- ========================================

-- 構文:
-- vim.api.nvim_create_autocmd(event, opts)
-- event: イベント名（文字列またはテーブル）
-- opts:  オプションテーブル

-- 基本的な使い方
local id = vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",           -- 全てのファイルで発火
  callback = function(args)
    -- args にはイベント情報が入る
    -- args.buf  : バッファ番号
    -- args.file : ファイル名
    -- args.event: イベント名
    -- args.match: マッチしたパターン
  end,
  desc = "バッファに入った時の処理",
})

print("作成された autocmd ID:", id)

-- ★ 戻り値は autocmd の ID（後で削除するときに使える）

-- ========================================
-- 主なイベント
-- ========================================

print("\n=== 主なイベント ===")

-- ファイル読み書き系:
-- BufReadPost    : ファイル読み込み後
-- BufWritePre    : ファイル保存前
-- BufWritePost   : ファイル保存後
-- BufNewFile     : 新規ファイル作成時

-- バッファ系:
-- BufEnter       : バッファに入った時
-- BufLeave       : バッファを離れた時
-- BufDelete      : バッファ削除時

-- ウィンドウ系:
-- WinEnter       : ウィンドウに入った時
-- WinLeave       : ウィンドウを離れた時
-- WinResized     : ウィンドウリサイズ時

-- 編集系:
-- TextChanged    : テキスト変更時（ノーマルモード）
-- TextChangedI   : テキスト変更時（インサートモード）
-- InsertEnter    : インサートモードに入った時
-- InsertLeave    : インサートモードを離れた時

-- ファイルタイプ系:
-- FileType       : filetype が設定された時

-- Vim ライフサイクル:
-- VimEnter       : Neovim 起動完了時
-- VimLeavePre    : Neovim 終了前

-- その他:
-- CursorHold     : カーソルが一定時間動かなかった時
-- ColorScheme    : カラースキーム変更時

print("イベント一覧は :h autocmd-events で確認できます")

-- ========================================
-- パターンとフィルタリング
-- ========================================

print("\n=== パターンとフィルタリング ===")

-- pattern: ファイル名のパターン（glob形式）
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",  -- .lua ファイルのみ
  callback = function(args)
    print("Lua ファイルを保存:", args.file)
  end,
  desc = "Lua ファイル保存時",
})

-- 複数パターン
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function(args)
    print("JS/TS ファイルを読み込み:", args.file)
  end,
  desc = "JS/TS ファイル読み込み時",
})

-- FileType イベントでは pattern にファイルタイプを指定
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(args)
    -- Lua ファイル固有の設定
    vim.bo[args.buf].tabstop = 2
    vim.bo[args.buf].shiftwidth = 2
  end,
  desc = "Lua ファイルのインデント設定",
})

-- buffer オプション: 特定のバッファでのみ発火
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,  -- 現在のバッファのみ
  callback = function()
    print("このバッファが保存されました")
  end,
  desc = "現在のバッファの保存時",
})

print("パターン付き autocmd を設定しました")

-- ========================================
-- vim.api.nvim_create_augroup()
-- ========================================

print("\n=== augroup ===")

-- augroup はオートコマンドをグループ化する仕組み
-- 主な目的: 設定のリロード時に autocmd が重複するのを防ぐ

-- augroup の作成
-- clear = true にすると、同名のグループ内の既存 autocmd を削除してから作成
local my_group = vim.api.nvim_create_augroup("MyGroup", {
  clear = true,  -- ★ 重要: ほぼ常に true にする
})

print("augroup ID:", my_group)

-- augroup に autocmd を追加
vim.api.nvim_create_autocmd("BufWritePre", {
  group = my_group,  -- グループを指定
  pattern = "*.lua",
  callback = function(args)
    print("MyGroup: Lua ファイル保存前処理")
  end,
  desc = "Lua 保存前処理",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = my_group,
  pattern = "*.lua",
  callback = function(args)
    print("MyGroup: Lua ファイル保存後処理")
  end,
  desc = "Lua 保存後処理",
})

-- ★ なぜ augroup が重要か:
-- init.lua が再読み込みされるたびに autocmd が追加される問題を防ぐ
-- clear = true により、前回の autocmd が削除されてから新しいのが作成される

-- グループ名を文字列で指定することも可能
vim.api.nvim_create_autocmd("FileType", {
  group = "MyGroup",  -- 文字列でも OK
  pattern = "python",
  callback = function(args)
    vim.bo[args.buf].tabstop = 4
  end,
  desc = "Python インデント設定",
})

print("augroup 付き autocmd を設定しました")

-- ========================================
-- autocmd の削除
-- ========================================

print("\n=== autocmd の削除 ===")

-- 特定の autocmd を削除（ID を使う）
local temp_id = vim.api.nvim_create_autocmd("CursorHold", {
  callback = function() end,
  desc = "一時的な autocmd",
})
vim.api.nvim_del_autocmd(temp_id)
print("autocmd (ID:" .. temp_id .. ") を削除しました")

-- グループごと削除
local temp_group = vim.api.nvim_create_augroup("TempGroup", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = temp_group,
  callback = function() end,
})
-- グループを clear すると中の autocmd も削除される
vim.api.nvim_create_augroup("TempGroup", { clear = true })
print("TempGroup をクリアしました")

-- ========================================
-- コールバック関数の引数（args）
-- ========================================

print("\n=== コールバック引数 ===")

-- callback に渡される args テーブルの内容:
-- args.id     : autocmd の ID
-- args.event  : 発生したイベント名
-- args.group  : augroup の ID（あれば）
-- args.match  : マッチしたパターン
-- args.buf    : バッファ番号
-- args.file   : ファイル名
-- args.data   : イベント固有のデータ

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("ArgsDemo", { clear = true }),
  pattern = "*",
  callback = function(args)
    -- print(vim.inspect(args)) -- デバッグ時に便利
  end,
  desc = "引数のデモ",
})

print("args の内容は :h nvim_create_autocmd で確認できます")

-- ========================================
-- 実践的な autocmd の例
-- ========================================

print("\n=== 実践的な例 ===")

local practical = vim.api.nvim_create_augroup("PracticalExamples", { clear = true })

-- 1. ファイルタイプごとの設定
vim.api.nvim_create_autocmd("FileType", {
  group = practical,
  pattern = { "lua", "vim" },
  callback = function(args)
    vim.bo[args.buf].tabstop = 2
    vim.bo[args.buf].shiftwidth = 2
    vim.bo[args.buf].expandtab = true
  end,
  desc = "Lua/Vim のインデント設定",
})

-- 2. 保存時に末尾の空白を削除
vim.api.nvim_create_autocmd("BufWritePre", {
  group = practical,
  pattern = "*",
  callback = function()
    -- カーソル位置を保存
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- 末尾の空白を削除
    vim.cmd([[%s/\s\+$//e]])
    -- カーソル位置を復元
    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
  end,
  desc = "末尾の空白を削除",
})

-- 3. ヤンクした範囲をハイライト
vim.api.nvim_create_autocmd("TextYankPost", {
  group = practical,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
  desc = "ヤンク範囲をハイライト",
})

-- 4. ターミナルを開いたらインサートモードに入る
vim.api.nvim_create_autocmd("TermOpen", {
  group = practical,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
  desc = "ターミナル設定",
})

-- 5. 前回の編集位置に戻る
vim.api.nvim_create_autocmd("BufReadPost", {
  group = practical,
  pattern = "*",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "前回の編集位置に戻る",
})

print("実践的な autocmd を設定しました")

-- ========================================
-- once オプション
-- ========================================

print("\n=== once オプション ===")

-- once = true で一度だけ実行して自動削除
vim.api.nvim_create_autocmd("BufEnter", {
  once = true,
  callback = function()
    print("一度だけ実行されます")
  end,
  desc = "一回限りの autocmd",
})

print("once 付き autocmd を設定しました")

print("\n===== Lesson 05 完了 =====")
