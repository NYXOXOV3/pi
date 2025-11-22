-- mainscript.lua
-- Delon Fish It - Full UI (legal demo)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPlayers()[1]
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Icon path (local path uploaded by user; will be transformed by tooling to a URL if needed)
local iconUrl = "file:///mnt/data/6F22C18F-2594-402F-9C6A-E2D8A0CB6DF3.jpeg"

-- Cleanup previous UI
if CoreGui:FindFirstChild("DelonFishItUI") then
    CoreGui.DelonFishItUI:Destroy()
end

-- Root ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DelonFishItUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Main container
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 540, 0, 360)
main.Position = UDim2.new(0.5, -270, 0.45, -180)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18,20,22)
main.BorderSizePixel = 0
main.Parent = screenGui
main.Active = true
main.Draggable = true

-- Border stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(45,48,52)
stroke.Thickness = 1
stroke.Parent = main

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Delon Fish It  •  v1.0"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(230,230,230)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local titleIcon = Instance.new("ImageLabel")
titleIcon.Name = "Icon"
titleIcon.Size = UDim2.new(0, 34, 0, 34)
titleIcon.Position = UDim2.new(1, -64, 0.5, -17)
titleIcon.BackgroundTransparency = 1
titleIcon.Image = iconUrl
titleIcon.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 28, 0, 22)
closeBtn.Position = UDim2.new(1, -32, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() pcall(function() screenGui:Destroy() end) end)

-- Left tab strip
local leftStrip = Instance.new("Frame")
leftStrip.Name = "LeftStrip"
leftStrip.Size = UDim2.new(0, 120, 1, -36)
leftStrip.Position = UDim2.new(0, 0, 0, 36)
leftStrip.BackgroundColor3 = Color3.fromRGB(22,24,26)
leftStrip.BorderSizePixel = 0
leftStrip.Parent = main

local leftLayout = Instance.new("UIListLayout")
leftLayout.Parent = leftStrip
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0,8)
leftLayout.VerticalAlignment = Enum.VerticalAlignment.Top
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Tabs
local TABS = {"Main","Shop","Teleport","Trade","Config","Misc"}
local tabButtons = {}

for i, name in ipairs(TABS) do
    local btn = Instance.new("TextButton")
    btn.Name = name.."Tab"
    btn.Size = UDim2.new(1, -16, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(30,34,38)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Parent = leftStrip
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = btn
    table.insert(tabButtons, btn)
end

-- Content area
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 120, 0, 36)
content.Size = UDim2.new(1, -120, 1, -36)
content.BackgroundColor3 = Color3.fromRGB(28,30,32)
content.BorderSizePixel = 0
content.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -24, 1, -24)
scroll.Position = UDim2.new(0, 12, 0, 12)
scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scroll.ScrollBarThickness = 8
scroll.Parent = content

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scroll
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,10)

-- Create category row function
local function createCategoryButton(parent, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(34,36,38)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, -8, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local arrow = Instance.new("TextButton")
    arrow.Size = UDim2.new(0, 36, 0, 28)
    arrow.Position = UDim2.new(1, -48, 0.5, -14)
    arrow.BackgroundColor3 = Color3.fromRGB(24,26,28)
    arrow.BorderSizePixel = 0
    arrow.Text = "▾"
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 18
    arrow.TextColor3 = Color3.fromRGB(200,200,200)
    arrow.Parent = frame

    return frame, arrow
end

-- Populate default category list (matches screenshot)
local function openCategoryList()
    scroll:ClearAllChildren()
    listLayout.Parent = scroll
    local items = {"Rod","Bait","Weather Machine","Enchant","Merchant","Skin"}
    for i,txt in ipairs(items) do
        local row, arrow = createCategoryButton(scroll, txt)
        row.LayoutOrder = i
        -- simple expand example
        local expanded = false
        local subFrame
        arrow.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                subFrame = Instance.new("Frame")
                subFrame.Size = UDim2.new(1, -12, 0, 64)
                subFrame.BackgroundColor3 = Color3.fromRGB(30,32,34)
                subFrame.BorderSizePixel = 0
                subFrame.Parent = scroll
                subFrame.LayoutOrder = i + 0.1

                local st = Instance.new("TextLabel")
                st.Size = UDim2.new(1, -24, 0, 20)
                st.Position = UDim2.new(0, 12, 0, 8)
                st.BackgroundTransparency = 1
                st.Text = "Option A | Option B | Option C"
                st.TextSize = 13
                st.Font = Enum.Font.Gotham
                st.TextColor3 = Color3.fromRGB(200,200,200)
                st.Parent = subFrame
            else
                if subFrame then subFrame:Destroy(); subFrame = nil end
            end
            scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 40)
        end)
    end
    scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 40)
end

-- Tab setups
local function setupMain()
    openCategoryList()
end

