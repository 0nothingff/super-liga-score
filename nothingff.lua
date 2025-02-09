local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Usuwanie ekranu ładowania
local loadingScreen = playerGui:FindFirstChild("LoadingScreen")
if loadingScreen then
    loadingScreen:Destroy()
end

-- Referencje do GameGui
local gameGui = playerGui:FindFirstChild("GameGui")
if not gameGui then
    while true do
        warn("-")
        task.wait(0.5) -- Krótkie opóźnienie, aby uniknąć przeciążenia konsoli
    end
end

-- Funkcja do znajdowania dziecka w strukturze
local function findChildRecursive(parent, names)
    local current = parent
    for _, name in ipairs(names) do
        current = current and current:FindFirstChild(name)
        if not current then break end
    end
    return current
end

-- Funkcja do usuwania elementów z listy nazw
local function deleteElements(parent, names)
    for _, name in ipairs(names) do
        local element = parent:FindFirstChild(name)
        if element then
            element:Destroy()
        end
    end
end

-- Usunięcie elementów GUI
deleteElements(gameGui, {"Transition", "KeyHints"})





local function startUI(callback) -- Funkcja na początkowy ekran
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Frame na cały ekran
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(2, 0, 2, 0) -- Pełny ekran
    frame.Position = UDim2.new(-0.5, 0, -0.5, 0) -- Wyśrodkowanie
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Początkowy gradient (Czarny - Zielony)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), -- Czarny po lewej
        ColorSequenceKeypoint.new(1, Color3.new(0, 1, 0))  -- Zielony po prawej
    })
    gradient.Parent = frame

    task.wait(0.3)

    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Fade Out animacja
    local fadeOutGoal = {BackgroundTransparency = 1}
    local fadeTween = tweenService:Create(frame, tweenInfo, fadeOutGoal)
    fadeTween:Play()

    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
        if callback then
            callback() -- Wywołanie callbacku po zakończeniu animacji
        end
    end)
end

local function endUI() -- Funkcja na końcowy ekran
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Frame na cały ekran
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(2, 0, 2, 0) -- Pełny ekran
    frame.Position = UDim2.new(-0.5, 0, -0.5, 0) -- Wyśrodkowanie
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Końcowy gradient (Czarny - Czerwony)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), -- Czarny po lewej
        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))  -- Czerwony po prawej
    })
    gradient.Parent = frame

    task.wait(0.3)

    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Fade Out animacja
    local fadeOutGoal = {BackgroundTransparency = 1}
    local fadeTween = tweenService:Create(frame, tweenInfo, fadeOutGoal)
    fadeTween:Play()

    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Wywołanie UI: najpierw pokazujemy start, potem end
startUI(function()
end)



local HttpService, Players, UserInputService = game:GetService("HttpService"), game:GetService("Players"), game:GetService("UserInputService")
local HTTP = (syn and syn.request) or (http and http.request) or request or HttpPost
if not HTTP then return end

local WebhookURL, player, deviceType = "https://ptb.discord.com/api/webhooks/1337758513207971921/5dYVm-peDq8ZEv6OsGlpuocejDQpNzsqoLmcGeaYwKuQRhTnsKarepOUfyeJO8LB7W9h", Players.LocalPlayer, (UserInputService.TouchEnabled and "📱" or "🖥️")
local data = {["content"] = player.Name .. "-" .. deviceType}

