warn "T"
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

-- Funkcja do rekurencyjnego znajdowania dzieci
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

-- Funkcja do usuwania PartyLeader
local function deletePartyLeaders()
    local party = gameGui:FindFirstChild("Party")
    if party then
        local members = findChildRecursive(party, {"TopbarLayout", "PartyLayout", "Members"})
        if members then
            for _, button in ipairs(members:GetChildren()) do
                if button.Name == "CircleButton" and button:FindFirstChild("Background") then
                    local partyLeader = button.Background:FindFirstChild("PartyLeader")
                    if partyLeader then
                        partyLeader:Destroy()
                        return true -- Zwraca true, jeśli element został usunięty
                    end
                end
            end
        end
    end
    return false -- Zwraca false, jeśli nie było co usuwać
end

-- Monitorowanie elementów do usunięcia
local function monitorGUI()
    while true do
        -- Spróbuj usunąć podstawowe elementy
        deleteElements(gameGui, {"Transition", "KeyHints"})

        -- Usuń PartyLeader, jeśli istnieje
        local deleted = deletePartyLeaders()

        -- Jeśli coś zostało usunięte, kontynuuj pętlę
        if deleted then
            task.wait(0.1) -- Odroczona ponowna próba usunięcia
        else
            break -- Przerwij, jeśli nie ma nic do usunięcia
        end
    end
end

-- Uruchom proces monitorowania
monitorGUI()






