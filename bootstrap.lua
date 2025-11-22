-- bootstrap.lua (jalankan di executor)
_G.script_key = "xaPyymysYNBYPgjACOCxwNpDCSDPtovs"

local loader_url = "https://raw.githubusercontent.com/NYXOXOV3/pi/main/loader.lua" -- GANTI
local ok, src = pcall(function() return game:HttpGet(loader_url) end)
if not ok then
    warn("Gagal ambil loader:", src)
    return
end
local fn, err = loadstring(src)
if not fn then
    warn("Loadstring loader error:", err)
    return
end
fn()
