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
    warn("join game Super League Soccer!")
    return
end

-- Funkcja do usuwania ekranów
local function deleteScreen(screen)
    if screen then
        screen:Destroy()
    end
end


-- Usuwanie Transition i KeyHints
deleteScreen(gameGui:FindFirstChild("Transition"))
deleteScreen(gameGui:FindFirstChild("KeyHints"))

-- Referencje do MatchHUD i EnergyBars
local matchHUD = gameGui:FindFirstChild("MatchHUD")
local energyBars = matchHUD and matchHUD:FindFirstChild("EngergyBars")

if not (matchHUD and energyBars) then
    print("-")
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
            print("-")
        end
    end
end

-- Ustawienie gradientu dla Power i Stamina
setGradient(energyBars:FindFirstChild("Power"), Color3.new(0, 0, 0), Color3.new(255, 0, 0)) -- Black to Red
setGradient(energyBars:FindFirstChild("Stamina"), Color3.new(0, 0, 0), Color3.new(255, 255, 255)) -- Black to White

-- Usuwanie PartyLeader
local party = gameGui:FindFirstChild("Party")
if party then
    local topbarLayout = party:FindFirstChild("TopbarLayout")
    local partyLayout = topbarLayout and topbarLayout:FindFirstChild("PartyLayout")
    local members = partyLayout and partyLayout:FindFirstChild("Members")

    if members then
        -- Szukamy odpowiedniego CircleButton
        local buttons = members:GetChildren()
        for _, button in ipairs(buttons) do
            if button.Name == "CircleButton" and button:FindFirstChild("Background") then
                local background = button.Background
                local partyLeader = background:FindFirstChild("PartyLeader")
                if partyLeader then
                    partyLeader:Destroy()
                    break -- Usuwamy tylko pierwszego lidera
                end
            end
        end
    else
        print("-")
    end
else
    print("-")
end


--gui
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
Fluent:Notify({
    Title = "nothing",
    Content = "start load",
    Duration = 3
})
-- Create window
local Window = Fluent:CreateWindow({
    Title = "Super League Soccer!",
    SubTitle = "nothing",
    TabWidth = 150,
    Size = UDim2.fromOffset(550, 450),
    Acrylic = false,
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.LeftAlt
})

-- Add tabs
local Tabs = {
        tab2 = Window:AddTab({ Title = "Custom Hitbox", Icon = "play" }),
        Main = Window:AddTab({ Title = "Football Controls", Icon = "play" }),
        emote = Window:AddTab({ Title = "Emotes", Icon = "play" }),
        tab1 = Window:AddTab({ Title = "tp ball for player", Icon = "play" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}


-- Default hitbox settings
local defaultSizeX, defaultSizeY, defaultSizeZ = 4.521276473999023, 5.7297587394714355, 2.397878408432007
local defaultTransparency = 1
local defaultColor = Color3.fromRGB(255, 255, 255)










-- Boost Speed
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

        -- Reset boost availability
        wait(1)
        boostActive = false
    end
end

-- Set up boost for the character
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Listen for the LeftShift key press to activate boost
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
            boostSpeed(character)
        end
    end)
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

-- Input handling for moving parts to the player
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.LeftControl then
        movePartsToPlayer()
    end
end)








---one good farming xp 2 players use same xp

local player = game.Players.LocalPlayer
local junkFolder = workspace:WaitForChild("Junk") -- Folder z obiektami do śledzenia
local keyBind = Enum.KeyCode.One -- Klawisz do aktywacji teleportacji i śledzenia

local isFollowing = false
local footballs = {} -- Lista obiektów Football, które będą śledzone

-- Funkcja do teleportacji wszystkich Football, kick1, kick2, kick3
local function teleportAndFollow()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleportowanie wszystkich Football, kick1, kick2, kick3 w folderze Junk
    for _, obj in ipairs(junkFolder:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name == "kick1" or obj.Name == "kick2" or obj.Name == "kick3" or obj.Name == "Football") then
            -- Dodajemy obiekt do listy, jeśli jeszcze nie jest
            if not table.find(footballs, obj) then
                table.insert(footballs, obj)
            end
            -- Teleportacja obiektu do gracza na środek
            obj.CFrame = CFrame.new(rootPart.Position)
        end
    end

    -- Pętla śledząca gracza
    isFollowing = true
    while isFollowing do
        -- Sprawdzamy, czy Footballs istnieją
        for _, football in ipairs(footballs) do
            if football then
                -- Ustawiamy Football na środek gracza
                football.CFrame = CFrame.new(rootPart.Position)
            end
        end
        wait(0) -- Minimalny czas oczekiwania, by było to wykonywane jak najczęściej
    end
end

-- Funkcja zatrzymująca śledzenie
local function stopFollowing()
    isFollowing = false
end

-- Aktywacja teleportacji + śledzenie przez naciśnięcie klawisza
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == keyBind then
            if isFollowing then
                stopFollowing()  -- Zatrzymuje śledzenie
            else
                teleportAndFollow()  -- Włącza teleportację i śledzenie
            end
        end
    end