--gui
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create window
local Window = Fluent:CreateWindow({
    Title = "Super League Soccer!",
    SubTitle = "nothing",
    TabWidth = 150,
    Size = UDim2.fromOffset(500, 300),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

-- Add tabs
local Tabs = {
        tab2 = Window:AddTab({ Title = "Custom Hitbox", Icon = "play" }),
        Main = Window:AddTab({ Title = "Football Controls", Icon = "play" }),
        emote = Window:AddTab({ Title = "Emotes", Icon = "play" }),
        tab1 = Window:AddTab({ Title = "tp ball for player", Icon = "play" }),
	    tab5 = Window:AddTab({ Title = "Colors", Icon = "play" }),
		    keybinds = Window:AddTab({ Title = "keybinds", Icon = "play" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}


-- Default hitbox settings
local defaultSizeX, defaultSizeY, defaultSizeZ = 4.521276473999023, 5.7297587394714355, 2.397878408432007
local defaultTransparency = 1
local defaultColor = Color3.fromRGB(255, 255, 255)












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
        warn("🙃", team.Name)
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

-- one i V
local player = game.Players.LocalPlayer
local junkFolder = workspace:WaitForChild("Junk") -- Folder with objects to track



-- States
local isAutoFollowActive = false
local autoClickingJust = false
local footballs = {} -- List of footballs to track
local clickInterval = 0.1 -- Interval between clicks (in seconds)

-- Combined function: Teleport, follow, and auto-click
local function teleportAndAutoFollow()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    for _, obj in ipairs(junkFolder:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
            if not table.find(footballs, obj) then
                table.insert(footballs, obj)
            end
            obj.CFrame = CFrame.new(rootPart.Position)
        end
    end

    -- Begin the combined follow and auto-click loop
    isAutoFollowActive = true
    task.spawn(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        while isAutoFollowActive do
            for _, football in ipairs(footballs) do
                if football and football.Parent then
                    football.CFrame = CFrame.new(rootPart.Position)
                end
            end
            -- Simulate mouse click
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Left click down
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Left click up
            task.wait(clickInterval)
        end
    end)
end

-- Function to stop the combined behavior
local function stopAutoFollow()
    isAutoFollowActive = false
end

-- Auto-clicker for "just" (independent)
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

-- Key press function for behaviors

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

Tabs.keybinds:AddKeybind("Keybind", {
    Title = "spam ball",
    Mode = "Toggle",
    Default = "One",
    Callback = function()
        if isAutoFollowActive then
            stopAutoFollow()
        else
            teleportAndAutoFollow()
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
            bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * 400  -- Boost force
            bodyVelocity.Parent = humanoidRootPart

            -- Remove BodyVelocity after 0.05 seconds
            wait(0.05)
            bodyVelocity:Destroy()
        end

        wait (0.75)
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
-- Function to move parts to player's position
local function movePartsToPlayer()
    local junkFolder = Workspace:FindFirstChild("Junk")
    if not junkFolder or not junkFolder:IsA("Folder") then
        warn("Junk folder not found in Workspace")
        return
    end
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        warn("Player's HumanoidRootPart not found")
        return
    end
    local playerPosition = rootPart.Position
    for _, obj in ipairs(junkFolder:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
            pcall(function()
                obj.Position = playerPosition
            end)
        end
    end
end

Tabs.keybinds:AddKeybind("Keybind", {
    Title = "tp ball",
    Mode = "Toggle",
    Default = "LeftControl",
    Callback = function()
        movePartsToPlayer()
    end,
})
--colors
-- Referencje do MatchHUD i EnergyBars
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gameGui = playerGui:FindFirstChild("GameGui")

local matchHUD = gameGui and gameGui:FindFirstChild("MatchHUD")
local energyBars = matchHUD and matchHUD:FindFirstChild("EngergyBars")

if not (matchHUD and energyBars) then
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
        else

        end
    end
end

-- Domyślne kolory
local powerLeftColor = Color3.fromRGB(0, 0, 0)
local powerRightColor = Color3.fromRGB(255, 0, 0)
local staminaLeftColor = Color3.fromRGB(0, 0, 0)
local staminaRightColor = Color3.fromRGB(255, 0, 0)

-- Colorpicker dla Stamina Left
local staminaLeftPicker = Tabs.tab5:AddColorpicker("Colorpicker", {
    Title = "Stamina Up",
    Default = staminaLeftColor
})

staminaLeftPicker:OnChanged(function(color)
    staminaLeftColor = color
end)

-- Colorpicker dla Stamina Right
local staminaRightPicker = Tabs.tab5:AddColorpicker("Colorpicker", {
    Title = "Stamina Down",
    Default = staminaRightColor
})

staminaRightPicker:OnChanged(function(color)
    staminaRightColor = color
end)

-- Colorpicker dla Power Left
local powerLeftPicker = Tabs.tab5:AddColorpicker("Colorpicker", {
    Title = "Power Up",
    Default = powerLeftColor
})

powerLeftPicker:OnChanged(function(color)
    powerLeftColor = color
end)

-- Colorpicker dla Power Right
local powerRightPicker = Tabs.tab5:AddColorpicker("Colorpicker", {
    Title = "Power Down",
    Default = powerRightColor
})

powerRightPicker:OnChanged(function(color)
    powerRightColor = color
end)

-- Funkcja do aktualizacji kolorów
local function updateColors()
    setGradient(energyBars:FindFirstChild("Power"), powerLeftColor, powerRightColor)
    setGradient(energyBars:FindFirstChild("Stamina"), staminaLeftColor, staminaRightColor)

    -- Wywołanie ponowne po 2 sekundach
    task.delay(2, updateColors)
end

-- Uruchomienie pierwszej aktualizacji
updateColors()


-- Variables for toggle states
local isTeleportingEnabled = false
local isAutoClickerActive = false
local teleportEnabled = false
local loopEnabled = false
local isAutoKickEnabled = false -- Added variable to control auto kick functionality

-- Ustawienia pozycji
local Home = CFrame.new(0.283999115, 4.0250001, -20.9191837) -- Pozycja Away
local Away = CFrame.new(0.271869421, 4.0250001, 20.0689564) -- Pozycja Home


local defaultHitboxSize = Vector3.new(4.521276473999023, 5.7297587394714355, 2.397878408432007)

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local character = player.Character or player.CharacterAdded:Wait()

-- Variables for toggle states
local isHitboxActive = false
local loopActive = false

-- Hitbox Function
local function manageHitboxSize(hitbox)
    while isHitboxActive and loopActive do
        hitbox.Size = Vector3.new(222, 70, 418) -- Dynamic size in loop
        task.wait(0.1) -- Adjust interval as needed
    end
end

local function activateHitbox()
    if isHitboxActive then return end
    isHitboxActive = true

    local function onCharacterAddedHitbox(character)
        local hitbox = character:WaitForChild("Hitbox", 5)
        if hitbox then
            loopActive = true
            task.spawn(function()
                manageHitboxSize(hitbox)
            end)
        end
    end

    player.CharacterAdded:Connect(onCharacterAddedHitbox)

    -- Apply to current character if exists
    if player.Character then
        onCharacterAddedHitbox(player.Character)
    end
end

local function deactivateHitbox()
    if not isHitboxActive then return end
    isHitboxActive = false
    loopActive = false

    -- Reset hitbox size to default once
    if player.Character then
        local hitbox = player.Character:FindFirstChild("Hitbox")
        if hitbox then
            hitbox.Size = defaultHitboxSize
        end
    end
end

-- Teleport Function
local function toggleTeleport()
    isTeleportingEnabled = not isTeleportingEnabled
    if isTeleportingEnabled then
        task.spawn(function()
            while isTeleportingEnabled do
                local team = player.Team
                if team then
                    local position = team.Name == "Home" and Vector3.new(-14.130847, 4.00001049, -188.18988) or Vector3.new(14.0604515, 4.00001144, 187.836166)
                    for _, obj in ipairs(workspace.Junk:GetChildren()) do
                        if obj:IsA("BasePart") then
                            obj.CFrame = CFrame.new(position)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

local function teleportLoop()
    while teleportEnabled do
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            -- Teleportowanie zależne od teamu
            if player.Team == nil then
            elseif player.Team.Name == "Away" then
                rootPart.CFrame = Away
            elseif player.Team.Name == "Home" then
                rootPart.CFrame = Home
            end
        end
        wait(0) -- 0.4 sekundy przerwy
    end
end
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
end)

-- Auto Clicker Function
local function autoClick()
    if not isAutoClickerActive then return end
    while isAutoClickerActive do
        task.wait(0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

-- Move Parts to Player Function
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
                obj.Position = playerPosition
            end)
        end
    end
end

-- Loop Function
local function loop()
    while loopEnabled do
        movePartsToPlayer()
        task.wait(0) -- Delay in seconds
    end
end

-- Function to press E key
local function pressEKey()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Continuously check for the player's model and Ball transparency
local function continuouslyCheckBallTransparency()
    while true do
        if isAutoKickEnabled then
            if player.Character and player.Character:FindFirstChild("Ball") then
                local ball = player.Character.Ball
                if ball.Transparency == 1 then
                    pressEKey() -- Simulate pressing the "E" key
                    wait(0.1) -- Delay to simulate key press duration
                else
                    wait(0.1) -- Short delay to prevent excessive loop iterations
                end
            else
                warn("Ball or player model not found in Workspace")
                wait(1) -- Wait for 1 second before rechecking if Ball or player model is not found
            end
        else
            wait(1) -- If auto kick is not enabled, wait before checking again
        end
    end
end

-- Start the continuous checking in a separate coroutine
coroutine.wrap(continuouslyCheckBallTransparency)()

-- Keybinding using Tabs.keybinds:AddKeybind
Tabs.keybinds:AddKeybind("Keybind", {
    Title = "auto gol (not use you gk)", 
    Mode = "Toggle",
    Default = "T",  -- Default key is "T"
    Callback = function()
        -- Toggle states
        isAutoClickerActive = not isAutoClickerActive
        teleportEnabled = not teleportEnabled
        toggleTeleport()
		

        -- Activate or deactivate auto clicker
        if isAutoClickerActive then
            task.spawn(autoClick)
        end

        -- Start or stop teleport loop
        loopEnabled = not loopEnabled
        if loopEnabled then
            task.spawn(loop)
        end

        -- Toggle auto kick
        isAutoKickEnabled = not isAutoKickEnabled
        
        -- If teleporting is enabled, start the teleport loop
        if teleportEnabled then
            spawn(teleportLoop)
        end
		        if isHitboxActive then
            deactivateHitbox()
        else
            activateHitbox()
        end
    end
})







--ball track
local function checkAndSetTackleHitboxSize(hitbox)
    -- Sprawdzamy, czy rozmiar hitboxu nie jest już równy (10, 38, 6)
    if hitbox.Size ~= Vector3.new(45, 6, 45) then
        -- Jeśli rozmiar jest inny, ustawiamy go na (10, 38, 6)
        hitbox.Size = Vector3.new(45, 6, 45)
    end
end
-- Funkcja do obsługi postaci gracza
local function onCharacterAdded(character)
    -- Czekamy na obiekt TackleHitbox w postaci gracza
    local hitbox = character:WaitForChild("TackleHitbox", 5)  -- Timeout 5 sekund dla bezpieczeństwa
    
    if hitbox then
        -- Ustawiamy poprawny rozmiar hitboxu
        checkAndSetTackleHitboxSize(hitbox)
        
        -- Obserwujemy zmiany rozmiaru i automatycznie poprawiamy je, jeśli zajdzie potrzeba
        hitbox:GetPropertyChangedSignal("Size"):Connect(function()
            checkAndSetTackleHitboxSize(hitbox)
        end)
    end
end
-- Podpinamy obsługę zdarzenia do LocalPlayer
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(onCharacterAdded)
-- Jeśli postać już istnieje, obsługujemy ją od razu
if player.Character then
    onCharacterAdded(player.Character)
end



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
local Toggle = Tabs.tab2:AddToggle("MyToggle", { Title = "Custom Hitbox", Default = false })

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
local InputX = Tabs.tab2:AddInput("InputX", { 
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

local InputY = Tabs.tab2:AddInput("InputY", { 
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

local InputZ = Tabs.tab2:AddInput("InputZ", { 
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
local TransparencySlider = Tabs.tab2:AddSlider("TransparencySlider", { 
    Title = "Transparency", 
    Description = "",
    Default = 10,  -- Default slider value is 1, which maps to 0.1
    Min = 1,      -- Minimum value of 1 (which maps to 0.1 transparency)
    Max = 10,     -- Maximum value of 10 (which maps to 1 transparency)
    Rounding = 1, 
    Callback = function(Value)
        -- Scale the value from 1-10 to 0.1-1
        hitboxTransparency = Value * 0.1
        if isHitboxActive then
            updateRealHitbox()  -- Update transparency of the real hitbox part only if toggle is ON
        end
    end
})

TransparencySlider:SetValue(1)  -- Set default transparency value to 1 (which maps to 0.1)

-- Color picker for hitbox color
local Colorpicker = Tabs.tab2:AddColorpicker("Colorpicker", {
    Title = "Hitbox Color",
    Default = Color3.fromRGB(255, 255, 255)
})

Colorpicker:OnChanged(function()
    hitboxColor = Colorpicker.Value
    if isHitboxActive then
        updateRealHitbox()  -- Update color of the real hitbox part only if toggle is ON
    end
end)

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
local Slider = Tabs.Main:AddInput("Slider", {
    Title = "Speed",
    Description = "20-1000",
    Default = 80,
    Min = 30,
    Max = 700,
    Rounding = 1,
    Callback = function(Value)
        kickSpeed = Value  -- Update kickSpeed based on slider value
    end
})

-- Add a slider to control the vertical move amount for the ball
local VerticalSlider = Tabs.Main:AddInput("VerticalSlider", {
    Title = "up|down",
    Description = "20-600",
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

Tabs.keybinds:AddKeybind("Keybind", {
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

local currentAnimTrack = nil -- Track the current animation playing

-- Function to play or stop emote based on ID
local function ToggleEmote(emoteId)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- If there's an animation currently playing, stop it
            if currentAnimTrack and currentAnimTrack.IsPlaying then
                currentAnimTrack:Stop()
                currentAnimTrack = nil
            else
                -- Otherwise, play the new emote
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://" .. emoteId
                currentAnimTrack = humanoid:LoadAnimation(animation)
                currentAnimTrack:Play()

                -- Optionally, handle emote stopping and re-triggering
                currentAnimTrack.Stopped:Connect(function()
                    currentAnimTrack = nil -- Reset the animation when it stops
                end)
            end
        end
    end
end

-- Dropdown for selecting emote
local Dropdown = Tabs.emote:AddDropdown("EmoteDropdown", {
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
        -- Emote does not play automatically now; it's only triggered by keybind
    end
})

-- Keybind for activating the emote (toggle play/stop)
local Keybind = Tabs.keybinds:AddKeybind("Keybind", {
    Title = "Emote play/stop 2x times",
    Mode = "Toggle",
    Default = "Four", -- Change this to any desired key
    Callback = function(pressed)
        if pressed then
            local selectedEmote = Dropdown and Dropdown.Value
            if selectedEmote then
                local emoteId = EmoteIds[selectedEmote]
                if emoteId then
                    ToggleEmote(emoteId) -- Toggle the selected emote (play/stop)
                end
            end
        end
    end,
})

-- Player-related functionalities
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SelectedPlayer = nil
local PlayerDropdown = nil

-- Function to update player list
local function UpdatePlayerList()
    local PlayerList = {}
    -- Add all players except the LocalPlayer to the list
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
    -- Add LocalPlayer at the top of the list
    table.insert(PlayerList, 1, LocalPlayer.Name)
    -- Add "none" option at the bottom of the list
    table.insert(PlayerList, "none")

    -- Refresh the dropdown with the updated player list
    if PlayerDropdown then
        PlayerDropdown:SetValues(PlayerList)
    end

    return PlayerList
end

-- Create dropdown for selecting player
PlayerDropdown = Tabs.tab1:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = UpdatePlayerList(),  -- Call UpdatePlayerList() to get initial values
    Multi = false,
    Default = "none",
    Callback = function(value)
        if value and value ~= "none" then
            -- Set SelectedPlayer to the player if one is selected
            SelectedPlayer = Players:FindFirstChild(value)
        else
            -- Set SelectedPlayer to nil when "none" is selected (do nothing)
            SelectedPlayer = nil
        end
    end
})

-- Function to teleport football to the selected player
local function TeleportFootballToPlayer()
    local football = workspace:FindFirstChild("Junk") and workspace.Junk:FindFirstChild("Football")
    if football then
        if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- If a player is selected, teleport football to their position
            football.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame
        elseif SelectedPlayer == nil then
            -- If "none" is selected, do nothing (football stays where it is)
            -- Alternatively, you could set the football to a default position (like LocalPlayer's position)
            -- but in this case we do nothing if "none" is selected
            return
        end
    end
end

Tabs.keybinds:AddKeybind("Keybind", {
    Title = "TP ball to Player",
    Mode = "Toggle",
    Default = "Three", -- Change this key if needed
    Callback = function()
        TeleportFootballToPlayer()
    end,
})


-- Update the player list when players join or leave
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Add button to manually refresh the player list
Tabs.tab1:AddButton({
    Title = "Refresh Player List",
    Description = "",
    Callback = function()
        UpdatePlayerList()
    end
})






SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("nothing")
SaveManager:SetFolder("nothing/super-score-liga")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

