--[[
  Lesson 03: メタテーブルとメタメソッド

  この章で学ぶこと:
  - メタテーブルの概念と setmetatable / getmetatable
  - __index: キーが存在しないときの処理
  - __newindex: 新しいキーへの代入の制御
  - 算術メタメソッド（__add, __sub, __tostring 等）
  - __call: テーブルを関数のように呼ぶ
  - rawget / rawset でメタメソッドをバイパス
]]

-- ========================================
-- メタテーブルとは
-- ========================================

-- メタテーブルはテーブルの「振る舞い」を定義する仕組み
-- 例: + 演算子でテーブル同士を足す、存在しないキーのデフォルト値、etc.

local t = {}
local mt = {}  -- メタテーブル

setmetatable(t, mt)  -- t のメタテーブルを mt に設定

-- getmetatable で確認
print("メタテーブル:", getmetatable(t) == mt)  --> true

-- setmetatable は設定したテーブル自身を返す（チェーンできる）
local t2 = setmetatable({}, {})

-- ★ 重要: メタテーブルの構造
-- メタテーブルは「メタメソッド」を格納するテーブル
-- メタメソッドは特別な名前のキー (__index, __newindex, __add, __call など)
-- 必要なメタメソッドだけを定義すればOK（全て必須ではない）
-- 例: { __index = ... }              -- __index だけ
--     { __call = ... }               -- __call だけ
--     { __index = ..., __add = ... } -- 複数のメタメソッド

-- ★ __index を使った継承・チェーンを作る場合の注意点:
-- ❌ 間違い: 通常のテーブルを直接メタテーブルとして渡す
-- local parent = { x = 1 }
-- local child = setmetatable({ y = 2 }, parent)  -- parent.__index が未定義

-- ✅ 正しい方法1: メタテーブルに __index フィールドを設定
-- local child = setmetatable({ y = 2 }, { __index = parent })

-- ✅ 正しい方法2: テーブル自身に __index を設定してからメタテーブルとして使う
-- parent.__index = parent
-- local child = setmetatable({ y = 2 }, parent)

-- ========================================
-- __index: キーが存在しないとき
-- ========================================

-- __index にテーブルを指定: フォールバック先として検索される
local defaults = { color = "white", size = 10 }
local config = setmetatable({}, { __index = defaults })

print("\nconfig.color =", config.color)  --> "white"（defaults から取得）
print("config.size =", config.size)      --> 10

-- config 自体にキーを設定すると、そちらが優先される
config.color = "red"
print("config.color =", config.color)  --> "red"（config 自身の値）

-- __index に関数を指定: 動的にデフォルト値を生成
local dynamic = setmetatable({}, {
  __index = function(self, key)
    return "デフォルト値: " .. key
  end
})

print("\ndynamic.foo =", dynamic.foo)    --> "デフォルト値: foo"
print("dynamic.bar =", dynamic.bar)      --> "デフォルト値: bar"

-- ★ Neovimでは vim.opt が __index を使って実装されている
-- vim.opt.number → 実際には __index メタメソッドが呼ばれる

-- ========================================
-- __newindex: 新しいキーへの代入
-- ========================================

-- テーブルに存在しないキーへ代入しようとすると呼ばれる
local readonly = setmetatable({}, {
  __newindex = function(self, key, value)
    error("このテーブルは読み取り専用です: " .. key)
  end
})

-- readonly.x = 10  --> エラー！

-- rawset を使うとメタメソッドをバイパスして直接設定できる
rawset(readonly, "x", 10)
print("\nrawset で設定:", readonly.x)  --> 10

-- __newindex でログを取るパターン
local logged = setmetatable({}, {
  __newindex = function(self, key, value)
    print("  設定:", key, "=", value)
    rawset(self, key, value)  -- 実際に値を設定
  end
})

print("\nログ付きテーブル:")
logged.name = "Alice"    --> 設定: name = Alice
logged.age = 25          --> 設定: age = 25

-- ========================================
-- 算術メタメソッド
-- ========================================

-- __add(+), __sub(-), __mul(*), __div(/), __mod(%), __pow(^), __unm(単項-)
-- __eq(==), __lt(<), __le(<=)
-- __tostring(文字列化), __concat(..)

-- 2Dベクトルの例
local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
  return setmetatable({ x = x, y = y }, Vector)
end

-- __add: + 演算子
Vector.__add = function(a, b)
  return Vector.new(a.x + b.x, a.y + b.y)
end

-- __tostring: tostring() や print() で使われる
Vector.__tostring = function(v)
  return "Vector(" .. v.x .. ", " .. v.y .. ")"
end

-- __eq: == 演算子
Vector.__eq = function(a, b)
  return a.x == b.x and a.y == b.y
end

local v1 = Vector.new(1, 2)
local v2 = Vector.new(3, 4)
local v3 = v1 + v2

print("\nベクトル演算:")
print("v1 =", tostring(v1))          --> Vector(1, 2)
print("v2 =", tostring(v2))          --> Vector(3, 4)
print("v1 + v2 =", tostring(v3))     --> Vector(4, 6)
print("v1 == v1 ?", v1 == Vector.new(1, 2))  --> true

-- ========================================
-- __call: テーブルを関数のように呼ぶ
-- ========================================

local multiplier = setmetatable({factor = 3}, {
  __call = function(self, value)
    return self.factor * value
  end
})

print("\n__call:")
print("multiplier(5) =", multiplier(5))    --> 15
print("multiplier(10) =", multiplier(10))  --> 30

-- ファクトリパターン
local Color = setmetatable({}, {
  __call = function(self, r, g, b)
    return { r = r, g = g, b = b }
  end
})

local red = Color(255, 0, 0)
print("red =", red.r, red.g, red.b)  --> 255, 0, 0

-- ========================================
-- rawget / rawset / rawequal
-- ========================================

-- メタメソッドをバイパスする関数群
-- rawget(t, k)      : __index を無視して直接取得
-- rawset(t, k, v)   : __newindex を無視して直接設定
-- rawequal(a, b)    : __eq を無視して直接比較

local proxy = setmetatable({}, {
  __index = function(self, key)
    return "メタテーブル経由"
  end
})

print("\nrawget vs 通常アクセス:")
print("proxy.foo =", proxy.foo)           --> "メタテーブル経由"
print("rawget =", rawget(proxy, "foo"))    --> nil（直接アクセス）

-- ========================================
-- __index チェーン（プロトタイプ継承）
-- ========================================

-- __index を連鎖させることで「継承」のような仕組みを作れる
local Animal = { type = "animal" }
Animal.__index = Animal

function Animal.speak(self)
  return "..."
end

local Dog = setmetatable({ breed = "unknown" }, { __index = Animal })
Dog.__index = Dog

function Dog.speak(self)
  return "ワン!"
end

local mydog = setmetatable({ name = "ポチ" }, { __index = Dog })

print("\n__index チェーン:")
print("name =", mydog.name)     --> "ポチ"（mydog 自身）
print("breed =", mydog.breed)   --> "unknown"（Dog から）
print("type =", mydog.type)     --> "animal"（Animal から）
print("speak =", mydog:speak()) --> "ワン!"（Dog から）

-- 検索順序: mydog → Dog → Animal
-- これが次のレッスン (OOP) の基盤になる

print("\n===== Lesson 03 完了 =====")