end)

-- Obsługuje dodanie piłek do folderu Junk
junkFolder.ChildAdded:Connect(function(child)
    if child:IsA("BasePart") and (child.Name == "kick1" or child.Name == "kick2" or child.Name == "kick3" or child.Name == "Football") then
        -- Dodajemy obiekt do listy, ale nie teleportujemy go od razu
        if not table.find(footballs, child) then
            table.insert(footballs, child)
        end
    end
end)

-- Obsługuje usunięcie piłek z folderu Junk
junkFolder.ChildRemoved:Connect(function(child)
    if child:IsA("BasePart") and (child.Name == "kick1" or child.Name == "kick2" or child.Name == "kick3" or child.Name == "Football") then
        -- Usuwamy obiekt z listy
        for i, football in ipairs(footballs) do
            if football == child then
                table.remove(footballs, i)
                break
            end
        end
    end
end)

-- Zatrzymanie śledzenia, jeśli gracz opuści grę (opcjonalnie)
game:GetService("Players").PlayerRemoving:Connect(function(removedPlayer)
    if removedPlayer == player then
        stopFollowing()
    end
end)
--auto for One
local clickInterval = 0 -- Interval between clicks (in seconds)
local toggleKey = Enum.KeyCode.One -- Key to toggle auto-clicker

local autoClicking = false -- Auto-clicker state

-- Function to simulate mouse click
local function autoClick()
    local VirtualInputManager = game:GetService("VirtualInputManager")

    while autoClicking do
        wait(clickInterval)
        
        -- Check if the player is present
        if game.Players.LocalPlayer then
            -- Simulate mouse click
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Left click down
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Left click up
        end
    end
end

-- Key press function to start/stop auto-clicking
local function onKeyPress(input, gameProcessedEvent)
    if input.KeyCode == toggleKey and not gameProcessedEvent then
        autoClicking = not autoClicking
        if autoClicking then
            spawn(autoClick) -- Run auto-clicker in a new thread
        end
    end
end

-- Connect key press event to toggle auto-clicker
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)



-- Auto Clicker
local clickInterval = 0 -- Interval between clicks (in seconds)
local toggleKey = Enum.KeyCode.V -- Key to toggle auto-clicker

local autoClicking = false -- Auto-clicker state

-- Function to simulate mouse click
local function autoClick()
    local VirtualInputManager = game:GetService("VirtualInputManager")

    while autoClicking do
        wait(clickInterval)
        
        -- Check if the player is present
        if game.Players.LocalPlayer then
            -- Simulate mouse click
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- Left click down
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- Left click up
        end
    end
end

-- Key press function to start/stop auto-clicking
local function onKeyPress(input, gameProcessedEvent)
    if input.KeyCode == toggleKey and not gameProcessedEvent then
        autoClicking = not autoClicking
        if autoClicking then
            spawn(autoClick) -- Run auto-clicker in a new thread
        end
    end
end

-- Connect key press event to toggle auto-clicker
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)





-- Ball Hitbox Size Check
local function checkAndSetTackleHitboxSize(hitbox)
    -- Check if the hitbox size is not (100, 100, 100)
    if hitbox.Size ~= Vector3.new(20, 20, 20) then
        -- If the size is different, set it to (100, 100, 100)
        hitbox.Size = Vector3.new(20, 20, 20)
    end
end

-- Function to handle player character
local function onCharacterAdded(character)
    -- Wait for the TackleHitbox in the player's character
    local hitbox = character:WaitForChild("TackleHitbox", 5)  -- Timeout 5 seconds for safety
    
    if hitbox then
        -- Set correct hitbox size
        checkAndSetTackleHitboxSize(hitbox)
        
        -- Watch for changes in size and fix it if needed
        hitbox:GetPropertyChangedSignal("Size"):Connect(function()
            checkAndSetTackleHitboxSize(hitbox)
        end)
    end
end

-- Connect to CharacterAdded event for the LocalPlayer
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(onCharacterAdded)

-- Handle current character if it exists
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
    
    -- Toggle controls when the "F" key is pressed
    if input.KeyCode == Enum.KeyCode.Two and not gameProcessed then
        toggleControls()
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
local Keybind = Tabs.emote:AddKeybind("Keybind", {
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
    return PlayerList
end

-- Create dropdown for selecting player
PlayerDropdown = Tabs.tab1:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = UpdatePlayerList(),  -- Corrected here to call UpdatePlayerList() before passing it
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

-- Add keybind to teleport football
Tabs.tab1:AddKeybind("Keybind", {
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





Fluent:Notify({
    Title = "nothing",
    Content = "end load",
    Duration = 3
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

wait ("5")
Fluent:Notify({
    Title = "nothing",
    Content = "Enjoy the scripts",
    Duration = 15
})
wait ("15.2")
Fluent:Notify({
    Title = "nothing",
    Content = "👍👍",
    Duration = 3.5
})
