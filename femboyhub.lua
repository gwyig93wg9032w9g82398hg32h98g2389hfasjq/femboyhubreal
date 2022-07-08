    
--------------------------------------------------------------------------
-- @ CloneTrooper1019, 2020-2021
--   Thread.lua
--------------------------------------------------------------------------

local Thread = {}

--------------------------------------------------------------------------
-- Task Scheduler
--------------------------------------------------------------------------

local RunService = game:GetService("RunService")
local front

-- use array indices for speed
-- and avoiding lua hash tables

local THREAD = 1
local RESUME = 2
local NEXT = 3

local function pushThread(thread, resume)
	local node =
	{
		[THREAD] = thread;
		[RESUME] = resume;
	}
	
	if front then
		if front[RESUME] >= resume then
			node[NEXT] = front
			front = node
		else
			local prev = front
			
			while prev[NEXT] and prev[NEXT][RESUME] < resume do
				prev = prev[NEXT]
			end
			
			node[NEXT] = prev[NEXT]
			prev[NEXT] = node
		end
	else
		front = node
	end
end

local function popThreads()
	local now = os.clock()
	
	while front do
		-- Resume if we're reasonably close enough.
		if front[RESUME] - now < (1 / 120) then
			local thread = front[THREAD]
			front = front[NEXT]
			
			coroutine.resume(thread, now)
		else
			break
		end
	end
end

RunService.Heartbeat:Connect(popThreads)

--------------------------------------------------------------------------
-- Thread
--------------------------------------------------------------------------

local errorStack = "ERROR: %s\nStack Begin\n%sStack End"

local function HandleError(err)
	local trace = debug.traceback()
	warn(errorStack:format(err, trace))
end

function Thread:Wait(number)
	local t = tonumber(t)
	
	if t then
		local start = os.clock()
		pushThread(coroutine.running(), start + t)
		
		return coroutine.yield() - start
	else
		return RunService.Heartbeat:Wait()
	end	
end

function Thread:Spawn(func, ...)
	local args = { ... }
	local numArgs = select('#', ...)
	local bindable = Instance.new("BindableEvent")
	
	bindable.Event:Connect(function (stack)
		xpcall(func, HandleError, stack())
	end)
	
	bindable:Fire(function ()
		return unpack(args, 1, numArgs)
	end)
end

function Thread:Delay(t, callback)
	self:Spawn(function ()
		local delayTime, elapsed = self:Wait(t)
		xpcall(callback, HandleError, delayTime, elapsed)
	end)
end


local check = 0

check = check+1 


print("Checkpoint "..tostring(check))


for i,v in pairs(game.Players.LocalPlayer.PlayerScripts:GetChildren()) do
    if string.find(v.Name,"Theme") then
    v:Destroy()
end
end

local BLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/gwyig93wg9032w9g82398hg32h98g2389hfasjq/femboyhubreal/main/BssUI"))()

local Val = Instance.new("StringValue")
----
Val.Name = "Theme"
Val.Parent = game:GetService("Players").LocalPlayer.PlayerScripts
Val.Value = "None"

local Val = Instance.new("IntValue")
----
Val.Name = "Timer"
Val.Parent = game:GetService("Players").LocalPlayer.PlayerScripts
Val.Value = "1000"
--------------------------------

check = check+1

print("Checkpoint "..tostring(check))

local QuestTimer = 1

local Window = BLibrary.CreateLib("Femboy Hub | Bee Swarm Simulator", colors)

local mainTab = Window:NewTab("Main")

local quickequipsTab = Window:NewTab("Quick Equips")
local AutofarmingTab = Window:NewTab("Utilities")
local fieldTPsTab = Window:NewTab("Pollen Farming")
local main = mainTab:NewSection("Functions")

local quickequips = quickequipsTab:NewSection("Quick Equips")
local fieldTPs = fieldTPsTab:NewSection("Pollen Farming")
local Autofarming = AutofarmingTab:NewSection("Utilities")

local Autofarming2 = fieldTPs
local AutoPolar = false
local QuestList = {
    "Polar Bear",
    "Brown Bear",
    "Black Bear"
}
function ListToOb(tabl,tf)
    local out = {}
    for k, v in pairs(tabl) do
        if tf then 
            out[v] = true
        else
            out[v] = false
        end
    end
    return out
end
local QuestTF = ListToOb(QuestList)
--------------------------------
game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

check = check+1

print("Checkpoint "..tostring(check))

-------------Auto-Load Stuff-------------------
LockedStatsStats = false
GodModeStats = false
AntiAfkStats = false
MemoryMatchCheatStats = false
ViciStats = false
WindyStats = false
wealthClockStats = false
DsiableUnder1Stats = false
EquippedTheme = game:GetService("Players").LocalPlayer.PlayerScripts.Theme.Value


--------------------------------

noclip = false
game:GetService("RunService").Stepped:connect(
    function()
        if noclip then
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        end
    end
)
plr = game.Players.LocalPlayer
mouse = plr:GetMouse()
mouse.KeyDown:connect(
    function(key)
        if key == "o" then
            noclip = not noclip
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        end
    end
)

plr = game.Players.LocalPlayer
mouse = plr:GetMouse()
mouse.KeyDown:connect(
    function(key)
        if key == "p" then
            noclip = not noclip
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(0)
        end
    end
)

--------------------------------

--------Extra Functions---------


local player = game:GetService("Players").LocalPlayer

local replicatedstorage = game:GetService("ReplicatedStorage")

local replicatedStorage = replicatedstorage

local function getTokenIcon(tokenType)
    if replicatedstorage.Collectibles:FindFirstChild(tokenType) then
        return table.pack(require(replicatedstorage.Collectibles[tokenType]):Visuals())[2]
    end
    local types = replicatedstorage.EggTypes
    local eggTypes = require(types)
    if eggTypes.Exists(tokenType) then
        return eggTypes.GetTypes()[tokenType].Icon
    end
    if types:FindFirstChild(tokenType .. "Icon") then
        return types:FindFirstChild(tokenType .. "Icon").Texture
    end
    return nil
end

local function getValidActiveQuests()
    local activeQuests = {}

    local statCache = require(replicatedstorage.ClientStatCache)

    local quests = require(replicatedstorage.Quests)

    for _, v in pairs(statCache:Get().Quests.Active) do
        if not (quests:Get(v.Name).Expiration and quests:Get(v.Name).Expiration < require(replicatedstorage.OsTime)()) then
            table.insert(activeQuests, quests:Get(v.Name))
        end
    end
    return activeQuests
end

local function getActiveQuests()
    return require(replicatedstorage.ClientStatCache):Get().Quests.Active
end

local function createWaitWrapper(func, time)
    local counter = 0

    local delay = time

    local tab = {}

    local avail = false

    function tab:Step(step)
        counter = counter + step
        avail = false
        while counter > delay do
            counter = counter - delay
            avail = true
        end
        if avail then
            func()
        end
    end

    function tab:ChangeDelay(newDelay)
        delay = newDelay
    end

    return tab
end

local rep = replicatedstorage
local r = require

local function getTimeSinceToyActivation(name)
    return r(rep.OsTime)() - r(rep.ClientStatCache):Get("ToyTimes")[name]
end