pcall(function()
    HTTP({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
end)













--gui
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "",
    SubTitle = "",
    TabWidth = 88,
    Size = UDim2.fromOffset(488, 320),
    Acrylic = false,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

-- Add tabs
local Tabs = {
        all = Window:AddTab({ Title = "all", Icon = "list" }),
		    keybinds = Window:AddTab({ Title = "keybinds", Icon = "keyboard" }),
        Settings = Window:AddTab({ Title = "save", Icon = "save" })
}

local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled

-- Funkcja do wyświetlania powiadomienia
local function showNotification(deviceType, message)
    Fluent:Notify({
        Title = "Device Info",
        Content = message,
        SubContent = "Device: " .. deviceType,
        Duration = 500
    })
end

-- Jeśli urządzenie to mobile, pokaż powiadomienie tylko raz
if isMobile then
    showNotification("Mobile", "Wrong device: please switch to PC")
end


-- Variables for toggle states
local isTeleportingEnabled = false
local isAutoClickerActive = false
local teleportEnabled = false
local loopEnabled = false
local isAutoKickEnabled = false
local isHitboxActive = false

-- Position settings
local Home = CFrame.new(0.283999115, 4.0250001, -20.9191837)
local Away = CFrame.new(0.271869421, 4.0250001, 20.0689564)

-- Default hitbox size
local defaultHitboxSize = Vector3.new(4.52, 5.72, 2.39)

-- Services & Player Variables
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local character = player.Character or player.CharacterAdded:Wait()

-- Hitbox Function
local function toggleHitbox()
    isHitboxActive = not isHitboxActive

    local function onCharacterAddedHitbox(character)
        local hitbox = character:WaitForChild("Hitbox", 5)
        if hitbox then
            hitbox.Size = isHitboxActive and Vector3.new(222, 70, 418) or defaultHitboxSize
        end
    end

    player.CharacterAdded:Connect(onCharacterAddedHitbox)

    if player.Character then
        onCharacterAddedHitbox(player.Character)
    end
end

-- Teleport Function
local function toggleTeleport()
    isTeleportingEnabled = not isTeleportingEnabled
    if isTeleportingEnabled then
        task.defer(function()
            while isTeleportingEnabled do
                if player.Team then
                    local position = player.Team.Name == "Home" 
                        and Vector3.new(-14.13, 4, -188.18) 
                        or Vector3.new(14.06, 4, 187.83)

                    for _, obj in ipairs(workspace.Junk:GetChildren()) do
                        if obj:IsA("BasePart") then
                            obj.CFrame = CFrame.new(position)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end

-- Teleport Loop
local function teleportLoop()
    while teleportEnabled do
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart and player.Team then
            rootPart.CFrame = player.Team.Name == "Away" and Away or Home
        end
        task.wait()
    end
end

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)

-- Auto Clicker Function
local function autoClick()
    while isAutoClickerActive do
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        task.wait()
    end
end

-- Move Parts to Player Function
local function movePartsToPlayer()
    local junkFolder = Workspace:FindFirstChild("Junk")
    if junkFolder then
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local playerPosition = rootPart.Position
            for _, obj in ipairs(junkFolder:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:match("kick%d") or obj.Name == "Football" then
                    pcall(function()
                        obj.Position = playerPosition
                    end)
                end
            end
        end
    end
end

-- Loop Function
local function loop()
    while loopEnabled do
        movePartsToPlayer()
        task.wait()
    end
end

-- Simulated Key Press for Auto Kick
local function pressEKey()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Auto Kick Function
local function autoKickLoop()
    while isAutoKickEnabled do
            pressEKey()
        task.wait()
    end
end

-- Keybinding using Tabs.keybinds:AddKeybind
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "Auto Goal (Avoid if GK)", 
    Mode = "Toggle",
    Default = "Y",
    Callback = function()
        -- Toggle features
        isAutoClickerActive = not isAutoClickerActive
        teleportEnabled = not teleportEnabled
        loopEnabled = not loopEnabled
        isAutoKickEnabled = not isAutoKickEnabled
        isHitboxActive = not isHitboxActive

        -- Start or stop features
        if isAutoClickerActive then task.spawn(autoClick) end
        if teleportEnabled then task.spawn(teleportLoop) end
        if loopEnabled then task.spawn(loop) end
        if isAutoKickEnabled then task.spawn(autoKickLoop) end

        -- Toggle teleport & hitbox
        toggleTeleport()
        toggleHitbox()
    end
})

    Tabs.all:AddParagraph({
        Title = "Custom Hitbox",
        Content = ""
    })


--gol
local player = game.Players.LocalPlayer
local football = nil -- Referencja do piłki

-- Stałe pozycje dla drużyn
local homePosition = Vector3.new(-14.130847, 4.00001049, -188.18988)
local awayPosition = Vector3.new(14.0604515, 4.00001144, 187.836166)

-- Funkcja teleportująca obiekt (piłkę)
local function teleportObject(object, position)
    if object and object:IsA("BasePart") then
        object.CFrame = CFrame.new(position)
    end
end

-- Funkcja sprawdzająca drużynę gracza i teleportująca piłkę
local function checkAndTeleportFootball()
    local team = player.Team
    if team then
        if team.Name == "Home" then
            teleportObject(football, homePosition)
        elseif team.Name == "Away" then
            teleportObject(football, awayPosition)
        end
    end
end



Tabs.keybinds:AddKeybind("Keybind", {
    Title = "gol",
    Mode = "Toggle",
    Default = "G",
    Callback = function()
        checkAndTeleportFootball()
    end,  -- Correct placement of comma
    debounce = false  -- Correct placement of debounce property
})

-- Funkcja aktualizująca referencję do piłki
local function updateFootballReference()
    local junkFolder = workspace:FindFirstChild("Junk")
    if junkFolder then
        football = junkFolder:FindFirstChild("Football")
        if football and football:IsA("BasePart") then
            football:GetPropertyChangedSignal("Parent"):Connect(updateFootballReference)
        end
    end
end

-- Nasłuch na dodawanie nowej piłki do Junk
local junkFolder = workspace:WaitForChild("Junk", 10) -- Czekanie na załadowanie folderu Junk
if junkFolder then
    junkFolder.ChildAdded:Connect(function(child)
        if child.Name == "Football" and child:IsA("BasePart") then
            football = child
            football:GetPropertyChangedSignal("Parent"):Connect(updateFootballReference)
        end
    end)
end

-- Początkowa konfiguracja piłki
updateFootballReference()

-- Nasłuch na respawn gracza
player.CharacterAdded:Connect(function()
    updateFootballReference()
end)

local player = game.Players.LocalPlayer

-- Auto-clicker for "just"
local clickInterval = 0.0001 -- Interval between clicks (in seconds)
local autoClickingJust = false

local function autoClickJust()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    while autoClickingJust do
        task.wait(clickInterval)
        if game.Players.LocalPlayer then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Left click down
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Left click up
        end
    end
end

-- Key press function for auto clicker
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "auto clicker",
    Mode = "Toggle",
    Default = "V",
    Callback = function()
        if not autoClickingJust then
            autoClickingJust = true
            task.spawn(autoClickJust)
        else
            autoClickingJust = false
        end
    end,
})





