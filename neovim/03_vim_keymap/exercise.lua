--[[
  Exercise 03: vim.keymap（キーマッピング）

  TODO コメントの部分を埋めてください。
  完成したら `nvim -l exercise.lua` で実行して結果を確認できます。
]]

-- リーダーキーの設定
vim.g.mapleader = " "

-- ========================================
-- 問題 1: 基本的なキーマッピング
-- ========================================

-- TODO: ノーマルモードで "<leader>w" を ":w<CR>" にマッピングしてください
-- desc を "ファイル保存" に設定する

-- ここに実装

-- 検証: マッピングが存在するか確認
local maps = vim.api.nvim_get_keymap("n")
local found_w = false
for _, map in ipairs(maps) do
  if map.lhs == " w" then
    found_w = true
    assert(map.desc == "ファイル保存", "desc が 'ファイル保存' ではありません")
  end
end
assert(found_w, "<leader>w のマッピングが見つかりません")
print("問題1: OK")

-- ========================================
-- 問題 2: Lua 関数をコールバックに使う
-- ========================================

-- TODO: ノーマルモードで "<leader>c" を押すと
-- vim.g.callback_called に true を設定するマッピングを作成してください
-- desc は "コールバックテスト" にする

vim.g.callback_called = false

-- ここに実装

-- 検証
local maps2 = vim.api.nvim_get_keymap("n")
local found_c = false
for _, map in ipairs(maps2) do
  if map.lhs == " c" then
    found_c = true
    assert(map.callback ~= nil, "Lua コールバックが設定されていません")
  end
end
assert(found_c, "<leader>c のマッピングが見つかりません")
print("問題2: OK")

-- ========================================
-- 問題 3: 複数モードへのマッピング
-- ========================================

-- TODO: ノーマルモードとビジュアルモードの両方で
-- "<leader>y" を '"+y' にマッピングしてください
-- desc は "クリップボードにヤンク" にする
-- ヒント: モードをテーブルで指定する { "n", "v" }

-- ここに実装

local n_maps = vim.api.nvim_get_keymap("n")
local v_maps = vim.api.nvim_get_keymap("v")
local found_n = false
local found_v = false
for _, map in ipairs(n_maps) do
  if map.lhs == " y" then found_n = true end
end
for _, map in ipairs(v_maps) do
  if map.lhs == " y" then found_v = true end
end
assert(found_n, "ノーマルモードに <leader>y が見つかりません")
assert(found_v, "ビジュアルモードに <leader>y が見つかりません")
print("問題3: OK")

-- ========================================
-- 問題 4: silent オプション付きマッピング
-- ========================================

-- TODO: ノーマルモードで "<leader>n" を ":nohlsearch<CR>" にマッピング
-- silent = true, desc = "検索ハイライト消去" を設定

-- ここに実装

local maps4 = vim.api.nvim_get_keymap("n")
local found_n4 = false
for _, map in ipairs(maps4) do
  if map.lhs == " n" then
    found_n4 = true
    assert(map.silent == 1, "silent が設定されていません")
  end
end
assert(found_n4, "<leader>n のマッピングが見つかりません")
print("問題4: OK")

-- ========================================
-- 問題 5: バッファローカルマッピング
-- ========================================

-- TODO: 現在のバッファだけに有効なマッピングを作成してください
-- ノーマルモードで "<leader>l" を Lua 関数にマッピング
-- 関数の中で vim.b.local_test = "done" を設定する
-- オプション: buffer = true, desc = "ローカルテスト"

-- ここに実装

local buf_maps5 = vim.api.nvim_buf_get_keymap(0, "n")
local found_l = false
for _, map in ipairs(buf_maps5) do
  if map.lhs == " l" then
    found_l = true
    assert(map.buffer ~= 0, "バッファローカルではありません")
  end
end
assert(found_l, "バッファローカルの <leader>l が見つかりません")
print("問題5: OK")

-- ========================================
-- 問題 6: マッピングの削除
-- ========================================

-- TODO: 以下の手順を行ってください
-- ステップ1: ノーマルモードで "<leader>z" を ":echo 'temp'<CR>" にマッピング
-- ステップ2: vim.keymap.del でそのマッピングを削除

-- ステップ1
-- ここに実装

-- ステップ2
-- ここに実装

local maps6 = vim.api.nvim_get_keymap("n")
local found_z = false
for _, map in ipairs(maps6) do
  if map.lhs == " z" then found_z = true end
end
assert(not found_z, "<leader>z がまだ存在しています")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: キーマッピング登録関数
-- ========================================

-- TODO: キーマッピングをまとめて登録する関数を作成してください
-- 仕様:
-- 1. register_keymaps(mappings) 関数を作成
-- 2. mappings はテーブルの配列: { { mode, lhs, rhs, opts }, ... }
-- 3. 各要素に対して vim.keymap.set を呼ぶ

local function register_keymaps(mappings)
  -- ここを実装
end

register_keymaps({
  { "n", "<leader>1", ":echo '1'<CR>", { desc = "数字1" } },
  { "n", "<leader>2", ":echo '2'<CR>", { desc = "数字2" } },
  { "n", "<leader>3", function() vim.g.three_called = true end, { desc = "数字3" } },
})

local maps_c = vim.api.nvim_get_keymap("n")
local found_1, found_2, found_3 = false, false, false
for _, map in ipairs(maps_c) do
  if map.lhs == " 1" and map.desc == "数字1" then found_1 = true end
  if map.lhs == " 2" and map.desc == "数字2" then found_2 = true end
  if map.lhs == " 3" and map.desc == "数字3" then found_3 = true end
end
assert(found_1, "<leader>1 が見つかりません")
assert(found_2, "<leader>2 が見つかりません")
assert(found_3, "<leader>3 が見つかりません")
print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
