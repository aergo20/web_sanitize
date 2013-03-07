local insert, concat = table.insert, table.concat
local whitelist, add_attributes
do
  local _table_0 = require("web_sanitize.whitelist")
  whitelist, add_attributes = _table_0.whitelist, _table_0.add_attributes
end
local lpeg = require("lpeg")
local tag_stack = { }
local check_tag
check_tag = function(str, pos, tag)
  local lower_tag = tag:lower()
  local allowed = whitelist[lower_tag]
  if not (allowed) then
    return false
  end
  insert(tag_stack, lower_tag)
  return true, tag
end
local check_close_tag
check_close_tag = function(str, pos, punct, tag, rest)
  local lower_tag = tag:lower()
  local top = #tag_stack
  pos = top
  while pos >= 1 do
    if tag_stack[pos] == lower_tag then
      break
    end
    pos = pos - 1
  end
  if pos == 0 then
    return false
  end
  local buffer = { }
  local k = 1
  for i = top, pos + 1, -1 do
    buffer[k] = "</"
    buffer[k + 1] = tag_stack[i]
    buffer[k + 2] = ">"
    k = k + 3
    tag_stack[i] = nil
  end
  tag_stack[pos] = nil
  buffer[k] = punct
  buffer[k + 1] = tag
  buffer[k + 2] = rest
  return true, unpack(buffer)
end
local pop_tag
pop_tag = function(str, pos, ...)
  tag_stack[#tag_stack] = nil
  return true, ...
end
local fail_tag
fail_tag = function()
  tag_stack[#tag_stack] = nil
  return false
end
local check_attribute
check_attribute = function(str, pos_end, pos_start, name, value)
  local tag = tag_stack[#tag_stack]
  local allowed_attributes = whitelist[tag]
  if type(allowed_attributes) ~= "table" then
    return true
  end
  local attr = allowed_attributes[name:lower()]
  if type(attr) == "function" then
    if not (attr(value)) then
      return true
    end
  else
    if not (attr) then
      return true
    end
  end
  return true, str:sub(pos_start, pos_end - 1)
end
local inject_attributes
inject_attributes = function()
  local top_tag = tag_stack[#tag_stack]
  local inject = add_attributes[top_tag]
  if inject then
    local buff = { }
    local i = 1
    for k, v in pairs(inject) do
      buff[i] = " "
      buff[i + 1] = k
      buff[i + 2] = '="'
      buff[i + 3] = v
      buff[i + 4] = '"'
      i = i + 5
    end
    return true, unpack(buff)
  else
    return true
  end
end
local R, S, V, P = lpeg.R, lpeg.S, lpeg.V, lpeg.P
local C, Cs, Ct, Cmt, Cg, Cb, Cc, Cp = lpeg.C, lpeg.Cs, lpeg.Ct, lpeg.Cmt, lpeg.Cg, lpeg.Cb, lpeg.Cc, lpeg.Cp
local escaped_char = S("<>'&\"") / {
  [">"] = "&gt;",
  ["<"] = "&lt;",
  ["&"] = "&amp;",
  ["'"] = "&#x27;",
  ["/"] = "&#x2F;",
  ['"'] = "&quot;"
}
local white = S(" \t\n") ^ 0
local text = C((1 - escaped_char) ^ 1)
local word = (R("az", "AZ", "09") + S("._-")) ^ 1
local value = C(word) + P('"') * C((1 - P('"')) ^ 0) * P('"') + P("'") * C((1 - P("'")) ^ 0) * P("'")
local attribute = C(word) * white * P("=") * white * value
local open_tag = C(P("<") * white) * Cmt(word, check_tag) * (Cmt(Cp() * white * attribute, check_attribute) ^ 0 * white * Cmt("", inject_attributes) * Cmt("/" * white, pop_tag) ^ -1 * C(">") + Cmt("", fail_tag))
local close_tag = Cmt(C(P("<") * white * P("/") * white) * C(word) * C(white * P(">")), check_close_tag)
local html = Ct((open_tag + close_tag + escaped_char + text) ^ 0 * -1)
local sanitize_html
sanitize_html = function(str)
  tag_stack = { }
  local buffer = html:match(str)
  local k = #buffer + 1
  for i = #tag_stack, 1, -1 do
    buffer[k] = "</"
    buffer[k + 1] = tag_stack[i]
    buffer[k + 2] = ">"
    k = k + 3
  end
  return concat(buffer)
end
return {
  sanitize_html = sanitize_html
}