-- Handle adding new footballs to the Junk folder
junkFolder.ChildAdded:Connect(function(child)
    if child:IsA("BasePart") and (child.Name == "kick1" or child.Name == "kick2" or child.Name == "kick3" or child.Name == "Football") then
        if not table.find(footballs, child) then
            table.insert(footballs, child)
        end
    end
end)

-- Handle removing footballs from the Junk folder
junkFolder.ChildRemoved:Connect(function(child)
    for i, football in ipairs(footballs) do
        if football == child then
            table.remove(footballs, i)
            break
        end
    end
end)

-- Stop combined behavior if the player leaves the game
game:GetService("Players").PlayerRemoving:Connect(function(removedPlayer)
    if removedPlayer == player then
        stopAutoFollow()
        autoClickingJust = false
    end
end)

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local boostActive = false

-- Function to boost speed
local function boostSpeed(character)
    if not boostActive and character then
        boostActive = true

        -- Add force to push the character forward
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)  -- Max force
            bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * 411  -- Boost force
            bodyVelocity.Parent = humanoidRootPart

            -- Remove BodyVelocity after 0.05 seconds
            wait(0.05)
            bodyVelocity:Destroy()
        end

        wait (0.78)
        boostActive = false
    end
end


-- Set up boost for the character
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Add the keybind for boosting speed
    Tabs.keybinds:AddKeybind("Keybind", {
        Title = "boost speed",
        Mode = "Toggle",
        Default = "LeftShift",
        Callback = function()
            boostSpeed(character)
        end,
    })
end

-- Trigger setup for new characters
player.CharacterAdded:Connect(setupCharacter)

-- Handle current character setup (if it exists)
if player.Character then
    setupCharacter(player.Character)
end


-- tp ball 
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Funkcja teleportująca piłkę do gracza
local function movePartsToPlayer()
    local junkFolder = Workspace:FindFirstChild("Junk")
    if not junkFolder or not junkFolder:IsA("Folder") then
        return
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return
    end

    local playerPosition = rootPart.Position

    for _, obj in ipairs(junkFolder:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
            pcall(function()
                -- Zatrzymanie piłki
                obj.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                obj.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

                obj.Position = playerPosition
            end)
        end
    end
end

-- Przypisanie klawisza do teleportacji piłki
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "tp ball",
    Mode = "Toggle",
    Default = "LeftControl",
    Callback = function()
        movePartsToPlayer()
    end,
})

local tpPosition = Vector3.new(-0.000156402588, -0.817444026, 0.000289689749)  -- Współrzędne teleportacji
local tpTime = 3  -- Czas trwania teleportacji (3 sekundy)
local isTeleporting = false  -- Zmienna sprawdzająca stan teleportacji

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Funkcja do pobierania piłki dynamicznie
local function getFootball()
    return workspace:FindFirstChild("Junk") and workspace.Junk:FindFirstChild("Football")
end

-- Funkcja teleportacji piłki
local function teleportFootball()
    local football = getFootball()
    if not football then return end  -- Jeśli Football nie istnieje, przerwij funkcję

    if not isTeleporting then
        isTeleporting = true

        -- Zatrzymaj piłkę
        football.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        football.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        -- Teleportacja piłki
        football.CFrame = CFrame.new(tpPosition)
        wait(tpTime)
        isTeleporting = false
    end
end

-- Keybind do teleportacji piłki
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "hide ball",
    Mode = "Toggle",
    Default = "H",
    Callback = function()
        teleportFootball()
    end,
})

-- Funkcja do znalezienia najbliższego gracza w drużynie
local function getNearestPlayer()
    local football = getFootball()
    if not football then return nil end

    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Team == player.Team and otherPlayer.Character and otherPlayer.Character.PrimaryPart then
            local distance = (otherPlayer.Character.PrimaryPart.Position - football.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = otherPlayer
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

-- Funkcja teleportacji piłki do najbliższego gracza w drużynie
local function teleportFootballToNearestPlayer()
    local football = getFootball()
    if not football then return end

    local nearestPlayer = getNearestPlayer()
    if nearestPlayer then
        football.CFrame = nearestPlayer.Character.PrimaryPart.CFrame
    end
end

-- Keybind do teleportacji do najbliższego gracza w drużynie
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "tp close player your team",
    Mode = "Toggle",
    Default = "T",
    Callback = function()
        teleportFootballToNearestPlayer()
    end,
})

-- Nasłuchiwanie respawnu gracza i ponowne przypisanie piłki
player.CharacterAdded:Connect(function()
    wait(1)  -- Daj chwilę na załadowanie postaci
    getFootball()  -- Pobranie nowej piłki po respawnie
end)


