# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Lua言語を基礎から学習し、Neovimの設定（init.lua）を自分で書けるようになることを目指すリポジトリ。

## 実行環境

- **Lua**: 5.1（NeovimはLuaJIT互換のLua 5.1を使用）
- **Neovim**: 0.9以上

## コマンド

```bash
# Luaスクリプトの実行
lua <filename>.lua

# Neovim内でLuaを実行
nvim --cmd "lua print('Hello')"
# または Neovim内で :lua <コード>
```

## ディレクトリ構成

```
basics/
├── 01_variables/      # 変数とデータ型
├── 02_control_flow/   # 制御構造（if, for, while）
├── 03_functions/      # 関数
└── 04_tables/         # テーブル（最重要）
advanced/
├── 01_modules/        # モジュールとrequire
├── 02_error_handling/ # エラーハンドリング（pcall, xpcall）
├── 03_metatables/     # メタテーブルとメタメソッド
├── 04_oop/            # OOPパターン（クラス、継承）
└── 05_coroutines/     # コルーチン
neovim/
├── 01_vim_api/        # vim.api の基本（バッファ・ウィンドウ操作）
├── 02_vim_opt/        # vim.opt（オプション設定）
├── 03_vim_keymap/     # vim.keymap（キーマッピング）
├── 04_vim_fn/         # vim.fn（Vimscript関数呼び出し）
└── 05_autocmd/        # autocmd と augroup
config/                # 実際のNeovim設定の練習（未作成）
```

## 教材の使い方

各レッスンには `lesson.lua`（解説）と `exercise.lua`（演習）がある。

```bash
# 1. レッスンを読んで実行（basics / advanced）
cd basics/01_variables
lua lesson.lua

# 2. 演習問題を解く（TODOを埋める）
lua exercise.lua

# 3. Neovim API教材の実行（neovim/）
cd neovim/01_vim_api
nvim -l lesson.lua
nvim -l exercise.lua
```

演習は全て `assert` でチェックされ、正しく実装すると「全ての問題をクリアしました！」と表示される。

## Lua言語の注意点

- **配列は1-indexed**（0ではなく1から始まる）
- **テーブル**がLuaの中心的なデータ構造（配列、辞書、オブジェクト全てを表現）
- **nil**は存在しないことを表す（falseとは異なる）
- **モジュール**は`require("module_name")`で読み込む

## Neovim Lua API

- `vim.api` - Neovim APIへの直接アクセス
- `vim.opt` - オプション設定
- `vim.keymap.set()` - キーマッピング
- `vim.fn` - Vimscript関数の呼び出し
- `vim.cmd()` - Vimscriptコマンドの実行
