-- Красивое меню в стиле Wings / Blade Ball
-- Открытие: Правый Ctrl

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Создание основного GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WingsMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Главный фрейм (окно меню)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Тень (эффект глубины)
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ВЗНОСЫ МЕНЮ"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Акцентная полоска
local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(0, 100, 0, 3)
Accent.Position = UDim2.new(0, 15, 1, -3)
Accent.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Accent.BorderSizePixel = 0
Accent.Parent = TitleBar

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Панель вкладок (слева)
local TabPanel = Instance.new("Frame")
TabPanel.Size = UDim2.new(0, 150, 1, -50)
TabPanel.Position = UDim2.new(0, 0, 0, 50)
TabPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TabPanel.BorderSizePixel = 0
TabPanel.Parent = MainFrame

-- Контейнер для кнопок вкладок
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(1, 0, 0, 200)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = TabPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = TabButtons

-- Контентная область (справа)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -160, 1, -60)
ContentFrame.Position = UDim2.new(0, 155, 0, 55)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Скроллинг для контента
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -20)
ScrollFrame.Position = UDim2.new(0, 10, 0, 10)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = ContentFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 10)
ContentList.Parent = ScrollFrame

-- Хранение страниц
local pages = {}
local currentPage = nil

-- Функция создания вкладки
local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = TabButtons
    
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ScrollFrame
    
    pages[btn] = page
    
    btn.MouseButton1Click:Connect(function()
        for otherBtn, otherPage in pairs(pages) do
            otherPage.Visible = false
            otherBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            otherBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return page
end

-- Функция создания кнопки
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Функция создания слайдера
local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -40, 0, 4)
    slider.Position = UDim2.new(0, 20, 0, 40)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    callback(default)
    
    -- Упрощенный слайдер (без джойстика)
    return frame
end

-- Функция создания чекбокса
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0, 7)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 60)
    toggle.Text = default and "✓" or ""
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 16
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    local toggled = default
    callback(toggled)
    
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggle.BackgroundColor3 = toggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 60)
        toggle.Text = toggled and "✓" or ""
        callback(toggled)
    end)
    
    return frame
end

-- ============ СОЗДАНИЕ ВКЛАДОК И ФУНКЦИЙ ============

-- Вкладка GENERAL
local generalPage = CreateTab("⚔️ GENERAL")
CreateButton(generalPage, "🩸 Полное здоровье", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)
CreateButton(generalPage, "💪 Бесконечная энергия", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:SetAttribute("Energy", 999999)
    end
end)
CreateButton(generalPage, "🚀 Скорость x2", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 32
    end
end)
CreateToggle(generalPage, "Авто-атака", false, function(state)
    print("Авто-атака:", state)
end)
CreateSlider(generalPage, "Скорость", 16, 50, 16, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

-- Вкладка SETTINGS
local settingsPage = CreateTab("⚙️ SETTINGS")
CreateToggle(settingsPage, "Водяной знак", true, function(state)
    print("Водяной знак:", state)
end)
CreateToggle(settingsPage, "Отображать клавиши", true, function(state)
    print("Отображение клавиш:", state)
end)

-- Вкладка WORLD
local worldPage = CreateTab("🌍 WORLD")
CreateButton(worldPage, "🌞 День", function()
    game.Lighting.ClockTime = 14
end)
CreateButton(worldPage, "🌙 Ночь", function()
    game.Lighting.ClockTime = 0
end)
CreateButton(worldPage, "🎨 Яркий мир", function()
    game.Lighting.Brightness = 2
    game.Lighting.ExposureCompensation = 1
end)

-- ============ ОТКРЫТИЕ ПО ПРАВОМУ CTRL ============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
        -- Анимация появления
        if MainFrame.Visible then
            MainFrame.BackgroundTransparency = 0
        end
    end
end)

-- Активируем первую вкладку
for btn, page in pairs(pages) do
    if not currentPage then
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentPage = page
    end
end

print("✅ Меню загружено! Нажми ПРАВЫЙ CTRL")