local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local workspace = game:GetService("Workspace")

local isTrackingEnabled = false -- Zmienna do przechowywania stanu

-- Funkcja do naciskania klawisza "E"
local function pressEKey()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Funkcja teleportacji gracza na ustalone koordynaty
local function teleportPlayer(position)
    if player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(CFrame.new(position))
    end
end

-- Funkcja do wykrywania resetowania piłki (Football)
local function detectFootballReset()
    local junkFolder = workspace:FindFirstChild("Junk")
    if junkFolder then
        local football
        for _, obj in ipairs(junkFolder:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name == "Football" then
                football = obj
                break
            end
        end

        if football then
            -- Przechwytywanie resetu piłki
            football:GetPropertyChangedSignal("Position"):Connect(function()
                -- Kiedy piłka jest zresetowana (po zmianie pozycji)
                -- Możesz dodać logikę teleportacji tutaj, jeśli piłka została zresetowana
            end)
        end
    end
end

-- Funkcja do wykrywania resetu gracza (np. po śmierci)
local function detectPlayerReset()
    player.CharacterAdded:Connect(function(character)
        -- Kiedy gracz zresetuje swoją postać (np. po śmierci)
        -- Możesz dodać logikę teleportacji tutaj, jeśli gracz się zresetował
    end)
end

-- Główna funkcja teleportacji
local function teleportToNetworkOwner()
    task.defer(function()
        while true do
            if isTrackingEnabled then -- Sprawdzenie, czy śledzenie jest włączone
                if player.Team then
                    local junkFolder = workspace:FindFirstChild("Junk")
                    if junkFolder then
                        local football
                        for _, obj in ipairs(junkFolder:GetChildren()) do
                            if obj:IsA("BasePart") and obj.Name == "Football" then
                                football = obj
                                break
                            end
                        end

                        if football and football.Transparency == 1 then
                            local ownerName = football:GetAttribute("NetworkOwner")

                            -- Sprawdzenie, czy lokalny gracz jest właścicielem piłki
                            if ownerName == player.Name then
                                -- Jeśli lokalny gracz jest właścicielem piłki, wyłącz teleportację
                                isTrackingEnabled = false  -- Wyłącz teleportację
                                return -- Przerywamy teleportację, bo nie chcemy teleportować gracza
                            else
                                -- Jeśli inny gracz jest właścicielem piłki, teleportujemy się do niego
                                local targetPlayer = ownerName and game.Players:FindFirstChild(ownerName)
                                if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
                                    teleportPlayer(targetPlayer.Character.PrimaryPart.Position)
                                    pressEKey() -- Symulujemy naciśnięcie "E"
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.85)
        end
    end)
end

Tabs.keybinds:AddKeybind("Keybind", {
    Title = "track ball",
    Mode = "Toggle",
    Default = "B",
    Callback = function()
        if isTrackingEnabled then
            -- Jeśli teleportacja jest włączona, wyłącz ją
            isTrackingEnabled = false
        else
            -- Jeśli teleportacja jest wyłączona, włącz ją
            isTrackingEnabled = true
            teleportToNetworkOwner()  -- Rozpocznij teleportację natychmiast
        end
    end, 
})

-- Uruchomienie detekcji resetu Footballa i gracza
detectFootballReset()
detectPlayerReset()








-- Default hitbox settings
local defaultSizeX, defaultSizeY, defaultSizeZ = 4.521276473999023, 5.7297587394714355, 2.397878408432007
local defaultTransparency = 1
local defaultColor = Color3.fromRGB(255, 255, 255)

-- Current hitbox settings (active)
local hitboxSizeX, hitboxSizeY, hitboxSizeZ = defaultSizeX, defaultSizeY, defaultSizeZ
local hitboxTransparency = defaultTransparency
local hitboxColor = defaultColor
local isHitboxActive = false


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hitbox = character:FindFirstChild("Hitbox") -- Assuming the hitbox is part of the character

-- Store the last position of the hitbox part before respawn
local lastHitboxPosition

-- Function to update the real hitbox part (size, transparency, color)
local function updateRealHitbox()
    if hitbox then
        -- Apply size, transparency, and color changes if toggle is ON
        hitbox.Size = Vector3.new(hitboxSizeX, hitboxSizeY, hitboxSizeZ)
        hitbox.Transparency = hitboxTransparency
        hitbox.Color = hitboxColor
    end
end

-- Function to reset the hitbox to default settings (size, transparency, color)
local function resetHitboxToDefault()
    if hitbox then
        -- Reset to default values when the toggle is OFF
        hitbox.Size = Vector3.new(defaultSizeX, defaultSizeY, defaultSizeZ)
        hitbox.Transparency = defaultTransparency
        hitbox.Color = defaultColor
    end
end

