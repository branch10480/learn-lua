--[[
  Exercise 04: OOPパターン

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: 基本クラスの作成
-- ========================================

-- TODO: Animal クラスを作成
-- Animal.new(name, sound) でインスタンスを返す
-- Animal:speak() で "<name> says <sound>" を返す

local Animal = {}
Animal.__index = Animal

-- ここから下に実装

-- ここまで

local cat = Animal.new("ミケ", "ニャー")
assert(cat:speak() == "ミケ says ニャー", "speak が正しくありません")
assert(cat.name == "ミケ", "name が正しくありません")

local dog = Animal.new("ポチ", "ワン")
assert(dog:speak() == "ポチ says ワン", "speak が正しくありません")
print("問題1: OK")

-- ========================================
-- 問題 2: メソッドの追加
-- ========================================

-- TODO: Animal に以下のメソッドを追加
-- Animal:rename(new_name): 名前を変更する
-- Animal:get_info(): "<name> (<sound>)" を返す

-- ここから下に実装

-- ここまで

cat:rename("タマ")
assert(cat.name == "タマ", "rename が正しくありません")
assert(cat:get_info() == "タマ (ニャー)", "get_info が正しくありません")
print("問題2: OK")

-- ========================================
-- 問題 3: 継承の実装
-- ========================================

-- TODO: Dog クラスを Animal から継承して作成
-- Dog.new(name, breed) でインスタンスを返す（sound は "ワン!" 固定）
-- Dog:speak() をオーバーライドして "<name>(<breed>) says <sound>" を返す
-- Dog:fetch(item) で "<name> fetches <item>" を返す

local Dog = setmetatable({}, Animal)
Dog.__index = Dog

-- ここから下に実装

-- ここまで

local shiba = Dog.new("タロウ", "柴犬")
assert(shiba:speak() == "タロウ(柴犬) says ワン!", "Dog:speak が正しくありません")
assert(shiba:fetch("ボール") == "タロウ fetches ボール", "fetch が正しくありません")
-- 継承した get_info も使える
assert(shiba:get_info() == "タロウ (ワン!)", "継承した get_info が正しくありません")
print("問題3: OK")

-- ========================================
-- 問題 4: 親メソッドの呼び出し
-- ========================================

-- TODO: Cat クラスを Animal から継承して作成
-- Cat.new(name, lives) でインスタンスを返す（sound は "ニャー" 固定、lives はデフォルト 9）
-- Cat:speak() をオーバーライド: Animal:speak() の結果 + " (残り<lives>命)" を返す

local Cat = setmetatable({}, Animal)
Cat.__index = Cat

-- ここから下に実装

-- ここまで

local neko = Cat.new("クロ", 7)
assert(neko:speak() == "クロ says ニャー (残り7命)", "Cat:speak が正しくありません: " .. neko:speak())

local neko2 = Cat.new("シロ")
assert(neko2:speak() == "シロ says ニャー (残り9命)", "デフォルトの lives が正しくありません")
print("問題4: OK")

-- ========================================
-- 問題 5: 複数クラスの連携
-- ========================================

-- TODO: Shelter（動物シェルター）クラスを作成
-- Shelter.new(name) でインスタンスを返す（内部に animals = {} を持つ）
-- Shelter:add(animal): Animal インスタンスを追加
-- Shelter:count(): 動物の数を返す
-- Shelter:list_names(): 全動物の名前をカンマ区切りで返す

local Shelter = {}
Shelter.__index = Shelter

-- ここから下に実装

-- ここまで

local shelter = Shelter.new("ハッピーシェルター")
shelter:add(Animal.new("ポチ", "ワン"))
shelter:add(Animal.new("ミケ", "ニャー"))
shelter:add(Animal.new("ピー", "ピヨ"))

assert(shelter:count() == 3, "count が正しくありません")
assert(shelter:list_names() == "ポチ, ミケ, ピー", "list_names が正しくありません: " .. shelter:list_names())
print("問題5: OK")

-- ========================================
-- 問題 6: ミックスイン
-- ========================================

-- TODO: ミックスイン関数を作成
-- mixin(target, source): source の全メソッドを target にコピーする
-- これにより多重継承風の機能追加ができる

local function mixin(target, source)
  -- ここを実装
end

-- Serializable ミックスイン: to_string() メソッドを提供
local Serializable = {}
function Serializable:to_string()
  local parts = {}
  for k, v in pairs(self) do
    if type(v) ~= "function" then
      table.insert(parts, k .. "=" .. tostring(v))
    end
  end
  table.sort(parts)
  return "{" .. table.concat(parts, ", ") .. "}"
end

-- Printable ミックスイン: display() メソッドを提供
local Printable = {}
function Printable:display()
  return "[" .. (self.name or "unknown") .. "]"
end

-- Item クラスにミックスインを適用
local Item = {}
Item.__index = Item

function Item.new(name, price)
  return setmetatable({ name = name, price = price }, Item)
end

mixin(Item, Serializable)
mixin(Item, Printable)

local item = Item.new("Lua本", 3000)
assert(item:display() == "[Lua本]", "display が正しくありません")
-- to_string の結果にキーが含まれているか確認
local s = item:to_string()
assert(s:find("name=Lua本"), "to_string に name が含まれていません")
assert(s:find("price=3000"), "to_string に price が含まれていません")
print("問題6: OK")

-- ========================================
-- チャレンジ問題: Logger クラス
-- ========================================

-- TODO: Logger クラスを作成
-- 仕様:
-- 1. Logger.new(name, level) でインスタンスを返す
--    level は "DEBUG"=1, "INFO"=2, "WARN"=3, "ERROR"=4（デフォルト: "INFO"）
-- 2. Logger:log(level, message): level が設定値以上なら記録、未満なら無視
--    記録形式: "[<level>] <name>: <message>"
--    記録は内部の logs 配列に保存する
-- 3. Logger:debug(msg), Logger:info(msg), Logger:warn(msg), Logger:error(msg)
--    それぞれ対応するレベルで log を呼ぶショートカット
-- 4. Logger:get_logs(): logs 配列を返す
-- 5. Logger:child(child_name): 子ロガーを返す
--    子ロガーの name は "<parent_name>.<child_name>"
--    子ロガーは親と同じ logs 配列を共有する（同じテーブルを参照）

local Logger = {}
Logger.__index = Logger

local LEVELS = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4 }

-- ここから下に実装

-- ここまで

local logger = Logger.new("app", "WARN")
logger:debug("デバッグ情報")  -- WARN以上のみなので記録されない
logger:info("情報メッセージ")  -- 記録されない
logger:warn("警告です")        -- 記録される
logger:error("エラー発生")     -- 記録される

local logs = logger:get_logs()
assert(#logs == 2, "ログの数が正しくありません: " .. #logs)
assert(logs[1] == "[WARN] app: 警告です", "1番目のログが正しくありません: " .. logs[1])
assert(logs[2] == "[ERROR] app: エラー発生", "2番目のログが正しくありません: " .. logs[2])

-- child ロガーのテスト
local child = logger:child("db")
child:warn("接続タイムアウト")
child:error("切断されました")

-- 親と同じ logs を共有
assert(#logs == 4, "child のログが親の logs に追加されていません: " .. #logs)
assert(logs[3] == "[WARN] app.db: 接続タイムアウト", "child のログ形式が正しくありません: " .. logs[3])

print("チャレンジ: OK")

print("\n===== 全ての問題をクリアしました！ =====")
