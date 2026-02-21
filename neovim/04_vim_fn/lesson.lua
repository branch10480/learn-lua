--[[
  Lesson 04: vim.fn（Vimscript 関数呼び出し）

  この章で学ぶこと:
  - vim.fn の基本的な使い方
  - ファイルパス関連の関数
  - 文字列関連の関数
  - リスト・辞書操作
  - システム関連の関数
  - vim.fn vs vim.api の使い分け

  実行方法: nvim -l lesson.lua
]]

-- ========================================
-- vim.fn の概要
-- ========================================

print("=== vim.fn の基本 ===\n")

-- vim.fn は Vimscript の組み込み関数を Lua から呼び出すインターフェース
-- vim.fn.xxx() で Vimscript の xxx() 関数を呼べる

-- ★ 命名規則の注意:
-- Vimscript 関数名にハイフンがある場合は [""] 記法を使う
-- 例: vim.fn["has"]("nvim") は OK
--     vim.fn.has("nvim") も OK（ハイフンなしの場合）

-- Neovim かどうかチェック
print("has('nvim'):", vim.fn.has("nvim"))  --> 1

-- Vim のバージョン情報
print("v:version:", vim.fn.has("nvim-0.9"))  --> 1 (0.9以上なら)

-- ========================================
-- ファイルパス関連
-- ========================================

print("\n=== ファイルパス関連 ===")

-- expand: 特殊な文字列を展開
-- %  : 現在のファイル名
-- %:p : フルパス
-- %:t : ファイル名部分のみ
-- %:h : ディレクトリ部分
-- %:r : 拡張子を除いた部分
-- %:e : 拡張子
print("現在のファイル:", vim.fn.expand("%"))
print("フルパス:", vim.fn.expand("%:p"))

-- fnamemodify: パスを加工
local path = "/home/user/project/src/main.lua"
print("\nfnamemodify:")
print("  ファイル名:", vim.fn.fnamemodify(path, ":t"))    --> main.lua
print("  ディレクトリ:", vim.fn.fnamemodify(path, ":h"))  --> /home/user/project/src
print("  拡張子なし:", vim.fn.fnamemodify(path, ":r"))     --> /home/user/project/src/main
print("  拡張子:", vim.fn.fnamemodify(path, ":e"))          --> lua

-- getcwd: カレントディレクトリ
print("\ncwd:", vim.fn.getcwd())

-- filereadable: ファイルが読めるか（1 or 0）
print("filereadable('lesson.lua'):", vim.fn.filereadable("lesson.lua"))

-- isdirectory: ディレクトリか
print("isdirectory('.'):", vim.fn.isdirectory("."))

-- glob: パターンにマッチするファイル一覧（文字列、改行区切り）
-- globpath: 複数ディレクトリで glob
local lua_files = vim.fn.glob("*.lua")
print("\nglob('*.lua'):")
print(lua_files)

-- glob をリストで取得
local file_list = vim.fn.glob("*.lua", false, true)
print("\nglob (リスト):", vim.inspect(file_list))

-- stdpath: Neovim の標準ディレクトリ
print("\nstdpath:")
print("  config:", vim.fn.stdpath("config"))  --> ~/.config/nvim
print("  data:", vim.fn.stdpath("data"))      --> ~/.local/share/nvim
print("  cache:", vim.fn.stdpath("cache"))    --> ~/.cache/nvim

-- ========================================
-- 文字列関連
-- ========================================

print("\n=== 文字列関連 ===")

-- strlen: 文字列長
print("strlen:", vim.fn.strlen("hello"))  --> 5

-- toupper / tolower: 大文字小文字変換
print("toupper:", vim.fn.toupper("hello"))  --> HELLO
print("tolower:", vim.fn.tolower("HELLO"))  --> hello

-- substitute: 文字列置換（正規表現）
-- substitute(expr, pat, sub, flags)
local result = vim.fn.substitute("Hello World", "World", "Lua", "")
print("substitute:", result)  --> Hello Lua

-- 全置換（flags に "g"）
local result2 = vim.fn.substitute("aaa bbb aaa", "aaa", "ccc", "g")
print("substitute(g):", result2)  --> ccc bbb ccc

-- match / matchstr: パターンマッチ
-- match: マッチ開始位置（0-indexed、マッチしなければ -1）
print("\nmatch:", vim.fn.match("hello world", "world"))  --> 6