local function getTimeUntilToyAvailable(n)
    return workspace.Toys[n].Cooldown.Value - getTimeSinceToyActivation(n)
end
--------------------------------

check = check+1

print("Checkpoint "..tostring(check))

--------More Setup Stuff--------

spawn(function()
        local mainGUI = player:WaitForChild("PlayerGUI"):FindFirstChild("ScreenGui")
        if mainGUI then
            for _, v in pairs(
                {"Blender", "MinigameLayer", "QuestionBox", "BoostMarket", "Tutorial", "MessageBox", "QuantityBox"}
            ) do
                vv = mainGUI:FindFirstChild(v)
                if vv then
                    vv.ZIndex = 0
                end
            end
        end
    end
)


check = check+1

print("Checkpoint "..tostring(check))
--------------------------------
local val = {use = false, HipHeight = 2, WalkSpeed = 100, JumpPower = 80}



main:Slider(
    "WalkSpeed",
    16,
    200,
    100,
    function(t)
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = t
        val.WalkSpeed = t
    end
)

main:Slider(
    "JumpPower",
    16,
    250,
    80,
    function(t)
        game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = t
        val.JumpPower = t
    end
)

local LockStatsTog = main:Toggle(
    "Lock Stats to Sliders",
    function(use)
        LockedStatsStats = use
        val.use = use
        if use then
            local h = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
            h.WalkSpeed = val.WalkSpeed
            h.JumpPower = val.JumpPower
            h.HipHeight = val.HipHeight
        end
    end
)

game.Players.LocalPlayer.CharacterAdded:Connect(
    function()
        local h = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

        h:GetPropertyChangedSignal("WalkSpeed"):Connect(
            function()
                if val.use then
                    h.WalkSpeed = val.WalkSpeed
                end
            end
        )

        h:GetPropertyChangedSignal("JumpPower"):Connect(
            function()
                if val.use then
                    h.JumpPower = val.JumpPower
                end
            end
        )

        h:GetPropertyChangedSignal("HipHeight"):Connect(
            function()
                if val.use then
                    h.HipHeight = val.HipHeight
                end
            end
        )

        if val.use then
            h.WalkSpeed = val.WalkSpeed
            h.JumpPower = val.JumpPower
            h.HipHeight = val.HipHeight
        end
    end
)

local h = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

h:GetPropertyChangedSignal("WalkSpeed"):Connect(
    function()
        if val.use then
            h.WalkSpeed = val.WalkSpeed
        end
    end
)

h:GetPropertyChangedSignal("JumpPower"):Connect(
    function()
        if val.use then
            h.JumpPower = val.JumpPower
        end
    end
)

h:GetPropertyChangedSignal("HipHeight"):Connect(
    function()
        if val.use then
            h.HipHeight = val.HipHeight
        end
    end
)
local peeee=main:Toggle(
    "Anti Afk",
    function(state)
        AntiAfkStats = state
        if state then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(
                function()
                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    wait(1)
                    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end
            )
        end
    end
)
main:Toggle(
    "Memory Match Show All",
    function(state)
        state = MemoryMatchCheatStats
        if state then
            spawn(
                function()
                    while wait() do
                        for i, v in pairs(
                            game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren()
                        ) do
                            for k, q in pairs(v:WaitForChild("GuiGrid"):GetDescendants()) do
                                if q.Name == "ObjContent" or q.Name == "ObjImage" then
                                    q.Visible = true
                                end
                            end
                        end
                    end
                end
            )
        else
        end
    end
)
local wealthClock = false

local wClockBtn =
    Autofarming:Toggle(
    "Auto-Wealth Clock",
    function(state)
        wealthClockStats = state
        wealthClock = state
    end
)

local sortedToys = {}

for _, v in pairs(workspace.Toys:GetChildren()) do
    table.insert(sortedToys, v.Name)
end

table.sort(sortedToys)

local function equip(name)
    replicatedstorage.Events.ItemPackageEvent:InvokeServer(
        "Equip",
        {["Type"] = name, ["Category"] = "Accessory", ["Mute"] = true}
    )
end


quickequips:Button(
    "Porcelain Hive",
    function()
        equip("Porcelain Port-O-Hive")
    end
)

quickequips:Button(
    "Honey Mask",
    function()
        equip("Honey Mask")
    end
)

quickequips:Button(
    "Gummy Mask",
    function()
        equip("Gummy Mask")
    end
)


quickequips:Button(
    "Red Hive",
    function()
        equip("Red Port-O-Hive")
    end
)

quickequips:Button(
    "Fire Mask",
    function()
        equip("Fire Mask")
    end
)

quickequips:Button(
    "Demon Mask",
    function()
        equip("Demon Mask")
    end
)


quickequips:Button(
    "Blue Hive",
    function()
        equip("Blue Port-O-Hive")
    end
)

quickequips:Button(
    "Bubble Mask",
    function()
        equip("Bubble Mask")
    end
)

quickequips:Button(
    "Diamond Mask",
    function()
        equip("Diamond Mask")
    end
)

Autofarming:Button(
    "Rejoin Game",
    function()
        game:GetService("TeleportService"):Teleport(game.placeId)
    end
)

local disableAutofarmOnMultiplePeople = false

local killcoconut = false

local cocoTpButton =
    Autofarming:Button(
    "TP to Coconut Spot (Bees spawn tokens on you)",
    function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-312.65, 110, 473.75)
    end
)

local coconut = false
local KillCocane =
    Autofarming:Toggle(
    "Kill Coconut Crab",
    function(state)
        killcoconut = state
    end
)

