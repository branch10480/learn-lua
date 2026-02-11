--[[
  Exercise 03: メタテーブルとメタメソッド

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: __index でデフォルト値
-- ========================================

-- TODO: キーが存在しないとき "unknown" を返すテーブルを作成
-- ヒント: __index に関数を設定する

local settings = setmetatable({}, {
  __index = function ()
    return "unknown"
  end
})

-- 明示的に設定した値はそのまま返る
settings = settings or {}
rawset(settings, "name", "Alice")

assert(settings.name == "Alice", "明示的な値が正しくありません")
assert(settings.color == "unknown", "デフォルト値が 'unknown' ではありません")
assert(settings.anything == "unknown", "デフォルト値が 'unknown' ではありません")
print("問題1: OK")

-- ========================================
-- 問題 2: __tostring の実装
-- ========================================

-- TODO: Point テーブルに __tostring メタメソッドを実装
-- tostring(p) で "Point(x, y)" という文字列を返すようにする

local Point = {}
Point.__index = Point

function Point.new(x, y)
  return setmetatable({ x = x, y = y }, Point)
end

-- TODO: __tostring を実装
Point.__tostring = function (self)
  return "Point(" .. tostring(self.x) .. ", " .. tostring(self.y)  .. ")"
end
-- ここに実装

local p = Point.new(3, 7)
assert(tostring(p) == "Point(3, 7)", "__tostring が正しくありません: " .. tostring(p))
assert(tostring(Point.new(0, 0)) == "Point(0, 0)", "Point(0, 0) のケース")
print("問題2: OK")

-- ========================================
-- 問題 3: __add で演算子オーバーロード
-- ========================================

-- TODO: Point に __add メタメソッドを実装
-- Point(1, 2) + Point(3, 4) → Point(4, 6) を返すようにする

-- ここに実装
Point.__add = function (lhs, rhs)
  return Point.new(
    lhs.x + rhs.x,
    lhs.y + rhs.y
  )
end

local p1 = Point.new(1, 2)
local p2 = Point.new(3, 4)
local p3 = p1 + p2

assert(p3.x == 4, "__add の x が正しくありません")
assert(p3.y == 6, "__add の y が正しくありません")
assert(tostring(p3) == "Point(4, 6)", "__add の結果が正しくありません")
print("問題3: OK")

-- ========================================
-- 問題 4: __newindex で読み取り専用テーブル
-- ========================================

-- TODO: 読み取り専用テーブルを作成する関数を実装
-- 既存のテーブルを受け取り、読み取り専用のプロキシを返す
-- 新しいキーへの代入で error("read-only table") を投げる
-- ヒント: __index で元テーブルを参照し、__newindex でエラーにする

local function make_readonly(t)
  local proxy = setmetatable({}, {
    __index = function (self, key)
      return t[key]
    end,
    __newindex = function (self, k, v)
      error("read-only table")
    end,
  })
  return proxy
end

local original = { a = 1, b = 2, c = 3 }
local frozen = make_readonly(original)

assert(frozen.a == 1, "frozen.a が読めません")
assert(frozen.b == 2, "frozen.b が読めません")

local ok, err = pcall(function()
  frozen.a = 999
end)
assert(ok == false, "代入がエラーにならなかった")
assert(err:find("read%-only table"), "エラーメッセージが正しくありません")
assert(original.a == 1, "original が変更されてしまいました")
print("問題4: OK")

-- ========================================
-- 問題 5: __index チェーン（プロトタイプ）
-- ========================================

-- TODO: 3段階のフォールバックチェーンを作成
-- base → middle → child の順で検索される
-- base:   { x = 1 }
-- middle: { y = 2 }（base をフォールバック）
-- child:  { z = 3 }（middle をフォールバック）

-- ここから下に実装
local base = { x = 1 }
local middle = setmetatable({ y = 2 }, { __index = base })
local child = setmetatable({ z = 3 }, { __index = middle })
-- ここまで

assert(child.z == 3, "child.z が正しくありません")
assert(child.y == 2, "child.y が正しくありません（middle から取得）")
assert(child.x == 1, "child.x が正しくありません（base から取得）")
print("問題5: OK")

-- ========================================
-- 問題 6: __call でファクトリ
-- ========================================

-- TODO: テーブル自身を関数として呼べるファクトリを作成
-- RGB(255, 0, 0) で { r = 255, g = 0, b = 0 } を返す
-- RGB テーブル自体に __call メタメソッドを設定する

local RGB = setmetatable({}, {
  __call = function (self, r, g, b)
    return { r = r, g = g, b = b }
  end
})

-- ここから下に実装

-- ここまで

local red = RGB(255, 0, 0)
local green = RGB(0, 255, 0)

assert(red.r == 255, "red.r が正しくありません")
assert(red.g == 0, "red.g が正しくありません")
assert(red.b == 0, "red.b が正しくありません")
assert(green.r == 0, "green.r が正しくありません")
assert(green.g == 255, "green.g が正しくありません")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: vim.opt 風の Config テーブル
-- ========================================

-- TODO: vim.opt のように動作する Config テーブルを作成
-- 仕様:
-- 1. Config.new() で新しい設定オブジェクトを返す
-- 2. config.option_name = value で設定値を格納
--    （内部テーブル _data に保存する）
-- 3. config.option_name で設定値を取得
-- 4. tostring(config) で "Config{ key1 = val1, key2 = val2, ... }" を返す
--    （キーはソートされた順序で出力）
-- ヒント: __index, __newindex, __tostring を全て使う
--         値の保存には rawset ではなく内部の _data テーブルを使う

local Config = {}

function Config.new()
  local config = setmetatable({ _data = {} }, {
    __newindex = function(self, key, value)
      self._data[key] = value
    end,
    __index = function (self, key)
      if key == "data" then
        error("couldn't access")
      end
      return self._data[key]
    end,
    __tostring = function (self)
      local keys = {}
      for k, _ in pairs(self._data) do
        table.insert(keys, k)
      end

      table.sort(keys, function(l, r) return l < r end)

      local str = "Config{ "
      for _, key in ipairs(keys) do
        if self._data[key] ~= nil then
          str = str .. tostring(key) .. " = " .. tostring(self._data[key]) .. ", "
        end
      end
      return str .. "}"
    end
  })
  return config
end

local cfg = Config.new()
cfg.number = true
cfg.tabstop = 4
cfg.shiftwidth = 4

assert(cfg.number == true, "cfg.number が正しくありません")
assert(cfg.tabstop == 4, "cfg.tabstop が正しくありません")
assert(cfg.shiftwidth == 4, "cfg.shiftwidth が正しくありません")

local str = tostring(cfg)
assert(str:find("Config{"), "tostring が 'Config{' で始まりません")
assert(str:find("number = true"), "tostring に 'number = true' が含まれません")
assert(str:find("tabstop = 4"), "tostring に 'tabstop = 4' が含まれません")

print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
