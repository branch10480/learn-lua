--[[
  Lesson 04: OOPパターン

  この章で学ぶこと:
  - コロン記法と self の関係
  - メタテーブルを使ったクラスパターン
  - メソッドの定義
  - 継承の実装
  - 親クラスのメソッド呼び出し
  - Neovimプラグインで使われる実践的なパターン
]]

-- ========================================
-- コロン記法の復習
-- ========================================

-- ドット記法: 自分で self を渡す
-- コロン記法: 自動的に self が第1引数になる

local obj = { name = "Alice" }

-- この2つは完全に同じ
function obj.greet_dot(self)
  return "Hello, " .. self.name
end

function obj:greet_colon()
  return "Hello, " .. self.name
end

-- 呼び出しも同じ
print(obj.greet_dot(obj))   --> "Hello, Alice"
print(obj:greet_colon())    --> "Hello, Alice"（obj が自動で self になる）

-- ========================================
-- メタテーブルを使ったクラスパターン
-- ========================================

-- Luaで最もよく使われる「クラス」の実装パターン

local Animal = {}
Animal.__index = Animal  -- ★ これが重要

function Animal.new(name, sound)
  local instance = {
    name = name,
    sound = sound,
  }
  return setmetatable(instance, Animal)
  -- instance のメタテーブルに Animal を設定
  -- instance にないキーは Animal から検索される（__index）
end

function Animal:speak()
  return self.name .. " says " .. self.sound
end

function Animal:get_name()
  return self.name
end

local cat = Animal.new("ミケ", "ニャー")
local dog = Animal.new("ポチ", "ワン")

print("\nクラスパターン:")
print(cat:speak())  --> "ミケ says ニャー"
print(dog:speak())  --> "ポチ says ワン"

-- 仕組み:
-- cat:speak() → cat に speak がない → __index で Animal を検索
-- Animal.speak が見つかる → cat が self として渡される

-- ========================================
-- メソッドの定義
-- ========================================

-- コロン記法でメソッドを定義すると self が暗黙的に入る
function Animal:set_sound(new_sound)
  self.sound = new_sound
end

cat:set_sound("ゴロゴロ")
print("\n変更後:", cat:speak())  --> "ミケ says ゴロゴロ"

-- ========================================
-- 継承
-- ========================================

-- Dog が Animal を「継承」する

-- Animal.__index = Animal なので、Animal 自体をメタテーブルにできる
local Dog = setmetatable({}, Animal)
Dog.__index = Dog

-- Dog専用のコンストラクタ
function Dog.new(name, breed)
  -- Animal.new を呼んでベースを作る
  local instance = Animal.new(name, "ワン!")
  instance.breed = breed
  return setmetatable(instance, Dog)
  -- __index の検索順: instance → Dog → Animal
end

-- Dog専用のメソッド
function Dog:fetch(item)
  return self.name .. " fetches the " .. item
end

-- Animal のメソッドをオーバーライド
function Dog:speak()
  return self.name .. "(" .. self.breed .. ") says " .. self.sound
end

local shiba = Dog.new("タロウ", "柴犬")

print("\n継承:")
print(shiba:speak())          --> "タロウ(柴犬) says ワン!"（オーバーライド）
print(shiba:get_name())       --> "タロウ"（Animal から継承）
print(shiba:fetch("ボール"))   --> "タロウ fetches the ボール"（Dog独自）

-- ========================================
-- 親クラスのメソッド呼び出し
-- ========================================

-- オーバーライドしたメソッド内で親のメソッドも呼びたい場合

local Cat = setmetatable({}, Animal)
Cat.__index = Cat

function Cat.new(name, indoor)
  local instance = Animal.new(name, "ニャー")
  instance.indoor = indoor or false
  return setmetatable(instance, Cat)
end

function Cat:speak()
  -- 親の speak を呼んでから追加情報をつける
  local base = Animal.speak(self)  -- 明示的に Animal.speak を呼ぶ
  if self.indoor then
    return base .. " (室内猫)"
  end
  return base
end

local indoor_cat = Cat.new("タマ", true)
local outdoor_cat = Cat.new("クロ", false)

print("\n親メソッド呼び出し:")
print(indoor_cat:speak())   --> "タマ says ニャー (室内猫)"
print(outdoor_cat:speak())  --> "クロ says ニャー"

-- ========================================
-- instanceof チェック
-- ========================================

-- getmetatable でインスタンスの型を確認できる

local function is_instance(obj, class)
  local mt = getmetatable(obj)
  while mt do
    if mt == class then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

print("\ninstanceof チェック:")
print("shiba is Dog?", is_instance(shiba, Dog))       --> true
print("shiba is Animal?", is_instance(shiba, Animal))  --> true
print("shiba is Cat?", is_instance(shiba, Cat))         --> false

-- ========================================
-- 実践: Neovimプラグインでよく見るパターン
-- ========================================

--[[
  Neovimプラグインの典型的な構造:

  -- lua/my_plugin/init.lua
  local M = {}

  local Config = {}
  Config.__index = Config

  function Config.new(opts)
    local self = setmetatable({}, Config)
    self.enabled = opts.enabled or true
    self.mappings = opts.mappings or {}
    return self
  end

  local config = nil

  function M.setup(opts)
    config = Config.new(opts or {})
  end

  function M.is_enabled()
    return config and config.enabled
  end

  return M

  -- 使用側:
  -- require("my_plugin").setup({ enabled = true })
]]

print("\n===== Lesson 04 完了 =====")
