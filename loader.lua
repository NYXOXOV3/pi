-- loader.lua
return (function()
    local function getKey()
        if type(_G) == "table" and _G.script_key then return _G.script_key end
        if _G and _G["script_key"] then return _G["script_key"] end
        if script_key then return script_key end
        return nil
    end

    local provided = getKey()
    local VALID_KEY = "xaPyymysYNBYPgjACOCxwNpDCSDPtovs" -- ubah jika perlu

    if not provided then
        warn("[Loader] Tidak ada key. Set _G.script_key = \"...\" sebelum menjalankan.")
        return
    end

    if provided ~= VALID_KEY then
        warn("[Loader] Key tidak valid.")
        return
    end

    print("[Loader] Key valid. Memuat mainscript...")

    local mainscript_url = "https://raw.githubusercontent.com/NYXOXOV3/pi/main/mainscript.lua" -- GANTI

    local ok, src = pcall(function() return game:HttpGet(mainscript_url) end)
    if not ok or not src then
        warn("[Loader] Gagal mengambil mainscript:", src)
        return
    end

    local fn, err = loadstring(src)
    if not fn then
        warn("[Loader] Loadstring mainscript error:", err)
        return
    end

    local success, e = pcall(fn)
    if not success then
        warn("[Loader] Error saat menjalankan mainscript:", e)
        return
    end

    print("[Loader] Mainscript selesai dijalankan.")
end)()