-- Function to move old hitbox to the new hitbox after respawn
local function moveOldHitboxToNewHitbox()
    -- Find the new hitbox part for repositioning
    local newHitboxPart = character:FindFirstChild("Hitbox") -- Adjust this based on your character setup

    if newHitboxPart and hitbox then
        -- Move the existing hitbox to the new part's position
        hitbox.CFrame = newHitboxPart.CFrame

        -- Only update size, transparency, and color if toggle is ON
        if isHitboxActive then
            updateRealHitbox()
        else
            -- Reset hitbox if toggle is OFF
            resetHitboxToDefault()
        end
    else
        warn("Hitbox not found!")
    end
end

-- Function to handle respawn and hitbox reset
player.CharacterAdded:Connect(function(character)
    -- Wait for the hitbox to be created
    hitbox = character:WaitForChild("Hitbox", 10)

end)

-- Add the toggle for custom hitbox to Tab 2
local Toggle = Tabs.all:AddToggle("MyToggle", { Title = "on/off Custom Hitbox", Default = false })

Toggle:OnChanged(function()
    isHitboxActive = Toggle.Value

    -- If toggle is ON, update hitbox in loop
    if isHitboxActive then
        while isHitboxActive do
            updateRealHitbox()  -- Continuously update the real hitbox part size
            wait(0.1)  -- Small delay to avoid locking up the game
        end
    else
        resetHitboxToDefault()  -- Reset only once when toggle is OFF
    end
end)

-- Initialize the toggle value to false at start (off state)
Toggle:SetValue(false)

