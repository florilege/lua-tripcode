#!/usr/bin/luajit
local crypto = require("luacrypt")
local iconv = require("iconv")

local cd = iconv.new("CP932//TRANSLIT", "UTF-8")
local salt = "................................" ..
             ".............../0123456789ABCDEF" ..
             "GABCDEFGHIJKLMNOPQRSTUVWXYZabcde" ..
             "fabcdefghijklmnopqrstuvwxyz....." ..
             "................................" ..
             "................................" ..
             "................................" ..
             "................................"
local replace = {
    ["&"]  = "&amp;",
    ["\""] = "&quot;",
    ["<"]  = "&lt;",
    [">"]  = "&gt;"
}

function tripcode(pwd)
    pwd = cd:iconv(pwd)
    local out = ""
    local i = 1
    repeat
        local c = pwd:sub(i, i)
        local r = replace[c]
        if r then out = out .. r else out = out .. c end
        i = i + 1
    until out:len() > 8 or i > pwd:len()
    out = out:sub(1, 8)
    local s = out:sub(2, 3)
    if s:len() < 2 then s = s .. "H." end
    local a = s:byte(1) + 1 
    local b = s:byte(2) + 1
    local t = salt:sub(a, a) .. salt:sub(b, b)
    local trip = crypt(out, t)
    return trip:sub(4)
end

for _, pwd in ipairs(arg) do
    print(tripcode(pwd))
end