local function killCoco()
    local isConnected = true

    local cT = workspace.Territories.CoconutTerritory

    local plr = game.Players.LocalPlayer

    local hipHeight =
        plr.Character.Humanoid.HipHeight +
        ((plr.Character.LeftLowerLeg.Size.Y + plr.Character.LeftLowerLeg.Size.Y) or (plr.Character.LeftLeg.Size.Y)) *
            0.5

    local BottomY = 94.0214996
    local TopY = 105.5
    local CapY = cT.CFrame.Position.Y + cT.Size.Y / 2 + hipHeight

    local function createPart(y, name)
        if not workspace:FindFirstChild(name) then
            part = Instance.new("Part", workspace)
            part.Name = name
            part.Anchored = true

            part.Transparency = 0.95

            part.CFrame = cT.CFrame - Vector3.new(0, cT.CFrame.Position.Y - y, 0)

            part.Size = Vector3.new(cT.Size.X, 1, cT.Size.Z)

            part.BottomSurface = Enum.SurfaceType.Smooth
            part.TopSurface = Enum.SurfaceType.Smooth
        end
    end

    local prefix = "CoconutCrabV4"

    local function createP(y, level)
        createPart(y, prefix .. level)
    end

    createP(BottomY, "Bottom")
    createP(TopY, "Top")
    createP(CapY, "Cap")

    --dist from humanoidrootpart and floor = 3.9471894

    local function phase2()
        for _, v in pairs(workspace.Particles:GetChildren()) do
            if v.Name == "WarningDisk" then
                if v.Size.X == 40 then
                    return true
                end
            end
        end
        return false
    end

    local function crabLoop()
        if killcoconut and ((not disableAutofarmOnMultiplePeople) or #game.Players:GetPlayers() == 1) then
            coconut = true
            local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
            p = rootPart.CFrame.Position
            if workspace.Monsters:FindFirstChild("Coconut Crab (Lvl 12)") then
                if phase2() and math.abs(p.y - TopY) > hipHeight then
                    rootPart.CFrame = CFrame.new(p.X, TopY + hipHeight, p.Z)
                elseif (not (phase2())) and math.abs(p.Y - BottomY) > hipHeight then
                    rootPart.CFrame = CFrame.new(p.X, BottomY + hipHeight, p.Z)
                end
            end
        else
            coconut = false
        end
    end

    return crabLoop
end

local cocoLoop = killCoco()

local killStickbug = false

local stickbugButton =
    Autofarming:Toggle(
    "Auto Stickbug",
    function(s)
        killStickbug = s
    end
)

local function killBug()
    if not killStickbug or (disableAutofarmOnMultiplePeople and #game.Players:GetPlayers() ~= 1) then
        return
    end
    local bug = nil
    for _, m in pairs(workspace.Monsters:GetChildren()) do
        if m.Name:match("Stick Bug") then
            bug = m
            break
        end
    end
    if
        bug and bug.HumanoidRootPart.Position.Y < 300 and
            not game.Players.LocalPlayer.Character:FindFirstChild("Splinter Trap")
     then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            CFrame.new(bug.HumanoidRootPart.CFrame.Position) + Vector3.new(0, 25, 0)
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
    end
    if
        not game.Players.LocalPlayer.Character:FindFirstChild("Splinter Trap") and
            workspace.Particles:FindFirstChild("PollenHealthBar")
     then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Particles.PollenHealthBar.CFrame
    end
end

game.Players.LocalPlayer.Character.ChildAdded:Connect(
    function(child)
        if child.Name == "Splinter Trap" and killbug then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame -
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position +
                workspace.FlowerZones["Dandelion Field"].CFrame.Position
        end
    end
)

Autofarming:Toggle(
    "Auto-Teleport to Sprouts",
    function(a)
        game:GetService("Workspace").Particles.Folder2.ChildAdded:Connect(
            function(child)
                if string.find(child.Name, "Sprout") and a == true then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(child.CFrame.Position + Vector3.new(0, 35, 0))
                end
            end
        )
    end
)

local killsnail = false

local SnailButton =
    Autofarming:Toggle(
    "Kill Snail",
    function(s)
        killsnail = s
        if s then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                workspace.FlowerZones["Stump Field"].CFrame
        end
    end
)

local function snailButton()
    local plr = game:GetService("Players").LocalPlayer

    local snailCurrp = nil
    local target = nil
    local collectDist = 40

    local inactiveBuffer = 0.05
    local inactiveTransparency = 0.7

    local function isActive(v)
        return not ((v.Transparency + inactiveBuffer) > inactiveTransparency and
            (v.Transparency - inactiveBuffer) < inactiveTransparency) and v.Orientation.Z < 1
    end

    local theSnail = nil

    local function getSnail()
        if theSnail ~= nil and theSnail.Parent ~= nil then
            return theSnail
        end
        for _, v in pairs(workspace.Monsters:GetChildren()) do
            if v.Name == "Stump Snail (Lvl 6)" then
                if
                    v:FindFirstChild("Target") and v:FindFirstChild("Target").Value and
                        v:FindFirstChild("Target").Value.Name == plr.Name
                 then
                    theSnail = v
                    return v
                end
            end
        end
        return nil
    end

    local function snailvalid(v)
        local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        return isActive(v) and (root.Position - v.Position).Magnitude < collectDist and
            (theSnail.Torso.Position - v.Position).Magnitude > 20
    end

    local snail = function()
        if not killsnail or (disableAutofarmOnMultiplePeople and #game.Players:GetPlayers() ~= 1) then
            snailCurrp = nil
            return
        end
        getSnail()
        if
            theSnail == nil or
                not (plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") and
                    plr.Character:FindFirstChildWhichIsA("Humanoid").RootPart)
         then
            return
        end
        local root = plr.Character:FindFirstChildWhichIsA("Humanoid").RootPart
        root.CFrame = CFrame.lookAt(root.CFrame.p, theSnail.Torso.CFrame.p)

        snailCurrp = snailCurrp or root.CFrame
        if target ~= nil then
            if target.Parent == nil or target.Orientation.Z > 1 then
                target = nil
                root.CFrame = snailCurrp
            end
        end
        local token = nil
        for _, v in pairs(workspace.Collectibles:GetChildren()) do
            if v.FrontDecal.Texture == getTokenIcon("Token Link") and snailvalid(v) then
                token = v
                break
            end
        end
        if token == nil then
            for _, v in pairs(workspace.Collectibles:GetChildren()) do
                if snailvalid(v) then
                    token = v
                    break
                end
            end
        end
        target = target or token
        if target ~= nil then
            root.CFrame = root.CFrame - root.CFrame.Position + target.CFrame.Position
        end
    end

    return snail
end

local snail = snailButton()

local mondo = false
local KillMondo =
    Autofarming:Toggle(
    "Kill Mondo Chick",
    function(state)
        mondo = state

        while mondo do
            wait()
            mondoAlive = false
            if workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") then
                mondoAlive = true
                local uTorso = workspace:WaitForChild(game.Players.LocalPlayer.Name).HumanoidRootPart
                uTorso.CFrame = CFrame.new(76.0186844, 207.248322, -167.660995)
                noclip = true
            else
                noclip = false
            end
        end
        --[[else
      mondo = false
      noclip = false
end]]
    end
)

local killvici = false
local vici = false

local KillVic =
    Autofarming:Toggle(
    "Auto-Kill Vicious Bee",
    function(state)
        ViciStats = state
        killvici = state
    end
)

local viciO = false

local function killViciousBeeFunc()
    if not killvici or (disableAutofarmOnMultiplePeople and #game.Players:GetPlayers() ~= 1) then
        return
    end
    if not vici then
        viciO = noclip
    end
    local viciB = vici
    vici = false
    for _, v in pairs(workspace.Particles:GetChildren()) do
        if string.find(v.Name, "Waiting Thorn") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        end
    end
    for _, v in pairs(workspace.Monsters:GetChildren()) do
        if string.find(v.Name, "Vici") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(v.Torso.CFrame.Position + Vector3.new(0, 13, 0))
            vici = true
        end
    end
    if vici == false and viciB == true then
        noclip = viciO
    end
end

local tpwindy = false

local KillWind =
    Autofarming:Toggle(
    "Auto-Kill Windy Bee",
    function(state)
        WindyStats = state
        tpwindy = state
    end
)

local wind = false

local windO = false

function windyToken()
    local maxSizeTokens = 50

    local inactiveTransparencyTokens = 0.7
    local inactiveBufferTokens = 0.05

    local function isActiveTokens(v)
        return not ((v.Transparency + inactiveBufferTokens) > inactiveTransparencyTokens and
            (v.Transparency - inactiveBufferTokens) < inactiveTransparencyTokens)
    end

    local function validToken(v)
        local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        return v.Parent ~= nil and v.Orientation.Z < 1 and isActiveTokens(v) and
            (root.CFrame.Position - v.CFrame.Position).Magnitude < maxSizeTokens --[[and (token == nil or (root.CFrame.Position-v.CFrame.Position).Magnitude < (root.CFrame.Position-token.CFrame.Position).Magnitude)]] and
            not killsnail
    end

    local target = nil
    return function()
        local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        if target ~= nil then
            if target.Parent == nil or target.Orientation.Z > 1 then
                target = nil
            end
        end
        local token = nil
        local flag1 = false
        for _, v in pairs(workspace.Collectibles:GetChildren()) do
            if v.FrontDecal.Texture == getTokenIcon("Token Link") and validToken(v) then
                token = v
                flag1 = true
                break
            end
        end
        if flag1 == false then
            for _, v in pairs(workspace.Collectibles:GetChildren()) do
                if validToken(v) then
                    token = v
                    break
                end
            end
        end
        target = target or token
        if target ~= nil then
            root.CFrame = target.CFrame
        end
    end
end

local windyBeeTokens = windyToken()

local function killWindyBeeFunc()
    if not tpwindy or (disableAutofarmOnMultiplePeople and #game.Players:GetPlayers() ~= 1) then
        return
    end
    if not wind then
        windO = noclip
    end
    local windB = wind
    wind = false
    local addAmt = 0
    local flag1 = false
    --"<windybeemonster>.Immune.Value == true" means tokens
    --local windBattleStarted = false
    for _, v in pairs(workspace.Monsters:GetChildren()) do
        if string.find(v.Name, "Windy") then
            --windBattleStarted = true
            addAmt = 22.5
            if v.Immune.Value == true then
                windyBeeTokens()
                flag1 = true
            end
        end
    end
    for _, v in pairs(workspace.NPCBees:GetChildren()) do
        if string.find(v.Name, "Windy") then
            if not flag1 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    CFrame.new(v.CFrame.Position + Vector3.new(0, addAmt, 0))
            end
            wind = true
        end
    end
    if wind == false and windB == true then
        noclip = windO
    end
end

local autofarmDisableButton =
    Autofarming:Toggle(
    "Disable on >1 Player",
    function(d)
        DsiableUnder1Stats = d
        disableAutofarmOnMultiplePeople = d
    end
)
AutoQuestToggle =
    Autofarming:Toggle(
    "Auto-Quest",
    function(state)
        autoquest = state
    end)

local KillMondo =
    Autofarming:Toggle(
    "Kill King Beetle",
    function(state)
        local mondo = state
        while mondo do
            wait()
            mondoAlive = false
            for _, v in pairs(workspace.Monsters:GetChildren()) do
                if string.find(v.Name, "King B") then
                    if mondo == false then
                        noclip = false
                    end
                    mondoAlive = true
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(v.Torso.CFrame.Position + Vector3.new(0, 13, 0))
                    noclip = true
                end
            end
        end
    end
)

local function Tween(time, pos)
    workspace.Gravity = 0
    local tw =
        game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = pos}
    )
    tw:Play()
    tw.Completed:Wait()
    workspace.Gravity = 196.19999694824
end

local currentField = workspace.FlowerZones["Dandelion Field"]
local TempField = currentField
local fields = {}

for n, f in pairs(workspace.FlowerZones:GetChildren()) do
    fields[f.ID.Value] = f.Name
end

local tpsDropdown =
    fieldTPs:Dropdown(
    "Select a field",
    fields,
    function(f)
        currentField = workspace.FlowerZones[f]
        TempField = currentField
    end
)

local btn =
    fieldTPs:Button(
    "Teleport to Selected Field",
    function()
        local plr = game.Players.LocalPlayer
        local hipHeight =
            plr.Character.Humanoid.HipHeight +
            ((plr.Character.LeftLowerLeg.Size.Y + plr.Character.LeftLowerLeg.Size.Y) or (plr.Character.LeftLeg.Size.Y)) *
                0.5
        local pos =
            plr.Character.HumanoidRootPart.CFrame - plr.Character.HumanoidRootPart.CFrame.Position +
            currentField.Position +
            Vector3.new(0, hipHeight, 0)
        Tween(0.5, pos)
    end
)

local function DoThe()
    for i,v in pairs(game:GetService("Workspace").NPCs:GetDescendants()) do
    if string.lower(v.Name) == "alertpos" then
        if v.Parent.Parent.Name == "Gummy Bear" then
        
        else
        if v.AlertGui.ImageLabel.ImageTransparency == 0 then
            
            local HeldPoint = v.Parent.Position
                        
            repeat
            
            v.Parent.CanCollide = false
            
            wait(0.1)
            
            v.Parent.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0,3,0)
            
            wait(0.1)
            
            
            keypress(0x45)
            
            wait(0.1)
            
            keyrelease(0x45)
            
            wait(0.1)
        until game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.Visible == true

repeat
    
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click)) do
   v:Fire()
   wait(0.08)
