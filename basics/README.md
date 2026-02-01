# Lua基礎 実践教材

## 教材の構成

各レッスンには2つのファイルがあります：

| ファイル | 内容 |
|---------|------|
| `lesson.lua` | 解説とサンプルコード（読んで実行） |
| `exercise.lua` | 演習問題（TODO を埋める） |

## 学習の進め方

### 1. レッスンを読む・実行する

```bash
cd basics/01_variables
lua lesson.lua
```

コードを読みながら、出力を確認してください。

### 2. 演習問題を解く

```bash
lua exercise.lua
```

最初はエラーが出ます。`TODO` コメントの部分を実装して、全ての `assert` が通るようにしてください。

### 3. 順番に進める

```
01_variables     → 変数とデータ型
02_control_flow  → 制御構造（if, for, while）
03_functions     → 関数
04_tables        → テーブル（最重要！）
```

## レッスン一覧

### 01_variables - 変数とデータ型
- グローバル変数とローカル変数
- 基本データ型（nil, boolean, number, string）
- 文字列操作（結合 `..`、長さ `#`）
- 型変換（`tonumber`, `tostring`）

### 02_control_flow - 制御構造
- if / elseif / else
- 論理演算子（`and`, `or`, `not`）
- while, repeat-until
- 数値 for、汎用 for（`ipairs`, `pairs`）
- `break`（※`continue` は存在しない）
- 比較演算子（`~=` は等しくない）

### 03_functions - 関数
- 関数定義（`function`, 無名関数）
- 複数の戻り値
- デフォルト引数パターン（`or` で代用）
- 可変長引数（`...`）
- 高階関数、クロージャ

### 04_tables - テーブル
- 配列（**1-indexed!**）
- 辞書（連想配列）
- `ipairs` vs `pairs`
- テーブルは参照型
- オブジェクト指向パターン

## Lua特有の注意点

```lua
-- 配列は1から始まる
local arr = {"a", "b", "c"}
print(arr[1])  -- "a"（0ではない！）

-- 文字列結合は + ではなく ..
local s = "Hello" .. " " .. "World"

-- 不等号は != ではなく ~=
if x ~= y then ... end

-- インクリメントは存在しない
count = count + 1  -- count++ は使えない

-- continue は存在しない
-- 代わりに条件を工夫する
```

## 困ったときは

- `lua lesson.lua` でサンプルを再確認
- `print()` でデバッグ出力
- `type(変数)` で型を確認
