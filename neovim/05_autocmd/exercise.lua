--[[
  Exercise 05: autocmd と augroup

  TODO コメントの部分を埋めてください。
  完成したら `nvim -l exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: 基本的な autocmd の作成
-- ========================================

-- TODO: BufEnter イベントで全てのファイル（"*"）に対して
-- vim.g.buf_enter_count をインクリメントする autocmd を作成してください
-- desc は "バッファ入場カウント" にする

vim.g.buf_enter_count = 0

-- ここに実装

-- 検証: autocmd が作成されていることを確認
local autocmds = vim.api.nvim_get_autocmds({ event = "BufEnter" })
local found = false
for _, ac in ipairs(autocmds) do
  if ac.desc == "バッファ入場カウント" then
    found = true
  end
end
assert(found, "BufEnter の autocmd が見つかりません")
print("問題1: OK")

-- ========================================
-- 問題 2: augroup の作成
-- ========================================

-- TODO: "MyExerciseGroup" という名前の augroup を作成してください
-- clear = true を指定する

local group_id = nil  -- ここを修正

assert(type(group_id) == "number", "group_id が数値ではありません")
print("問題2: OK (group_id = " .. group_id .. ")")

-- ========================================
-- 問題 3: augroup 付き autocmd
-- ========================================

-- TODO: 問題2で作成した augroup に以下の autocmd を作成してください
-- イベント: FileType
-- パターン: "lua"
-- コールバック: vim.g.lua_filetype_detected = true を設定
-- desc: "Lua ファイルタイプ検出"

-- ここに実装

local ft_autocmds = vim.api.nvim_get_autocmds({
  group = "MyExerciseGroup",
  event = "FileType",
})
assert(#ft_autocmds >= 1, "FileType の autocmd が見つかりません")
local found_ft = false
for _, ac in ipairs(ft_autocmds) do
  if ac.desc == "Lua ファイルタイプ検出" then
    found_ft = true
  end
end
assert(found_ft, "正しい desc の autocmd が見つかりません")
print("問題3: OK")

-- ========================================
-- 問題 4: 複数イベントの autocmd
-- ========================================

-- TODO: BufEnter と BufLeave の両方のイベントで発火する autocmd を作成
-- augroup: "MyExerciseGroup"
-- パターン: "*"
-- コールバック: vim.g.multi_event_fired = true を設定
-- desc: "複数イベント"
-- ヒント: イベントをテーブルで指定する

-- ここに実装

local enter_acs = vim.api.nvim_get_autocmds({
  group = "MyExerciseGroup",
  event = "BufEnter",
})
local leave_acs = vim.api.nvim_get_autocmds({
  group = "MyExerciseGroup",
  event = "BufLeave",
})
local found_enter = false
local found_leave = false
for _, ac in ipairs(enter_acs) do
  if ac.desc == "複数イベント" then found_enter = true end
end
for _, ac in ipairs(leave_acs) do
  if ac.desc == "複数イベント" then found_leave = true end
end
assert(found_enter, "BufEnter の autocmd が見つかりません")
assert(found_leave, "BufLeave の autocmd が見つかりません")
print("問題4: OK")

-- ========================================
-- 問題 5: autocmd の削除
-- ========================================

-- TODO: 以下の手順を行ってください
-- ステップ1: CursorHold イベントの autocmd を作成し、ID を変数に保存
-- ステップ2: その ID を使って autocmd を削除

-- ステップ1
local autocmd_id = nil  -- ここを修正

-- ステップ2
-- ここに実装

-- 検証: 削除されたことを確認
local ok, err = pcall(function()
  -- 削除済みの ID でもう一度削除しようとするとエラー
  vim.api.nvim_del_autocmd(autocmd_id)
end)
assert(not ok, "autocmd がまだ存在しています")
print("問題5: OK")

-- ========================================
-- 問題 6: once オプション
-- ========================================

-- TODO: once = true の autocmd を作成してください
-- イベント: BufEnter
-- パターン: "*"
-- コールバック: vim.g.once_executed = true を設定
-- once: true
-- desc: "一回限り"

vim.g.once_executed = false

-- ここに実装

local once_acs = vim.api.nvim_get_autocmds({ event = "BufEnter" })
local found_once = false
for _, ac in ipairs(once_acs) do
  if ac.desc == "一回限り" and ac.once then
    found_once = true
  end
end
assert(found_once, "once = true の autocmd が見つかりません")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: ファイルタイプ設定マネージャー
-- ========================================

-- TODO: ファイルタイプごとの設定をまとめて登録する関数を作成してください
-- 仕様:
-- 1. setup_filetypes(config) 関数を作成
-- 2. config はテーブル: { lua = { tabstop = 2 }, python = { tabstop = 4 }, ... }
-- 3. 各ファイルタイプに対して FileType autocmd を作成
-- 4. コールバックでは vim.bo[args.buf] に設定を適用
-- 5. augroup "FileTypeSettings" を使う（clear = true）

local function setup_filetypes(config)
  -- ここを実装
end

setup_filetypes({
  lua = { tabstop = 2, shiftwidth = 2, expandtab = true },
  python = { tabstop = 4, shiftwidth = 4, expandtab = true },
  go = { tabstop = 4, shiftwidth = 4, expandtab = false },
})

-- 検証: 各ファイルタイプの autocmd が存在するか
local ft_acs = vim.api.nvim_get_autocmds({
  group = "FileTypeSettings",
  event = "FileType",
})

-- 3つのファイルタイプ分の autocmd が作成されているか
assert(#ft_acs >= 3, "FileType の autocmd が3つ以上ありません: " .. #ft_acs)

-- パターンに lua, python, go が含まれているか確認
local patterns = {}
for _, ac in ipairs(ft_acs) do
  if ac.pattern then
    patterns[ac.pattern] = true
  end
end
assert(patterns["lua"], "lua パターンの autocmd が見つかりません")
assert(patterns["python"], "python パターンの autocmd が見つかりません")
assert(patterns["go"], "go パターンの autocmd が見つかりません")

-- 実際に FileType を設定して動作確認
local test_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(test_buf)
vim.bo[test_buf].filetype = "lua"

assert(vim.bo[test_buf].tabstop == 2, "Lua の tabstop が 2 ではありません")
assert(vim.bo[test_buf].shiftwidth == 2, "Lua の shiftwidth が 2 ではありません")
assert(vim.bo[test_buf].expandtab == true, "Lua の expandtab が true ではありません")

vim.bo[test_buf].filetype = "python"
assert(vim.bo[test_buf].tabstop == 4, "Python の tabstop が 4 ではありません")

vim.bo[test_buf].filetype = "go"
assert(vim.bo[test_buf].expandtab == false, "Go の expandtab が false ではありません")

-- テスト用バッファを削除
vim.api.nvim_buf_delete(test_buf, { force = true })

print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
