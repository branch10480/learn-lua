--[[
  Exercise 04: テーブル

  TODO コメントの部分を埋めてください。
  完成したら `lua exercise.lua` で実行して結果を確認できます。
]]

-- ========================================
-- 問題 1: 配列操作
-- ========================================

local colors = {"red", "green", "blue"}

-- TODO: 配列の末尾に "yellow" を追加
-- 学び: table.insert(t, value) は末尾に追加
--       table.insert(t, pos, value) は位置を指定して挿入
table.insert(colors, "yellow")


-- TODO: 配列の先頭（位置1）に "white" を挿入
table.insert(colors, 1, "white")


print("colors:", table.concat(colors, ", "))
assert(colors[1] == "white", "先頭が white ではありません")
assert(colors[5] == "yellow", "末尾が yellow ではありません")
assert(#colors == 5, "配列の長さが正しくありません")

-- ========================================
-- 問題 2: 辞書操作
-- ========================================

-- TODO: 以下のキーと値を持つテーブル book を作成
-- title: "Lua入門"
-- author: "山田太郎"
-- pages: 300
local book = {
  title = "Lua入門",
  author = "山田太郎",
  pages = 300
}


assert(book.title == "Lua入門", "title が正しくありません")
assert(book.author == "山田太郎", "author が正しくありません")
assert(book.pages == 300, "pages が正しくありません")

-- TODO: book に publisher = "技術出版社" を追加
book.publisher = "技術出版社"


assert(book.publisher == "技術出版社", "publisher が追加されていません")
print("book:", book.title, "by", book.author)

-- ========================================
-- 問題 3: テーブルの走査
-- ========================================

local scores = {math = 85, english = 72, science = 90}

-- TODO: 全教科の平均点を計算
-- ヒント: pairs でループし、合計と科目数をカウント
local average = 0

-- ここから下に実装
-- 学び: pairs と ipairs の使い分け
--   pairs(t)  → キーと値のペアを全て走査（辞書向け、順序不定）
--   ipairs(t) → 整数キー 1, 2, 3, ... を順番に走査（配列向け）
local count = 0
local total = 0
for _, v in pairs(scores) do
  count = count + 1
  total = total + v
end

average = total / count

-- ここまで

print("平均点:", average)
-- 許容誤差を考慮（浮動小数点）
assert(average > 82 and average < 83, "average が正しくありません（期待値: 約82.33）")

-- ========================================
-- 問題 4: 配列のフィルタリング
-- ========================================

local numbers = {1, 5, 12, 3, 8, 15, 6, 20}

-- TODO: 10以上の数値だけを含む新しい配列を作成
local large_numbers = {}

-- ここから下に実装

for _, v in ipairs(numbers) do
  if v >= 10 then
    table.insert(large_numbers, v)
  end
end

-- ここまで

print("10以上:", table.concat(large_numbers, ", "))
assert(#large_numbers == 3, "large_numbers の長さが正しくありません")
assert(large_numbers[1] == 12, "large_numbers[1] が正しくありません")

-- ========================================
-- 問題 5: ネストしたテーブル
-- ========================================

local students = {
  {name = "Alice", grades = {90, 85, 88}},
  {name = "Bob", grades = {75, 80, 82}},
  {name = "Charlie", grades = {95, 92, 98}},
}

-- TODO: 各生徒の平均点を計算し、最高平均点の生徒名を見つける
-- 学び: ネストしたテーブルでは、キー名に注意（grades と scores を間違えやすい）
--       定義したキー名と参照するキー名が一致しているか必ず確認する
local top_student = nil

-- ここから下に実装

local function get_average(t)
  local count = 0
  local total = 0
  for _, score in ipairs(t) do
    count = count + 1
    total = total + score
  end
  return total / count
end

local max_score = 0
for _, student in ipairs(students) do
  local avg_score = get_average(student.grades)
  if avg_score > max_score then
    max_score = avg_score
    top_student = student.name
  end
end

-- ここまで

print("トップの生徒:", top_student)
assert(top_student == "Charlie", "top_student が正しくありません")

-- ========================================
-- 問題 6: テーブルのシャローコピー
-- ========================================

-- TODO: テーブルのシャローコピーを作成する関数
-- 学び: Luaのテーブル代入は参照のコピー（= で代入すると同じテーブルを指す）
--       独立したコピーを作るには pairs で全キーを新しいテーブルにコピーする
--       ただしシャローコピーなので、値がテーブルの場合はその参照が共有される
local function copy_table(t)
  local copied = {}
  for k, v in pairs(t) do
    copied[k] = v
  end
  return copied
end

local original = {a = 1, b = 2, c = 3}
local copied = copy_table(original)
copied.a = 999

assert(original.a == 1, "original が変更されてしまいました")
assert(copied.a == 999, "copied の変更が反映されていません")
print("シャローコピー: OK")

-- ========================================
-- チャレンジ問題: スタックの実装
-- ========================================

-- TODO: push, pop, peek, is_empty メソッドを持つスタックを作成
local function create_stack()
  local stack = {
    items = {}
  }

  -- TODO: 要素を追加
  function stack.push(value)
    table.insert(stack.items, value)
  end

  -- TODO: 要素を取り出して返す（なければ nil）
  -- 学び: table.remove(t) は末尾要素を削除して「返す」
  --       インデックス省略時は末尾が対象なので、スタックの pop に最適
  function stack.pop()
    return table.remove(stack.items)
  end

  -- TODO: 先頭要素を返す（取り出さない）
  function stack.peek()
    return stack.items[#stack.items]
  end

  -- TODO: スタックが空かどうか
  function stack.is_empty()
    return #stack.items == 0
  end

  return stack
end

local s = create_stack()
assert(s.is_empty() == true, "空のスタックのはずです")

s.push(10)
s.push(20)
s.push(30)

assert(s.peek() == 30, "peek が正しくありません")
assert(s.pop() == 30, "pop が正しくありません")
assert(s.pop() == 20, "pop が正しくありません")
assert(s.is_empty() == false, "まだ要素があるはずです")
assert(s.pop() == 10, "pop が正しくありません")
assert(s.is_empty() == true, "空のはずです")

print("スタック: OK")

print("\n===== 全ての問題をクリアしました！ =====")
