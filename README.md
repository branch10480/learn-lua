# Learn Lua

Lua言語を基礎から学習し、Neovimの設定を自分で書けるようになることを目指すリポジトリです。

## 学習目標

**最終目標**: Neovimの設定（init.lua）を自分で書けるようになる

### ステップ別目標

1. **Lua基礎文法の習得**
   - 変数とデータ型
   - 制御構造（if, for, while）
   - 関数の定義と呼び出し
   - テーブル（Luaの最重要データ構造）

2. **Lua言語特性の理解**
   - 1-indexed配列
   - メタテーブルとメタメソッド
   - モジュールシステム（require）
   - コルーチン

3. **Neovim Lua APIの学習**
   - vim.api の基本
   - vim.opt（オプション設定）
   - vim.keymap（キーマッピング）
   - vim.fn（Vimscript関数呼び出し）
   - autocmd と augroup

4. **実践的なNeovim設定**
   - プラグインマネージャー（lazy.nvim等）の設定
   - LSP設定
   - 補完設定
   - 自作プラグインの作成

## ディレクトリ構成（予定）

```
learn-lua/
├── basics/          # Lua基礎文法の練習
├── advanced/        # 高度な言語機能
├── neovim/          # Neovim API練習
└── config/          # 実際のNeovim設定の練習
```

## 参考リソース

- [Lua 5.1 Reference Manual](https://www.lua.org/manual/5.1/)（Neovimが使用するバージョン）
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [nvim-lua-guide (日本語)](https://github.com/willelz/nvim-lua-guide-ja)

## 環境

- Lua 5.1（Neovim内蔵のLuaJIT互換）
- Neovim 0.9+

## メモ

学習の進捗やメモはこのリポジトリ内に随時追加していきます。