local function setupShop()
    scroll:ClearAllChildren()
    listLayout.Parent = scroll
    for i=1,6 do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, -12, 0, 36)
        item.Position = UDim2.new(0, 6, 0, 6 + (i-1)*44)
        item.BackgroundColor3 = Color3.fromRGB(36,38,40)
        item.Text = "Item "..i.." — Buy (demo)"
        item.Font = Enum.Font.Gotham
        item.TextColor3 = Color3.fromRGB(220,220,220)
        item.Parent = scroll
        item.LayoutOrder = i
        item.MouseButton1Click:Connect(function()
            StarterGui:SetCore("SendNotification", {Title="Shop", Text="Membeli Item "..i.." (demo)", Duration=2})
        end)
    end
    scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 40)
end

local function setupTeleport()
    scroll:ClearAllChildren()
    listLayout.Parent = scroll
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0, 220, 0, 36)
    tpBtn.Position = UDim2.new(0, 6, 0, 6)
    tpBtn.BackgroundColor3 = Color3.fromRGB(48,50,54)
    tpBtn.Text = "Teleport ke Spawn"
    tpBtn.Font = Enum.Font.Gotham
    tpBtn.TextColor3 = Color3.fromRGB(230,230,230)
    tpBtn.Parent = scroll
    tpBtn.LayoutOrder = 1
    tpBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char.PrimaryPart then
            char:SetPrimaryPartCFrame(CFrame.new(0,5,0))
            StarterGui:SetCore("SendNotification", {Title="Teleport", Text="Teleport ke spawn (demo).", Duration=2})
        end
    end)
    scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 40)
end

local function setupTrade()
    scroll:ClearAllChildren()
    listLayout.Parent = scroll
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 40)
    lbl.Position = UDim2.new(0, 6, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Trade features will appear here (demo only)."
    lbl.Font = Enum.Font.Gotham
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.TextSize = 14
    lbl.Parent = scroll
    lbl.LayoutOrder = 1
    scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 40)
end

local function setupConfig()
    scroll:ClearAllChildren()
    listLayout.Parent = scroll

    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0, 200, 0, 36)
    saveBtn.Position = UDim2.new(0, 6, 0, 6)
    saveBtn.BackgroundColor3 = Color3.fromRGB(58,60,62)
    saveBtn.Text = "Save Config"
    saveBtn.Font = Enum.Font.Gotham
    saveBtn.TextColor3 = Color3.fromRGB(230,230,230)
    saveBtn.Parent = scroll
    saveBtn.LayoutOrder = 1

    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0, 200, 0, 36)
    loadBtn.Position = UDim2.new(0, 212, 0, 6)
    loadBtn.BackgroundColor3 = Color3.fromRGB(58,60,62)
    loadBtn.Text = "Load Config"
    loadBtn.Font = Enum.Font.Gotham
    loadBtn.TextColor3 = Color3.fromRGB(230,230,230)
    loadBtn.Parent = scroll
    loadBtn.LayoutOrder = 2

    local config = { autoExample = false, sliderValue = 50 }

    local function saveConfig()
        local json = HttpService:JSONEncode(config)
        pcall(function()
            LocalPlayer:SetAttribute("DelonFishIt_Config", json)
            StarterGui:SetCore("SendNotification", {Title="Config", Text="Config disimpan (local).", Duration=2})
        end)
    end
    local function loadConfig()
        local ok, val = pcall(function() return LocalPlayer:GetAttribute("DelonFishIt_Config") end)
        if ok and val then
            local succ, tbl = pcall(function() return HttpService:JSONDecode(val) end)
            if succ and type(tbl) == "table" then
                config = tbl
                StarterGui:SetCore("SendNotification", {Title="Config", Text="Config dimuat (local).", Duration=2})
            else
                StarterGui:SetCore("SendNotification", {Title="Config", Text="Gagal decode config.", Duration=2})
            end
        else
            StarterGui:SetCore("SendNotification", {Title="Config", Text="Tidak ada config disimpan.", Duration=2})
        end
    end

    saveBtn.MouseButton1Click:Connect(saveConfig)
    loadBtn.MouseButton1Click:Connect(loadConfig)

    scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 40)
end

local function setupMisc()
    scroll:ClearAllChildren()
    listLayout.Parent = scroll
    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(1, -12, 0, 24)
    ver.Position = UDim2.new(0, 6, 0, 6)
    ver.BackgroundTransparency = 1
    ver.Text = "Delon Fish It • Demo UI • v1.0"
    ver.Font = Enum.Font.Gotham
    ver.TextSize = 14
    ver.TextColor3 = Color3.fromRGB(190,190,190)
    ver.Parent = scroll
    ver.LayoutOrder = 1
    scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 40)
end

-- Connect tabs
for _, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _,b in ipairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(30,34,38) end
        btn.BackgroundColor3 = Color3.fromRGB(60,62,66)
        if btn.Text == "Main" then setupMain()
        elseif btn.Text == "Shop" then setupShop()
        elseif btn.Text == "Teleport" then setupTeleport()
        elseif btn.Text == "Trade" then setupTrade()
        elseif btn.Text == "Config" then setupConfig()
        elseif btn.Text == "Misc" then setupMisc() end
    end)
end

-- default open
tabButtons[1].BackgroundColor3 = Color3.fromRGB(60,62,66)
setupMain()

-- Toggle visibility with RightControl
local visible = true
pcall(function()
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            visible = not visible
            main.Visible = visible
        end
    end)
end)

print("[Delon Fish It] GUI siap.")
