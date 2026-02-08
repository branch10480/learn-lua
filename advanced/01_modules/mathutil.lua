-- mathutil.lua: 演習で使うサンプルモジュール
local M = {}

function M.add(a, b)
  return a + b
end

function M.sub(a, b)
  return a - b
end

function M.mul(a, b)
  return a * b
end

function M.div(a, b)
  if b == 0 then
    error("division by zero")
  end
  return a / b
end

return M