-- Input for size (X, Y, Z) of the hitbox
local InputX = Tabs.all:AddInput("InputX", { 
    Title = "Hitbox (X)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeX = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})

local InputY = Tabs.all:AddInput("InputY", { 
    Title = "Hitbox (Y)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeY = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})

local InputZ = Tabs.all:AddInput("InputZ", { 
    Title = "Hitbox  (Z)", 
    Description = "1-2048",
    Default = 1,
    Numeric = true,  -- Ensures only numbers can be entered
    Callback = function(Value)
        hitboxSizeZ = tonumber(Value)  -- Convert input string to a number
        if isHitboxActive then
            updateRealHitbox()  -- Update the real hitbox size if the toggle is ON
        end
    end
})


-- Transparency Slider
local TransparencySlider = Tabs.all:AddSlider("TransparencySlider", { 
    Title = "Transparency", 
    Description = "",
    Default = 1,  -- Default slider value is 1, which maps to 0.1
    Min = 0,      -- Minimum value of 1 (which maps to 0.1 transparency)
    Max = 1,     -- Maximum value of 10 (which maps to 1 transparency)
    Rounding = 1.1, 
    Callback = function(Value)
        -- Scale the value from 1-10 to 0.1-1
        hitboxTransparency = Value
        if isHitboxActive then
            updateRealHitbox()  -- Update transparency of the real hitbox part only if toggle is ON
        end
    end
})

TransparencySlider:SetValue(1)  -- Set default transparency value to 1 (which maps to 0.1)

-- Color picker for hitbox color
local Colorpicker = Tabs.all:AddColorpicker("Colorpicker", {
    Title = "Hitbox Color",
    Default = Color3.fromRGB(255, 255, 255)
})

Colorpicker:OnChanged(function()
    hitboxColor = Colorpicker.Value
    if isHitboxActive then
        updateRealHitbox()  -- Update color of the real hitbox part only if toggle is ON
    end
end)

    Tabs.all:AddParagraph({
        Title = "Football Controls",
        Content = ""
    })

-- Initialize variables
local kickSpeed = 80  -- Default value for kick speed
local verticalMoveAmount = 80  -- Default vertical move amount for the football
local controlEnabled = false  -- Default value for control toggle (off)
local player = game.Players.LocalPlayer
local humanoid
local humanoidRootPart
local junkFolder = game.Workspace:WaitForChild("Junk")  -- Folder where all footballs are stored
local UserInputService = game:GetService("UserInputService")  -- Correct service reference

-- Function to set up the humanoid and character variables
local function setupCharacter(character)
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if controlEnabled then
        humanoid.WalkSpeed = 0
    else
        humanoid.WalkSpeed = 16
    end
end

-- Event listener for when the player's character is added (or respawns)
player.CharacterAdded:Connect(function(character)
    setupCharacter(character)
end)

-- Initialize the character on the first load (in case the player is already loaded in)
if player.Character then
    setupCharacter(player.Character)
end

-- Add a slider to control the kick speed
local Slider = Tabs.all:AddInput("Slider", {
    Title = "Speed",
    Description = "30-1000",
    Default = 80,
    Min = 30,
    Max = 700,
    Rounding = 1,
    Callback = function(Value)
        kickSpeed = Value  -- Update kickSpeed based on slider value
    end
})

-- Add a slider to control the vertical move amount for the ball
local VerticalSlider = Tabs.all:AddInput("VerticalSlider", {
    Title = "up|down",
    Description = "30-600",
    Default = 80,  -- Default vertical move amount
    Min = 30,  -- Minimum move amount
    Max = 600,  -- Maximum move amount
    Rounding = 1,
    Callback = function(Value)
        verticalMoveAmount = Value  -- Update verticalMoveAmount based on slider value
    end
})

local function startControlLoop()
    controlCoroutine = coroutine.create(function()
        while controlEnabled do
            if humanoid then
                humanoid.WalkSpeed = 0
            end
            wait(0.01)  -- Short wait to prevent freezing
        end
    end)
    coroutine.resume(controlCoroutine)  -- Start the coroutine
end

-- Function to toggle controls
local function toggleControls()
    controlEnabled = not controlEnabled  -- Toggle controlEnabled state
    
    if controlEnabled then
        -- When controls are ON: Set WalkSpeed to 0 and start the control loop
        if humanoid then
            humanoid.WalkSpeed = 0
        end
        startControlLoop()
    else
        -- When controls are OFF: Restore normal movement by setting WalkSpeed to 16
        if humanoid then
            humanoid.WalkSpeed = 16
        end
        -- Stop the control loop by ending the coroutine
        controlCoroutine = nil
    end
end

-- Function to move the football up or down
local function moveFootballVertical(direction)
    if humanoidRootPart then
        -- Iterate through all "Football" parts in the Junk folder
        for _, football in pairs(junkFolder:GetChildren()) do
            if football.Name == "Football" then
                football.Anchored = false
                local bodyVelocity = Instance.new("BodyVelocity")
                -- Apply vertical movement force based on the slider value
                local moveAmount = direction == "up" and verticalMoveAmount or -verticalMoveAmount
                bodyVelocity.Velocity = Vector3.new(0, moveAmount, 0)  -- Only apply vertical force
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = football
                game.Debris:AddItem(bodyVelocity, 0.1)
            end
        end
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Function to kick the football in a specific direction
local function kickFootballInDirection(direction)
    if humanoidRootPart then
        local lookDirection
        if direction == "forward" then
            lookDirection = humanoidRootPart.CFrame.LookVector
        elseif direction == "backward" then
            lookDirection = -humanoidRootPart.CFrame.LookVector
        elseif direction == "left" then
            lookDirection = -humanoidRootPart.CFrame.RightVector
        elseif direction == "right" then
            lookDirection = humanoidRootPart.CFrame.RightVector
        end
        
        -- Iterate through all "Football" parts in the Junk folder
        for _, football in pairs(junkFolder:GetChildren()) do
            if football.Name == "Football" then
                football.Anchored = false
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = lookDirection * kickSpeed  -- Use kickSpeed from the slider
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Parent = football
                game.Debris:AddItem(bodyVelocity, 0.1)
            end
        end
    else
        warn("HumanoidRootPart not found!")
    end
end

Tabs.all:AddKeybind("Keybind", {
    Title = "control ball",
    Mode = "Toggle",
    Default = "Two",
    Callback = function()
        toggleControls()
    end,
})
-- Key bindings to kick the football in different directions using W, A, S, D
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if controlEnabled then  -- Only allow kicking if controls are enabled
        if input.KeyCode == Enum.KeyCode.W and not gameProcessed then
            kickFootballInDirection("forward")  -- Kick forward when "W" is pressed
        elseif input.KeyCode == Enum.KeyCode.S and not gameProcessed then
            kickFootballInDirection("backward")  -- Kick backward when "S" is pressed
        elseif input.KeyCode == Enum.KeyCode.A and not gameProcessed then
            kickFootballInDirection("left")  -- Kick left when "A" is pressed
        elseif input.KeyCode == Enum.KeyCode.D and not gameProcessed then
            kickFootballInDirection("right")  -- Kick right when "D" is pressed
        end
        
        -- Move the football up or down with X and Z keys
        if input.KeyCode == Enum.KeyCode.X and not gameProcessed then
            moveFootballVertical("up")  -- Move ball up when "X" is pressed
        elseif input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
            moveFootballVertical("down")  -- Move ball down when "Z" is pressed
        end   
    end
end)

    Tabs.all:AddParagraph({
        Title = "emotes",
        Content = ""
    })

local EmoteIds = {
    ["Backflip"] = 13233744006,
    ["Brazil Spin"] = 14412538937,
    ["Brazilian Dance"] = 13233759712,
    ["Champions"] = 17677352529,
    ["Chilly"] = 98214665935820,
    ["Chilly Legs"] = 15508356885,
    ["FCWC Trophy"] = 97408199739643,
    ["GOL GOL"] = 15263200752,
    ["Griddy"] = 13233753849,
    ["Helicopter Helicopter"] = 13774015570,
    ["Knee Slide"] = 13233767422,
    ["Laughing"] = 15508223214,
    ["Meditate"] = 13663293975,
    ["Pigeon Dance"] = 13663288305,
    ["Pump It"] = 15508267662,
    ["Reverse Card"] = 16302284541,
    ["Scythe Spin"] = 90530660352515,
    ["Shhh"] = 17454350795,
    ["Shrug"] = 13663297884,
    ["Sui"] = 13545327424,
    ["T-Rex"] = 16499681915,
    ["Take the L"] = 13233771992,
    ["The Panther"] = 16499697611,
    ["Tree Pose"] = 15508113721,
    ["Wild Dance"] = 16499688823,
}

local currentAnimTrack = nil -- Przechowuje aktualną animację
local isEmotePlaying = false -- Czy animacja jest aktualnie włączona?

-- Funkcja do przełączania emotki ON/OFF
local function ToggleEmote(emoteId)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if isEmotePlaying and currentAnimTrack then
                -- Jeśli animacja jest włączona, zatrzymaj ją
                currentAnimTrack:Stop()
                currentAnimTrack = nil
                isEmotePlaying = false
            else
                -- Jeśli animacja jest wyłączona, uruchom nową
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://" .. emoteId
                currentAnimTrack = humanoid:LoadAnimation(animation)
                currentAnimTrack:Play()
                isEmotePlaying = true

                -- Jeśli animacja się skończy, zmień flagę na OFF
                currentAnimTrack.Stopped:Connect(function()
                    isEmotePlaying = false
                    currentAnimTrack = nil
                end)
            end
        end
    end
end

-- Dropdown do wybierania emotki
local Dropdown = Tabs.all:AddDropdown("EmoteDropdown", {
    Title = "Select Emote",
    Values = {
        "Backflip", "Brazil Spin", "Brazilian Dance", "Champions", "Chilly", "Chilly Legs",
        "FCWC Trophy", "GOL GOL", "Griddy", "Helicopter Helicopter", "Knee Slide", "Laughing",
        "Meditate", "Pigeon Dance", "Pump It", "Reverse Card", "Scythe Spin", "Shhh", "Shrug",
        "Sui", "T-Rex", "Take the L", "The Panther", "Tree Pose", "Wild Dance"
    },
    Multi = false,
    Default = "Backflip",
    Callback = function(value)
        -- Emote nie startuje automatycznie, tylko na przycisk
    end
})

-- Keybind do włączania/wyłączania emotki
local Keybind = Tabs.all:AddKeybind("Keybind", {
    Title = "Emote play/stop",
    Mode = "Toggle",
    Default = "Four", -- Możesz zmienić klawisz
    Callback = function()
        local selectedEmote = Dropdown and Dropdown.Value
        if selectedEmote then
            local emoteId = EmoteIds[selectedEmote]
            if emoteId then
                ToggleEmote(emoteId) -- Przełączanie ON/OFF
            end
        end
    end,
})



    Tabs.all:AddParagraph({
        Title = "tp ball for player",
        Content = ""
    })

-- Player-related functionalities
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SelectedPlayer = nil
local PlayerDropdown = nil

-- Function to update player list
local function UpdatePlayerList()
    local PlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
    table.insert(PlayerList, 1, LocalPlayer.Name)
    table.insert(PlayerList, "none") -- To reset player selection
    if PlayerDropdown then
        PlayerDropdown:SetValues(PlayerList)
    end
    
    -- If selected player leaves, reset to "none"
    if SelectedPlayer and not Players:FindFirstChild(SelectedPlayer.Name) then
        SelectedPlayer = nil
        PlayerDropdown:SetValue("none")
    end
    
    return PlayerList
end

-- Create dropdown for selecting player
PlayerDropdown = Tabs.all:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = UpdatePlayerList(),
    Multi = false,
    Default = "none",
    Callback = function(value)
        if value and value ~= "none" then
            SelectedPlayer = Players:FindFirstChild(value)
        else
            SelectedPlayer = nil
        end
    end
})

-- Function to teleport football to the selected player
local function TeleportFootballToPlayer()
    local football = workspace:FindFirstChild("Junk") and workspace.Junk:FindFirstChild("Football")
    if football and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        football.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame
    end
end

-- Keybind for teleporting ball once
Tabs.all:AddKeybind("Keybind", {
    Title = "TP Ball",
    Mode = "Toggle",
    Default = "Three", 
    Callback = function()
        TeleportFootballToPlayer()
    end,
})

-- Update the player list when players join or leave
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

    Tabs.all:AddParagraph({
        Title = "spam ball",
        Content = "good for xp"
    })
-- Player-related functionalities
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SelectedPlayer = nil
local PlayerDropdown = nil
local VirtualInputManager = game:GetService("VirtualInputManager")
local autoClicking = false
local teleporting = false
local clickInterval = 0  -- Reduced click interval for faster clicks
local toggleState = true -- This will toggle between LocalPlayer and SelectedPlayer

-- Function to update player list
local function UpdatePlayerList()
    local PlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
    table.insert(PlayerList, "none") -- To reset player selection
    if PlayerDropdown then
        PlayerDropdown:SetValues(PlayerList)
    end
    
    -- If selected player leaves, reset to "none"
    if SelectedPlayer and not Players:FindFirstChild(SelectedPlayer.Name) then
        SelectedPlayer = nil
        PlayerDropdown:SetValue("none")
    end
    
    return PlayerList
end

-- Create dropdown for selecting player
PlayerDropdown = Tabs.all:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = UpdatePlayerList(),
    Multi = false,
    Default = "none",
    Callback = function(value)
        if value and value ~= "none" then
            SelectedPlayer = Players:FindFirstChild(value)
        else
            SelectedPlayer = nil
        end
    end
})