-- matchstr: マッチした文字列
print("matchstr:", vim.fn.matchstr("hello 42 world", "\\d\\+"))  --> 42

-- split: 文字列分割（Vimscript版）
local parts = vim.fn.split("a:b:c", ":")
print("split:", vim.inspect(parts))  --> { "a", "b", "c" }

-- join: テーブルを結合
local joined = vim.fn.join({ "a", "b", "c" }, ", ")
print("join:", joined)  --> a, b, c

-- printf: フォーマット
local formatted = vim.fn.printf("name=%s age=%d", "Alice", 25)
print("printf:", formatted)

-- ========================================
-- リスト・辞書操作
-- ========================================

print("\n=== リスト・辞書操作 ===")

-- range: 数列を生成
local nums = vim.fn.range(5)     -- {0, 1, 2, 3, 4}
print("range(5):", vim.inspect(nums))

local nums2 = vim.fn.range(1, 5)  -- {1, 2, 3, 4, 5}
print("range(1,5):", vim.inspect(nums2))

-- sort / reverse
local sorted = vim.fn.sort({ "banana", "apple", "cherry" })
print("sort:", vim.inspect(sorted))

local reversed = vim.fn.reverse({ 1, 2, 3, 4 })
print("reverse:", vim.inspect(reversed))

-- map / filter（Vimscript 版）
-- ★ 注意: vim.fn.map / vim.fn.filter は元のリストを変更する
-- Lua の vim.tbl_map / vim.tbl_filter を使う方が安全

-- keys / values / items
local dict = { a = 1, b = 2, c = 3 }
print("keys:", vim.inspect(vim.fn.keys(dict)))
print("values:", vim.inspect(vim.fn.values(dict)))

-- ========================================
-- システム関連
-- ========================================

print("\n=== システム関連 ===")

-- system: 外部コマンドを実行して結果を取得
local output = vim.fn.system("echo hello")
print("system:", vim.trim(output))  --> hello

-- systemlist: 結果をリストで取得（各行が要素）
local lines = vim.fn.systemlist("ls -la")
print("systemlist (最初の3行):")
for i = 1, math.min(3, #lines) do
  print("  " .. lines[i])
end

-- v:shell_error でコマンドの終了コードを確認
vim.fn.system("true")
print("\nexit code (true):", vim.v.shell_error)  --> 0

vim.fn.system("false")
print("exit code (false):", vim.v.shell_error)  --> 1

-- executable: コマンドが使えるか
print("\nexecutable:")
print("  git:", vim.fn.executable("git"))      --> 1 or 0
print("  nvim:", vim.fn.executable("nvim"))    --> 1

-- ========================================
-- 入力・UI 関連
-- ========================================

print("\n=== 入力・UI 関連（参考） ===")

-- 以下は対話的な関数のため headless では使いにくいが知っておくと便利

-- input: ユーザー入力を受け取る
-- local name = vim.fn.input("名前を入力: ")

-- confirm: 確認ダイアログ
-- local choice = vim.fn.confirm("保存しますか？", "&Yes\n&No")

-- inputlist: 選択リスト
-- local n = vim.fn.inputlist({"選んでください:", "1. Option A", "2. Option B"})

-- ========================================
-- vim.fn vs vim.api の使い分け
-- ========================================

print("\n=== vim.fn vs vim.api ===")

-- vim.api: Neovim 専用の C API バインディング
--   - 型安全で高速
--   - nvim_ プレフィックスの関数
--   - Neovim 固有の機能

-- vim.fn: Vimscript の組み込み関数
--   - Vim 互換の関数を呼べる
--   - ファイルパス操作、文字列操作に豊富
--   - 一部は vim.api より遅い

-- 使い分けの目安:
-- バッファ/ウィンドウ操作 → vim.api を使う
-- ファイルパス操作        → vim.fn を使う
-- 文字列操作              → Lua 標準 or vim.fn
-- 外部コマンド            → vim.fn.system or vim.system (0.10+)
-- オプション設定          → vim.opt を使う

print("バッファ行数 (vim.api):", vim.api.nvim_buf_line_count(0))
print("カレントdir (vim.fn):", vim.fn.getcwd())

print("\n===== Lesson 04 完了 =====")