end
until game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.Visible == false

v.Parent.Position = HeldPoint
v.Parent.CanCollide = true

            end
        end
    end
    end
end

local function AutoQuest()
    if autoquest == true then
        QuestTimer = QuestTimer + 1
        if QuestTimer == 160 then
            DoThe()
            QuestTimer = 1
        end
    end
end

local collectTokenTypeActive = false

local disableAutoFarm = false

local function autoFarmV2()
    local main = Autofarming2



    local function enum(tab)
        local e = {}
        for _, v in pairs(tab) do
            e[v] = _
        end
        return e
    end

    local typestable = {"Teleport", "Walking", "Slow Tweening", "Fast Tweening"}

    local movetypes = enum(typestable)

    local movetype = movetypes.Walk
    local tweening = false --tween thing
    local pollen = false --autosell
    local tokens = false --autocollect tokens
    local dig = false --autodig
    local sprinklers = false --autosprinklers
    local coconuts = false --auto-catch coconuts
    local lights = false --auto-catch lights
    local bubbles = false --auto-pop bubbles
    local field = false --tp to highest field
    local field2 = false --tp to selected field (in fieldTPs)
    local autooff = false --deactivate when there's another player, so you dont get reported

    --adjustable move types

    local function Tween(time, pos)
        if not tweening then
            tweening = true
            noclip = true
            local oGravity = workspace.Gravity
            workspace.Gravity = 0
            local r = game.Players.LocalPlayer.Character.HumanoidRootPart
            local cf = pos
            if typeof(pos) ~= "CFrame" then
                cf = r.CFrame - r.CFrame.Position + pos
            end
            local tw =
                game:GetService("TweenService"):Create(r, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cf})
            tw:Play()
            tw.Completed:Wait()
            workspace.Gravity = oGravity
            wait()
            noclip = false
            tweening = false
        end
    end

    local function moveto(vec)
        local char = game.Players.LocalPlayer.Character
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if movetype == movetypes.Teleport then
            local r = humanoid.RootPart
            if vec then
                r.CFrame = r.CFrame - r.CFrame.Position + vec
            end
        elseif movetype == movetypes.Walk then
            if (vec - humanoid.RootPart.CFrame.p).Magnitude > 3 and vec then
                humanoid:MoveTo(vec)
            end
        elseif movetype == movetypes.FastTween and vec then
            Tween(0.03125, vec)
        elseif movetype == movetypes.SlowTween and vec then
            Tween(1, vec)
        end
    end

    --auto convert stuff
    local player = game:GetService("Players").LocalPlayer

    local selling = false

    local function getPollen()
        return game.Players.LocalPlayer.CoreStats.Pollen.Value
    end

    local function getMaxPollen()
        return game.Players.LocalPlayer.CoreStats.Capacity.Value
    end

    local function stoppedConverting()
        for _, v in pairs(workspace.Particles:GetChildren()) do
            if
                v.Name == "HoneyBeam" and v["Attachment1"] ~= nil and
                    v.Attachment1:IsDescendantOf(game.Players.LocalPlayer.Character)
             then
                return false
            end
        end
        return true
    end

    local function sell()
        --sell honey textbutton is just called "TextBox"
        -- it is player.PlayerGui.ScreenGui.ActivateButton.TextBox
        local prevPos = player.Character.HumanoidRootPart.CFrame
        local movetopos =
            CFrame.new(
            player.Honeycomb.Value.Platform.Value.Circle.CFrame.p +
                Vector3.new(
                    0,
                    player.Character.Humanoid.HipHeight,
                    player.Honeycomb.Value.Platform.Value.Circle.Size.Z / 2 - 2
                )
        ) * CFrame.Angles(0, math.rad(180), 0)
        player.Character:SetPrimaryPartCFrame(movetopos)
        wait(0.25)
        game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
        repeat
            wait()
            if
                (player.Character.HumanoidRootPart.CFrame.Position - movetopos.p).Magnitude >
                    player.Honeycomb.Value.Platform.Value.Circle.Size.Z / 2
             then
                player.Character:SetPrimaryPartCFrame(movetopos)
                wait(0.25)
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
                wait(0.25)
            end
            if player.PlayerGui.ScreenGui.ActivateButton.TextBox.Text == "Make Honey" then
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
                wait(2)
            --player.PlayerGui.ScreenGui.ActivateButton.TextBox:GetPropertyChangedSignal("Text"):Wait()
            end
        until getPollen() < 1 and stoppedConverting()
        wait()
        player.Character.HumanoidRootPart.CFrame = prevPos
        game:GetService("RunService").Heartbeat:Wait()
        selling = false
    end

    local function autoSell()
        if getPollen() + 1 > getMaxPollen() and (not selling) and pollen then
            selling = true
            sell()
        end
    end

    --token stuff

    local maxSizeTokens = 50

    local inactiveTransparencyTokens = 0.7
    local inactiveBufferTokens = 0.05

    local function isActiveTokens(v)
        return --[[v.DataCost ~= 32]] not ((v.Transparency + inactiveBufferTokens) > inactiveTransparencyTokens and
            (v.Transparency - inactiveBufferTokens) < inactiveTransparencyTokens)
    end

    local function validToken(v)
        local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        return v.Parent ~= nil and v.Orientation.Z < 1 and isActiveTokens(v) and
            (root.CFrame.Position - v.CFrame.Position).Magnitude < maxSizeTokens --[[and (token == nil or (root.CFrame.Position-v.CFrame.Position).Magnitude < (root.CFrame.Position-token.CFrame.Position).Magnitude)]] and
            not killsnail
    end

    local target = nil
    local currp = nil
    local function moveToTokens()
        if not tokens then
            currp = nil
            return
        end
        local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        if target ~= nil then
            if target.Parent == nil or target.Orientation.Z > 1 then
                target = nil
                moveto(currp)
                currp = nil
            end
        end
        if target == nil then
            currp = nil
        end
        currp = currp or root.CFrame.Position
        local token = nil
        local flag1 = false
        for _, v in pairs(workspace.Collectibles:GetChildren()) do
            if v.FrontDecal.Texture == getTokenIcon("Token Link") and validToken(v) then
                token = v
                flag1 = true
                break
            end
        end
        if flag1 == false then
            for _, v in pairs(workspace.Collectibles:GetChildren()) do
                if validToken(v) then
                    token = v
                    break
                end
            end
        end
        target = target or token
        if target ~= nil then
            moveto(target.CFrame.Position)
        end
    end

    local function collectTokens()
        if --[[not movingTokens and tokens and]] not selling then
            moveToTokens()
        end
    end

    --autodig
    local function autoDig()
        if dig then
            if
                game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool") and
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild(
                        "ClickEvent"
                    )
             then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild(
                    "ClickEvent"
                ):FireServer()
            end
        end
    end

    --autosprinkler

    local sprinklerCounter = 0
    local sprinklerDelay = 1

    local sprinklerAvailable = true

    local function autoSprinkler()
        if sprinklers and sprinklerAvailable then
            sprinklerAvailable = false
            local sStats =
                require(game:GetService("ReplicatedStorage").Sprinklers).Get(
                require(game:GetService("ReplicatedStorage").ClientStatCache).Get().EquippedSprinkler
            )
            sprinklerDelay = sStats.Rate / sStats.Count
            -- + math.ceil(sStats.ActivationDelay / (sStats.Rate / sStats.Count))*(sStats.Rate / sStats.Count)
            game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
        end
    end

    --tp to highest field
    local beesToFieldName = {
        [0] = "Clover Field",
        [5] = "Spider Field",
        [10] = "Pineapple Patch",
        [15] = "Pumpkin Patch",
        [25] = "Mountain Top Field",
        [35] = "Pepper Patch"
    }

    local function thirtyFiveBeeZoneMax()
        if workspace.MonsterSpawners.CoconutCrab.TimerAttachment.TimerGui.TimerLabel.Visible then
            return "Coconut Field"
        else
            return "Pepper Patch"
        end
    end

    local function tenBeeZoneMax()
        if workspace.MonsterSpawners.StumpSnail.TimerAttachment.TimerGui.TimerLabel.Visible then
            return "Stump Field"
        else
            return "Pineapple Patch"
        end
    end

    local function beesToCFrame(bees)
        local cframe = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
        local highest = 0
        beesToFieldName[10] = tenBeeZoneMax()
        beesToFieldName[35] = thirtyFiveBeeZoneMax()
        for b, n in pairs(beesToFieldName) do
            if bees >= b and b >= highest then
                cframe = workspace.FlowerZones[n].CFrame
                highest = b
            end
        end
        local plr = game.Players.LocalPlayer
        local hipHeight =
            plr.Character.Humanoid.HipHeight +
            ((plr.Character.LeftLowerLeg.Size.Y + plr.Character.LeftLowerLeg.Size.Y) or (plr.Character.LeftLeg.Size.Y)) *
                0.5
        return cframe.Position + Vector3.new(0, hipHeight, 0)
    end

    local function tpToMaxField()
        local bees = 0
        for _, v in pairs(game.Players.LocalPlayer.Honeycomb.Value.Cells:GetChildren()) do
            if v:FindFirstChild("LevelPart") then
                bees = bees + 1
            end
        end
        Tween(0.5, beesToCFrame(bees))
    end

    local tping = false

    local tpAvailable = true

    local function fieldTP()
        if tpAvailable and field and not selling then
            tping = true
            tpToMaxField()
            wait(0.5)
            tpAvailable = false
            tpCounter = 0
            tping = false
        end
    end

    local tpCounter = 0
    local tpDelay = 15

    --tp to selected field

    local function tpToSelectedField()
        local plr = game.Players.LocalPlayer
        local hipHeight =
            plr.Character.Humanoid.HipHeight +
            ((plr.Character.LeftLowerLeg.Size.Y + plr.Character.LeftLowerLeg.Size.Y) or (plr.Character.LeftLeg.Size.Y)) *
                0.5
        Tween(0.5, TempField.CFrame.Position + Vector3.new(0, hipHeight, 0))
    end

    local tping2 = false
    local tpAvailable2 = true

    local function fieldTP2()
        if tpAvailable2 and field2 and not selling then
            tping2 = true
            tpToSelectedField()
            wait(0.5)
            tpAvailable2 = false
            tpCounter2 = 0
            tping2 = false
        end
    end

    local tpCounter2 = 0
    local tpDelay2 = 15

    --auto catch stuff
    local catching = false
    local function catch(targetSize)
        catching = false
        if not (coconuts or lights) then
            return
        end
        local target = nil
        for _, v in pairs(workspace.Particles:GetChildren()) do
            if
                v.Parent ~= nil and v.Name == "WarningDisk" and v.Color and v.Color.R < v.Color.G and
                    (target == nil or (v.Transparency < target.Transparency)) and
                    math.abs(v.Size.X - targetSize) < 5
             then
                target = v
            end
        end
        if target ~= nil then
            catching = true
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame -
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position +
                (target.CFrame.Position)
        end
    end

    --auto-pop bubbles
    local popping = false
    local popDist = 40
    local bcurrp = nil
    local targetBubble = nil
    local function pop()
        --game.Workspace.Particles.Bubble
        popping = false
        if not bubbles then
            return
        end
        local target = nil
        local root = game.Players.LocalPlayer.Character.HumanoidRootPart
        if targetBubble ~= nil and targetBubble.Parent == nil then
            targetBubble = nil
            moveto(bcurrp)
            bcurrp = nil
        end
        if targetBubble == nil then
            bcurrp = nil
        end
        bcurrp = bcurrp or root.CFrame.Position
        for _, v in pairs(workspace.Particles:GetChildren()) do
            if v.Name == "Bubble" and v.CFrame ~= nil and (v.CFrame.Position - bcurrp).Magnitude < popDist then
                target = v
            end
        end
        targetBubble = targetBubble or target
        if targetBubble ~= nil then
            popping = true
            moveto(targetBubble.CFrame.Position)
        end
    end

    local Loop = function(step)
        local off = false
        local windyAlive = false
        for _, v in pairs(game.workspace.NPCBees:GetChildren()) do
            if string.find(v.Name, "Windy") then
                windyAlive = true
            end
        end
        disableAutoFarm =
            vici or (mondo and workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") ~= nil) or
            (windyAlive and tpwindy) or
            coconut
        if disableAutoFarm then
            return
        end
        off = (autooff and (not (#game.Players:GetPlayers() == 1)))
        if not off then
            autoSell()
            autoDig()
            if not collectTokenTypeActive then
                autoSprinkler()
                fieldTP()
                fieldTP2()
                if not selling and not tping and not tping2 then
                    if coconuts then
                        catch(30)
                    end
                    if bubbles and not catching then
                        pop()
                    end
                    if not catching and not popping then
                        if not killsnail then
                            collectTokens()
                        end
                    end
                end
            end
        end
        sprinklerCounter = sprinklerCounter + step
        if sprinklerCounter > sprinklerDelay then
            sprinklerCounter = sprinklerCounter - sprinklerDelay
            sprinklerAvailable = true
        end
        tpCounter = tpCounter + step
        while tpCounter > tpDelay do
            tpCounter = tpCounter - tpDelay
            tpAvailable = true
        end
        tpCounter2 = tpCounter2 + step
        while tpCounter2 > tpDelay2 do
            tpCounter2 = tpCounter2 - tpDelay2
            tpAvailable2 = true
        end
    end

    local MoveTypeButton =
        main:Dropdown(
        "Move type: ",
        typestable,
        function(t)
            movetype = movetypes[t]
        end
    )

    local PollenButton =
        main:Toggle(
        "Auto-Convert Pollen",
        function(p)
            pollen = p
        end,
        pollen
    )

    local TokenButton =
        main:Toggle(
        "Auto-Collect Tokens",
        function(t)
            currp = nil
            tokens = t
        end,
        tokens
    )

    local DigButton =
        main:Toggle(
        "Auto Dig",
        function(d)
            dig = d
        end,
        dig
    )

    local CoconutsButton =
        main:Toggle(
        "Auto-Catch Coconuts",
        function(c)
            coconuts = c
        end,
        coconuts
    )

    local BubblesButton =
        main:Toggle(
        "Auto-Pop Bubbles",
        function(b)
            bubbles = b
        end,
        bubbles
    )

    local FieldButton2 =
        main:Toggle(
        "Auto-Teleport to Selected Field",
        function(f)
            field2 = f
        end,
        field2
    )

    local OffButton =
        main:Toggle(
        "Deactivate on >1 player",
        function(o)
            autooff = o
        end,
        autooff
    )
    
      local toggleDevsPick =
    main:Button(
    "Autofarm (Schervi's Pick (Its Shit) )",
    function()
        PollenButton:SetTo(true)
        TokenButton:SetTo(true)
        DigButton:SetTo(true)
        CoconutsButton:SetTo(true)
        BubblesButton:SetTo(true)
    end
)

    

    return Loop
end

local autoFarmV2Loop = autoFarmV2()

local function collectTokenType(texture, name)
    local collectOn = false

    local currp = nil
    local toggleButton =
        Autofarming:Toggle(
        "Auto-Collect " .. name,
        function(on)
            collectOn = on
            if not on then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currp
                currp = nil
            end
        end
    )

    local targetTexture = texture

    local inactiveTransparencyTokens = 0.7
    local inactiveBufferTokens = 0.05

    local function isActiveTokens(v)
        return --[[v.DataCost ~= 32]] not ((v.Transparency + inactiveBufferTokens) > inactiveTransparencyTokens and
            (v.Transparency - inactiveBufferTokens) < inactiveTransparencyTokens)
    end

    local target = nil
    local function moveToTokens()
        local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        if target ~= nil then
            if target.Parent == nil or target.Orientation.Z > 1 then
                target = nil
                root.CFrame = currp
                currp = nil
            end
        end
        if target == nil then
            currp = nil
        end
        currp = currp or root.CFrame
        local token = nil
        for _, v in pairs(workspace.Collectibles:GetChildren()) do
            if
                v.Parent ~= nil and v.Orientation.Z < 1 and isActiveTokens(v) and v.FrontDecal and
                    v.FrontDecal.Texture == targetTexture and
                    ((token == nil) or (v.Transparency > token.Transparency))
             then
                token = v
            end
        end
        target = target or token
        if target ~= nil and not collectTokenTypeActive then
            collectTokenTypeActive = true
            root.CFrame = root.CFrame - root.CFrame.Position + target.CFrame.Position
        end
    end

    return function()
        if --[[#game.Players:GetPlayers() ~= 1 or ]] collectOn == false then
            return
        end
        moveToTokens()
    end
end

local function PrioritiseToken(texture, name)
    local collectOn = false

    local currp = nil
    local toggleButton =
        Autofarming2:Toggle(
        "Prioritise " .. name .. " Tokens",
        function(on)
            collectOn = on
            if not on then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currp
                currp = nil
            end
        end
    )

    local targetTexture = texture

    local inactiveTransparencyTokens = 0.7
    local inactiveBufferTokens = 0.05

    local function isActiveTokens(v)
        return --[[v.DataCost ~= 32]] not ((v.Transparency + inactiveBufferTokens) > inactiveTransparencyTokens and
            (v.Transparency - inactiveBufferTokens) < inactiveTransparencyTokens)
    end

    local target = nil
    local function moveToTokens()
        local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        if target ~= nil then
            if target.Parent == nil or target.Orientation.Z > 1 then
                target = nil
                root.CFrame = currp
                currp = nil
            end
        end
        if target == nil then
            currp = nil
        end
        currp = currp or root.CFrame
        local token = nil
        for _, v in pairs(workspace.Collectibles:GetChildren()) do
            if
                v.Parent ~= nil and v.Orientation.Z < 1 and isActiveTokens(v) and v.FrontDecal and
                    v.FrontDecal.Texture == targetTexture and
                    ((token == nil) or (v.Transparency > token.Transparency))
             then
                token = v
            end
        end
        target = target or token
        if target ~= nil and not collectTokenTypeActive then
            collectTokenTypeActive = true
            root.CFrame = root.CFrame - root.CFrame.Position + target.CFrame.Position
        end
    end

    return function()
        if --[[#game.Players:GetPlayers() ~= 1 or ]] collectOn == false then
            return
        end
        moveToTokens()
    end
end

-- tvk1308 Place:
local QuestF = game.Players.LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests.Content
function GetFieldByName(name)
    return game.Workspace.FlowerZones[name]
end
local TimerMob = {
    ["Rhino Beetles"] = {"Rhino Bush", "Rhino Cave 1", "Rhino Cave 2", "Rhino Cave 3", "PineappleBeetle"},
    ["Spider"] = {"Spider Cave"},
    ["Werewol"] = {"WerewolfCave"},
    ["Scorpion"] = {"RoseBush", "RoseBush2"},
    ["Mantises"] = {"ForestMantis1", "ForestMantis2", "PineappleMantis1"},
    ["Ladybug"] = {"MushroomBush", "Ladybug Bush", "Ladybug Bush 2", "Ladybug Bush 3"}
}
local fieldlistpolar = {
    "Spider Field",
    "Mushroom Field",
    "Rose Field",
    "Strawberry Field",
    "Bamboo Field",
    "Pumpkin Patch",
    "Sunflower Field",
    "Cactus Field",
    "Blue Flower Field",
    "Clover Field",
    "Pineapple Patch",
    "Dandelion Field",
    "Pine Tree Forest"
}
local moblistpolar = {
    "Spider",
    "Scorpion",
    "Werewol",
    "Mantises",
    "Ladybug",
    "Rhino Beetles"
}
local BlackBearQuest = {
    "Sunflower Start",
    "Dandelion Deed",
    "Pollen Fetcher",
    "Red Request",
    "Into The Blue",
    "Variety Fetcher",
    "Bamboo Boogie",
    "Red Request 2",
    "Cobweb Sweeper",
    "Leisure Loot",
    "White Pollen Wrangler",
    "Pineapple Picking",
    "Pollen Fetcher 2",
    "Weed Wacker",
    "Red + Blue = Gold",
    "Colorless Collection",
    "Spirit Of Springtime",
    "Weed Wacker 2",
    "Pollen Fetcher 3",
    "Lucky Landscaping",
    "Azure Adventure",
    "Pink Pineapples",
    "Blue Mushrooms",
    "Cobweb Sweeper 2",
    "Rojo-A-Go-Go",
    "Rojo-A-Go-Go",
    "Pollen Fetcher 4",
    "Bouncing Around Biomes",
    "Blue Pineapples",
    "Rose Request",
    "Search For The White Clover",
    "Stomping Grounds",
    "Collecting Cliffside",
    "Mountain Meandering",
    "Quest Of Legends",
    "High Altitude",
    "Blissfully Blue",
    "Rouge Round-up",
    "White As Snow",
    "Solo On The Stump",
    "Colorful Craving",
    "Pumpkins, Please!",
    "Smorgasbord",
    "Pollen Fetcher 5",
    "White Clover Redux",
    "Strawberry Field Forever",
    "Tasting The Sky",
    "Whispy and Crispy",
    "Walk Through The Woods",
    "Get Red-y",
    "One Stop On The Tip Top",
    "Blue Mushrooms 2",
    "Pretty Pumpkins",
    "Black Bear, Why?",
    "Bee A Star",
    "Bamboo Boogie 2: Bamboo Boogaloo",
    "Rocky Red Mountain",
    "Can't Without Ants",
    "The 15 Bee Zone",
    "Bubble Trouble",
    "Sweet And Sour",
    "Rare Red Clover",
    "Low Tier Treck",
    "Okey-Pokey",
    "Pollen Fetcher 6",
    "Capsaicin Collector",
    "Mountain Mix",
    "You Blue It",
    "Variety Fetcher 2",
    "Getting Stumped",
    "Weed Wacker 3",
    "All-Whitey Then",
    "Red Delicacy",
    "Boss Battles",
    "Myth In The Making"
}
function GetListField()
    local tablee = {}
    for k, v in pairs(game.Workspace.FlowerZones:GetChildren()) do
        table.insert(tablee, v.Name)
    end
    return tablee
end
function GetQuest(name)
    if QuestF:FindFirstChild("Frame") then
        for k, v in pairs(QuestF.Frame:GetChildren()) do
            if v:IsA("Frame") then
                if name == "Black Bear" then
                    for f, s in pairs(BlackBearQuest) do
                        if string.match(string.lower(v.TitleBar.Text), string.lower(s)) or v.TitleBar.Text == s then
                            
                            return v
                        end
                    end
                end
            end
        end
        for k, v in pairs(QuestF.Frame:GetChildren()) do
            if v:IsA("Frame") then
                if string.match(v.TitleBar.Text, name) then
                    return v
                -- print(v.TitleBar.Text)
                end
            end
        end
    end
end
function GetPolarQuest()
    if QuestF:FindFirstChild("Frame") then
        for k, v in pairs(QuestF.Frame:GetChildren()) do
            if v:IsA("Frame") then
                if string.match(v.TitleBar.Text, "Polar") then
                    if string.match(v.TitleBar.Text, "Polar Bear's Beesmas Feast") then
                        --return v
                    else
                        return v
                    end
                print(v.TitleBar.Text)
                end
            end
        end
    end
end
function IsQuestDone(Quest)
    if Quest:FindFirstChild("Description") then
        if string.match(Quest.Description.Text, "Complete") then
            return true
        else
            return false
        end
    else
        return true
    end
end
function GetQuestField(Quest)
    for k, v in pairs(GetListField()) do
        if string.match(Quest, v) then
            --print(v)
            return GetFieldByName(v)
        end
    end
end
function GetQuestMob(Quest)
    for k, v in pairs(moblistpolar) do
        if string.match(Quest, v) then
            --print(v)
            return v
        end
    end
end
function GetMobIns(Mob)
    return game.Workspace.MonsterSpawners[Mob]
end
function CheckMob(Mob)
    for k, v in pairs(TimerMob[Mob]) do
        local t = GetMobIns(v)
        if GetAttach(t).TimerGui.TimerLabel.Visible == false then
            return t
        end
    end
end
function GetAttach(Mob)
    local Att = Mob:FindFirstChild("Attachment")
    if Att then
        return Att
    else
        return Mob:FindFirstChild("TimerAttachment")
    end
end
function GetNerestFieldByObject(Obj)
    local lis = GetListField()
    local old = "Sunflower Field"
    for k, v in pairs(lis) do
        if v then
            if
                (Obj.Position - GetFieldByName(v).Position).magnitude <
                    (Obj.Position - GetFieldByName(old).Position).magnitude
             then
                old = v
            end
        end
    end
    return GetFieldByName(old)
end

spawn(
    function()
        while wait() do
            for kiet,questname in pairs(QuestList) do 
                if QuestTF[questname] then
                    local t = GetQuest(questname)
                    --print(t)
                    if t then
                        for k, v in pairs(t:GetChildren()) do
                            if v:IsA("Frame") then
                                if v:FindFirstChild("Description") then
                                    if not IsQuestDone(v) then
                                        if string.match(v.Description.Text, "Collect") then
                                            local field = GetQuestField(v.Description.Text)
                                            --print(v.Description.Text)
                                            --print(field)
                                            if field then
                                                TempField = field
                                                while (QuestTF[questname] and IsQuestDone(v) == false) do
                                                    wait()
                                                end
                                            end
                                        else
                                            if string.match(v.Description.Text, "Defeat") and not IsQuestDone(v) then
                                                local mob = CheckMob(GetQuestMob(v.Description.Text))
                                                if mob and GetAttach(mob) then
                                                    TempField = GetNerestFieldByObject(mob)
                                                    while wait() and QuestTF[questname] do
                                                        local t = tick()
    
                                                        if
                                                            GetAttach(mob).TimerGui.TimerLabel.Visible == true or
                                                                tick() - t > 20 or
                                                                IsQuestDone(v) or
                                                                not QuestTF[questname]
                                                         then
                                                            break
                                                        end
                                                    end
                                                    if QuestTF[questname] then
                                                        wait(4)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            
            end
            
            TempField = currentField
        end
    end
)

-- End  Place

local aPollenBomb = PrioritiseToken(getTokenIcon("PollenBomb"), "Pollen Bombs")
local aInspire = PrioritiseToken(getTokenIcon("Inspire"), "Inspire")
local aBeam = PrioritiseToken(getTokenIcon("Beamstorm"), "Beam Storm")
local aScratch = PrioritiseToken(getTokenIcon("Scratch"), "Scratch")
local aPulse = PrioritiseToken(getTokenIcon("Pulse"), "Pulse")
local aCV = PrioritiseToken(getTokenIcon("Conversion Link"), "Link Tokens")
local aTornado = PrioritiseToken(getTokenIcon("Tornado"), "Tornado")
local aMS = PrioritiseToken(getTokenIcon("Mark Surge"), "Mark Surge")
local aTriangulate = PrioritiseToken(getTokenIcon("Triangulate"), "Triangulate")
local aFrog = PrioritiseToken(getTokenIcon("Summon Frog"), "Frog")
local tix = collectTokenType(getTokenIcon("Ticket"), "Tickets")
local aBlueberries = collectTokenType(getTokenIcon("Blueberry"), "Blueberries")
local aStrawberries = collectTokenType(getTokenIcon("Strawberry"), "Strawberries")
local aSunflowerSeeds = collectTokenType(getTokenIcon("SunflowerSeed"), "Sunflower Seeds")
local aPineapples = collectTokenType(getTokenIcon("Pineapple"), "Pineapples")
local aCoconuts = collectTokenType(getTokenIcon("Coconut"), "Coconuts")
local aGumdrops = collectTokenType(getTokenIcon("Gumdrops"), "Gumdrops")
local aRedExtract = collectTokenType(getTokenIcon("RedExtract"), "Red Extracts")
local aBlueExtract = collectTokenType(getTokenIcon("BlueExtract"), "Blue Extracts")
local aMoonCharms = collectTokenType(getTokenIcon("MoonCharm"), "Moon Charms")
local aOil = collectTokenType(getTokenIcon("Oil"), "Oil")
local aEnzymes = collectTokenType(getTokenIcon("Enzymes"), "Enzymes")
local aGlue = collectTokenType(getTokenIcon("Glue"), "Glue")
local aTropicalDrinks = collectTokenType(getTokenIcon("TropicalDrink"), "Tropical Drinks")
local aMagicBeans = collectTokenType(getTokenIcon("MagicBean"), "Magic Beans")
local aGlitter = collectTokenType(getTokenIcon("Glitter"), "Glitter")
--local a = collectTokenType(getTokenIcon(""),"")
--local flakes = collectTokenType(getTokenIcon("Snowflake"),"Snowflakes")
--[[
local function Save()
local BSSINFO = {
LockStatsOn = LockedStatsStats,
GodModeOn = GodModeStats,
AntiAfkOn = AntiAfkStats,
ViciOn = ViciStats,
WindyOn = WindyStats,
WealthClockOn = wealthClockStats,
DisableOverOnePerson = DsiableUnder1Stats,
CurrentlyEquippedTheme = game:GetService("Players").LocalPlayer.PlayerScripts.Theme.Value
}
game:GetService("Players").PlayerRemoving:Connect(function()
    Save()
end)]]

loadstring(game:HttpGet("https://raw.githubusercontent.com/gwyig93wg9032w9g82398hg32h98g2389hfasjq/femboyhubreal/main/Loadfunctions"))()(Window,BLibrary)

local Loop = game:GetService("RunService").Heartbeat:Connect(function(step)
        --if noclip ~= noclipBox:Get() then
        --noclipBox:SetToNoCallback(noclip)
        --end
        collectTokenTypeActive = false
        tix()
        aInspire()
        aPollenBomb()
        aBeam()
        aScratch()
        aPulse()
        aCV()
        aTornado()
        aMS()
        aTriangulate()
        aFrog()
        aBlueberries()
        aStrawberries()
        aSunflowerSeeds()
        aPineapples()
        aCoconuts()
        aGumdrops()
        aRedExtract()
        aBlueExtract()
        aMoonCharms()
        aOil()
        aEnzymes()
        aGlue()
        aTropicalDrinks()
        aMagicBeans()
        aGlitter()
        snail()
        cocoLoop()
        killBug()
        killViciousBeeFunc()
        killWindyBeeFunc()
        autoFarmV2Loop(step)
        AutoQuest()
        
        
        game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        game.Players.LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        Thread:Wait(0.07)
end)

for _, part in next, workspace:FindFirstChild("FieldDecos"):GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end
for _, part in next, workspace:FindFirstChild("Decorations"):GetDescendants() do if part:IsA("BasePart") and (part.Parent.Name == "Bush" or part.Parent.Name == "Blue Flower") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end
for i,v in next, workspace.Decorations.Misc:GetDescendants() do if v.Parent.Name == "Mushroom" then v.CanCollide = false v.Transparency = 0.5 end
end