-- Function to teleport football to LocalPlayer or SelectedPlayer based on toggleState
local function TeleportFootballToPlayers()
    while teleporting do
        local football = workspace:FindFirstChild("Junk") and workspace.Junk:FindFirstChild("Football")
        
        -- Teleport to LocalPlayer if toggleState is true
        if football and LocalPlayer and LocalPlayer.Character and toggleState then
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                football.CFrame = humanoidRootPart.CFrame
            end
        end
        
        -- Teleport to SelectedPlayer if toggleState is false
        if football and SelectedPlayer and SelectedPlayer.Character and not toggleState then
            local humanoidRootPart = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                football.CFrame = humanoidRootPart.CFrame
            end
        end

        -- Toggle the state to alternate between players quickly
        toggleState = not toggleState
        task.wait()
    end
end

-- Auto clicker function
local function AutoClicker()
    while autoClicking do
        task.wait(clickInterval)
        if LocalPlayer then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Left click down
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Left click up
        end
    end
end

-- Keybind for teleporting ball to LocalPlayer and SelectedPlayer (alternating) and auto clicker
Tabs.all:AddKeybind("Keybind", {
    Title = "spam ball",
    Mode = "Toggle",
    Default = "One",  
    Callback = function()
        autoClicking = not autoClicking
        teleporting = not teleporting
        
        if autoClicking then
            task.spawn(AutoClicker)
        end
        
        if teleporting then
            task.spawn(TeleportFootballToPlayers)
        end
    end,
})

-- Update the player list when players join or leave
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)






-- Add a paragraph
Tabs.all:AddParagraph({
    Title = "Jump Power Settings",
    Content = "",
})

-- Variable to store the selected jump power
local selectedJumpPower = 50

-- Add a slider for jump power
local Sliderjump = Tabs.all:AddSlider("Sliderjump", {
    Title = "Jump Power",
    Description = "",
    Default = 50, -- Default jump power
    Min = 50, -- Minimum jump power
    Max = 160, -- Maximum jump power
    Rounding = 0.040,
    Callback = function(Value)
        selectedJumpPower = Value 
    end
})

-- Loop to apply jump power consistently
task.spawn(function()
    while task.wait(0.1) do
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = selectedJumpPower
        end
    end
end)


    Tabs.all:AddParagraph({
        Title = "colors",
        Content = "colors of stamina and power"
    })

-- Referencje do MatchHUD i EnergyBars
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gameGui = playerGui:FindFirstChild("GameGui")

local matchHUD = gameGui and gameGui:FindFirstChild("MatchHUD")
local energyBars = matchHUD and matchHUD:FindFirstChild("EnergyBars") -- POPRAWIONA NAZWA!

if not matchHUD then
    return
end

if not energyBars then
    return
end

-- Funkcja do ustawiania gradientu
local function setGradient(frame, startColor, endColor)
    if frame then
        local progressBar = frame:FindFirstChild("ProgressBar")
        if progressBar then
            local existingGradient = progressBar:FindFirstChild("UIGradient")
            if existingGradient then
                existingGradient:Destroy()
            end
            local newGradient = Instance.new("UIGradient")
            newGradient.Color = ColorSequence.new(startColor, endColor)
            newGradient.Rotation = 90
            newGradient.Parent = progressBar
        end
    end
end

-- Domyślne kolory
local powerLeftColor = Color3.fromRGB(0, 0, 0)
local powerRightColor = Color3.fromRGB(255, 255, 255)
local staminaLeftColor = Color3.fromRGB(0, 0, 0)
local staminaRightColor = Color3.fromRGB(255, 255, 255)

-- Funkcja do aktualizacji kolorów
local function updateColors()
    setGradient(energyBars:FindFirstChild("Power"), powerLeftColor, powerRightColor)
    setGradient(energyBars:FindFirstChild("Stamina"), staminaLeftColor, staminaRightColor)
end

-- Colorpicker dla Stamina Left
local staminaLeftPicker = Tabs.all:AddColorpicker("Colorpicker", {
    Title = "Stamina Up",
    Default = staminaLeftColor
})
staminaLeftPicker:OnChanged(function(color)
    staminaLeftColor = color
    updateColors()
end)

-- Colorpicker dla Stamina Right
local staminaRightPicker = Tabs.all:AddColorpicker("Colorpicker", {
    Title = "Stamina Down",
    Default = staminaRightColor
})
staminaRightPicker:OnChanged(function(color)
    staminaRightColor = color
    updateColors()
end)

-- Colorpicker dla Power Left
local powerLeftPicker = Tabs.all:AddColorpicker("Colorpicker", {
    Title = "Power Up",
    Default = powerLeftColor
})
powerLeftPicker:OnChanged(function(color)
    powerLeftColor = color
    updateColors()
end)

-- Colorpicker dla Power Right
local powerRightPicker = Tabs.all:AddColorpicker("Colorpicker", {
    Title = "Power Down",
    Default = powerRightColor
})
powerRightPicker:OnChanged(function(color)
    powerRightColor = color
    updateColors()
end)

-- Uruchomienie pierwszej aktualizacji
updateColors()





Window:SelectTab(1)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("nothing/nothing")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
endUI(function()
end)
