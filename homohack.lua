--// Made by @dementia enjoyer
--// join .gg/syAGdFKAZQ for updates and more scripts like this <3 \\--

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'homohack (made by @eldmonstret / dementia enjoyer)',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--// Defined

local Camera = workspace.CurrentCamera
local Players = workspace.Players
local Ignore = workspace.Ignore
local Misc = Ignore.Misc

--// Services

local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

--// Tables

local Tabs = {
    AimbotTab = Window:AddTab('Aimbot'),
    VisualsTab = Window:AddTab('Visuals'),
    MiscTab = Window:AddTab('Misc'),
    Settings = Window:AddTab('Settings'),
}

local Sections = {
    Aimbot = Tabs.AimbotTab:AddLeftGroupbox('Aimbot'),
    Visuals = Tabs.VisualsTab:AddLeftGroupbox('Visuals'),
    VisualSettings = Tabs.VisualsTab:AddRightGroupbox('Configuration'),
    Grenade = Tabs.VisualsTab:AddLeftGroupbox('Grenades'),
    Lighting = Tabs.VisualsTab:AddRightGroupbox('Lighting'),
    Misc = Tabs.MiscTab:AddLeftGroupbox('Misc'),
    Player = Tabs.MiscTab:AddLeftGroupbox('Player'),
}

local FeatureTable = {
    Combat = {
        SilentAim = false,
        WallCheck = false,
        TeamCheck = false,
        Hitpart = 7, --// 6 = Torso, 7 = Head
    },
    Visuals = {

        --// Features \\--

        Box = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
        Tracers = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Origin = "Middle"},
        Chams = {Enabled = false, FillColor = Color3.fromRGB(255, 255, 255), OutlineColor = Color3.fromRGB(255, 255, 255), VisibleOnly = false, FillTransparency = 0, OutlineTransparency = 0},

        TeamCheck = false,
        UseTeamColor = false, --// Team colors dont apply to chams btw

        --// Other \\--

        Lighting = {
            OverrideAmbient = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
        },

        Grenade = {
            GrenadeESP = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Transparency = 0},
            TrailModifier = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), TrailLifetime = 0.55},
        }

    },
    Misc = {
        Player = {
            Bhop = false,
            JumpPowerModifier = {Enabled = false, Power = 50},
            HipHeight = 0,
        }
    },
}

local Storage = {
    Index = {
        Head = 7,
        Torso = 6,
    },
    ESP = {
        Boxes = {},
        Tracers = {},
        Chams = {},
    },
    Other = {
        ViewportSize = Camera.ViewportSize,
    },
}

local Functions = {
    Normal = {},
    ESP = {},
}

--// Objects

local FOVCircle = Drawing.new("Circle")
do --// Drawing object properties

    do --// Circle

        FOVCircle.Transparency = 1
        FOVCircle.Visible = false
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        FOVCircle.Radius = 0
        
    end
    
end

local Watermark = Instance.new("ScreenGui", game.CoreGui)
do --// Properties & Rest

    local Main = Instance.new("Frame", Watermark)
    local UICorner = Instance.new("UICorner", Main)
    local Gradient = Instance.new("Frame", Main)
    local UIGradient = Instance.new("UIGradient", Gradient)
    local TextLabel = Instance.new("TextLabel", Main)
    
    do --// Properties
        Watermark.Enabled = false
        Watermark.Name = "Watermark"
    
        Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(0.00550314458, 0, 0.00746268639, 0)
        Main.Size = UDim2.new(0.245283023, 0, 0.043532338, 0)
        
        UICorner.CornerRadius = UDim.new(0, 2)
        
        Gradient.Name = "Gradient"
        Gradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Gradient.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Gradient.BorderSizePixel = 0
        Gradient.Size = UDim2.new(1, 0, 0.0857142881, 0)
        
        UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(43, 255, 114)), ColorSequenceKeypoint.new(0.38, Color3.fromRGB(255, 112, 150)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(85, 170, 255)), ColorSequenceKeypoint.new(0.71, Color3.fromRGB(85, 36, 255)), ColorSequenceKeypoint.new(0.77, Color3.fromRGB(85, 0, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 139, 44))}
        UIGradient.Parent = Gradient
        
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.BorderSizePixel = 0
        TextLabel.Position = UDim2.new(0, 0, 0.0857142881, 0)
        TextLabel.Size = UDim2.new(1, 0, 0.914285719, 0)
        TextLabel.Font = Enum.Font.RobotoMono
        TextLabel.Text = "homohack | made by @dementia enjoyer"
        TextLabel.TextColor3 = Color3.fromRGB(247, 247, 247)
        TextLabel.TextSize = 12.000
        TextLabel.TextWrapped = true
        TextLabel.TextScaled = true
    end
end

--// Rest

do --// Main

    do --// Elements

        do --// Aimbot Tab

            Sections.Aimbot:AddToggle('SilentAim', {
                Text = 'Silent Aim',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Combat.SilentAim = Value
                end
            })

            Sections.Aimbot:AddToggle('WallCheck', {
                Text = 'Wall Check',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Combat.WallCheck = Value
                end
            })

            Sections.Aimbot:AddToggle('TeamCheck', {
                Text = 'Team Check',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Combat.TeamCheck = Value
                end
            })

            Sections.Aimbot:AddToggle('VisualiseRange', {
                Text = 'Visualise Range',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FOVCircle.Visible = Value
                end
            }):AddColorPicker('VisualiseRangeColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Range Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FOVCircle.Color = Value
                end
            })

            Sections.Aimbot:AddSlider('Range', {
                Text = 'Range',
                Default = 0,
                Min = 0,
                Max = 1000,
                Rounding = 1,
                Compact = false,
            
                Callback = function(Value)
                    FOVCircle.Radius = Value
                end
            })

            Sections.Aimbot:AddDropdown('Aimpart', {
                Values = { 'Head', 'Torso', 'Random' },
                Default = 1,
                Multi = false,
            
                Text = 'Aim Part',
                Tooltip = nil,
            
                Callback = function(Value)
                    if Storage.Index[Value] ~= nil then
                        FeatureTable.Combat.Hitpart = Storage.Index[Value]
                    else
                        FeatureTable.Combat.Hitpart = "Random"
                    end
                end
            })
    
        end

        do --// Visuals Tab

            Sections.Visuals:AddToggle('Box', {
                Text = 'Box',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Box.Enabled = Value
                end
            }):AddColorPicker('BoxColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Box Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Box.Color = Value
                end
            })

            Sections.Visuals:AddToggle('Tracers', {
                Text = 'Tracers',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Tracers.Enabled = Value
                end
            }):AddColorPicker('TracerColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Tracer Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Tracers.Color = Value
                end
            })

            Sections.Visuals:AddToggle('Chams', {
                Text = 'Chams',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Chams.Enabled = Value
                end
            }):AddColorPicker('FillColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Fill Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Chams.FillColor = Value
                end
            }):AddColorPicker('OutlineColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Outline Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Chams.OutlineColor = Value
                end
            })

            --// Settings

            Sections.VisualSettings:AddToggle('ChamsVisOnly', {
                Text = 'Chams Visible Only',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Chams.VisibleOnly = Value
                end
            })

            Sections.VisualSettings:AddToggle('TeamCheck', {
                Text = 'Team Check',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.TeamCheck = Value
                end
            })

            Sections.VisualSettings:AddToggle('TeamColors', {
                Text = 'Use Team Colors',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.UseTeamColor = Value
                end
            })

            Sections.VisualSettings:AddDropdown('TracerOrigin', {
                Values = { 'Top', 'Middle', 'Bottom', 'Gun' },
                Default = 2,
                Multi = false,
            
                Text = 'Tracer Origin',
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Tracers.Origin = Value
                end
            })

            --// Lighting Section

            Sections.Lighting:AddToggle('OverrideAmbient', {
                Text = 'Override Ambient',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Lighting.OverrideAmbient.Enabled = Value
                end
            }):AddColorPicker('AmbientColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Ambient Color',
                Transparency = 0,
            
                Callback = function(Value)
                    if FeatureTable.Visuals.Lighting.OverrideAmbient.Enabled then
                        FeatureTable.Visuals.Lighting.OverrideAmbient.Color = Value
    
                        do --// Properties
                            
                            Functions.Normal:SetAmbient("Ambient", Value)
                            Functions.Normal:SetAmbient("OutdoorAmbient", Value)
                            Functions.Normal:SetAmbient("ColorShift_Top", Value)
                            Functions.Normal:SetAmbient("ColorShift_Bottom", Value)
                            
                        end
                    end
                end
            })

            --// Grenade Section

            Sections.Grenade:AddToggle('Grenade', {
                Text = 'Grenade ESP',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Grenade.GrenadeESP.Enabled = Value
                end
            }):AddColorPicker('GrenadeColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Grenade Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Grenade.GrenadeESP.Color = Value
                end
            })

            Sections.Grenade:AddToggle('TrailModifier', {
                Text = 'Trail Modifier',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Grenade.TrailModifier.Enabled = Value
                end
            }):AddColorPicker('TrailColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Trail Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Grenade.TrailModifier.Color = Value
                end
            })

            Sections.Grenade:AddSlider('TrailLifetime', {
                Text = 'Trail Lifetime',
                Default = 0.55,
                Min = 0,
                Max = 10,
                Rounding = 1,
                Compact = false,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Grenade.TrailModifier.TrailLifetime = Value
                end
            })

        end

        do --// Misc Tab

            Sections.Misc:AddToggle('Watermark', {
                Text = 'Watermark',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    Watermark.Enabled = Value
                end
            })

            --// Player section

            Sections.Player:AddToggle('Bhop', {
                Text = 'Bhop',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Misc.Player.Bhop = Value
                end
            })

            Sections.Player:AddToggle('JumpModifier', {
                Text = 'Override Jump Power',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Misc.Player.JumpPowerModifier.Enabled = Value
                end
            })

            Sections.Player:AddSlider('JumpPower', {
                Text = 'Jump Power',
                Default = 0,
                Min = 0,
                Max = 80,
                Rounding = 1,
                Compact = false,
            
                Callback = function(Value)
                    FeatureTable.Misc.Player.JumpPowerModifier.Power = Value
                end
            })

            Sections.Player:AddSlider('HipHeight', {
                Text = 'Hip Height',
                Default = 0,
                Min = 0,
                Max = 50,
                Rounding = 1,
                Compact = false,
            
                Callback = function(Value)
                    FeatureTable.Misc.Player.HipHeight = Value
                end
            })

        end
        
    end
    
    do --// Logic

        do --// Functions

            do --// Regular

                do --// Lighting

                    function Functions.Normal:SetAmbient(Property, Value)
                        if FeatureTable.Visuals.Lighting.OverrideAmbient.Enabled then
                            Lighting[Property] = Value
                        end
                    end
                    
                end

                do --// Players

                    function Functions.Normal:GetTeam(Player)
                        if Player ~= nil and Player.Parent ~= nil and Player:FindFirstChildOfClass("Folder") then
                            local Helmet = Player:FindFirstChildWhichIsA("Folder"):FindFirstChildOfClass("MeshPart")
                            if Helmet then
                                if Helmet.BrickColor == BrickColor.new("Black") then
                                    return game.Teams.Phantoms
                                end
                                return game.Teams.Ghosts
                            end
                        end
                    end

                    function Functions.Normal:GetPlayers()
                        local PlayerList = {}
                        for i,Teams in Players:GetChildren() do
                            for i,Players in Teams:GetChildren() do
                                table.insert(PlayerList, Players)
                            end
                        end
                        return PlayerList
                    end
                    
                end
                
                do --// LocalPlayer
                    function Functions.Normal:GetGun()
                        for i,Viewmodel in Camera:GetChildren() do
                            if Viewmodel:IsA("Model") and not Viewmodel.Name:find("Arm") then
                                return Viewmodel
                            end
                        end
                        return nil
                    end
                end

                do --// Math

                    function Functions.Normal:Measure(Origin, End)
                        return (Origin - End).Magnitude
                    end

                    function Functions.Normal:GetLength(Table) --// This isnt even math btw, but its not related to any of the other sections so whatever lol
                        local Int = 0
                        for WhatTheSigma in Table do
                            Int += 1
                        end
                        return Int
                    end

                end
    
            end
    
            do --// Aimbot
                
                function Functions.Normal:getClosestPlayer()
                    local Player = nil
                    local Hitpart = nil
                    local Distance = math.huge
                
                    for i, Players in Functions.Normal:GetPlayers() do
                        if Players ~= nil then
                            local Children = Players:GetChildren()

                            local Torso = Children[6]

                            local Screen = Camera:WorldToViewportPoint(Torso.Position)
                            local MeasureDistance = (Vector2.new(Storage.Other.ViewportSize.X / 2, Storage.Other.ViewportSize.Y / 2) - Vector2.new(Screen.X, Screen.Y)).Magnitude
                
                            local PlayerIsVisible = (not FeatureTable.Combat.WallCheck) or Functions.Normal:PlayerVisible(Players, Camera.CFrame.Position, Torso.Position, {Misc, Ignore, Players:FindFirstChildOfClass("Folder")})
                
                            if MeasureDistance < Distance and MeasureDistance <= FOVCircle.Radius * 1.25 and PlayerIsVisible then
                                Player = Players
                                Distance = MeasureDistance
                
                                if tostring(FeatureTable.Combat.Hitpart):find("Random") then
                                    local Keys = {}
                
                                    do --// WhatTheSigma
                                        for WhatTheSigma in Storage.Index do
                                            table.insert(Keys, WhatTheSigma)
                                        end
                                    end
                
                                    local Index = math.random(1, Functions.Normal:GetLength(Keys))
                                    local Rndm = Keys[Index]
                
                                    Hitpart = Children[Storage.Index[Rndm]]
                                else
                                    Hitpart = Children[FeatureTable.Combat.Hitpart]
                                end
                            end
                        end
                    end
                
                    return {Closest = Player, Hitpart = Hitpart}
                end

                function Functions.Normal:PlayerVisible(Player, Origin, End, Ignorelist)

                    local Params = RaycastParams.new()
                    do --// Param Properties

                        Params.FilterDescendantsInstances = Ignorelist
                        Params.FilterType = Enum.RaycastFilterType.Exclude
                        Params.IgnoreWater = true
                        
                    end

                    local CastRay = workspace:Raycast(Origin, End - Origin, Params)
                    if CastRay and CastRay.Instance then
                        if CastRay.Instance:IsDescendantOf(Player) then
                            return true
                        end
                    end
                    return false
        
                end
    
            end
    
            do --// ESP
                function Functions.ESP:Create(Player)
        
                    if not table.find(Storage.ESP.Boxes, Player) then
        
                        local Box = Drawing.new("Square")
                        Box.Color = Color3.fromRGB(255,255,255)
                        Box.Transparency = 1
                        Box.Visible = true
                        Box.Thickness = 1
                        Box.ZIndex = 2
                        
                        do --// Table insert
        
                            table.insert(Storage.ESP.Boxes, Box)
                            table.insert(Storage.ESP.Boxes, Player)
        
                        end
                
                    end
                    if not table.find(Storage.ESP.Tracers, Player) then
        
                        local Tracer = Drawing.new("Line")
                        Tracer.Transparency = 1
                        Tracer.Visible = true
                        Tracer.Color = Color3.fromRGB(255,255,255)
                        
                        do --// Table insert
        
                            table.insert(Storage.ESP.Tracers, Tracer)
                            table.insert(Storage.ESP.Tracers, Player)
        
                        end
                
                    end
        
                end
    
                function Functions.ESP:ClearTable(esps, esptable, index)
                    for i = 1, #esps do
                        esps[i]:Destroy()
                    end
                    do --// Table clear
                        table.remove(esptable, index)
                        table.remove(esptable, index-1)
                    end
                end
            end
    
        end
    
        do --// Loops
    
            task.spawn(function()
                while task.wait() do --// gl working with the dogshit code, skids :D
    
                    do --// Combat
    
                        do --// Aimbot
    
                            if FeatureTable.Combat.SilentAim then

                                local EnemyInformation = Functions.Normal:getClosestPlayer()
                                local Target = EnemyInformation.Closest
                                if Target ~= nil and (FeatureTable.Combat.TeamCheck and Functions.Normal:GetTeam(Target) ~= game.Players.LocalPlayer.Team or not FeatureTable.Combat.TeamCheck) then

                                    local Hitpart = EnemyInformation.Hitpart
                                    local Gun = Functions.Normal:GetGun()
                            
                                    if Hitpart and Gun then
                                        for i, Stuff in Gun:GetChildren() do
                                            pcall(function()
                                                local Joints = Stuff:GetJoints()
                                                if Stuff.Name:find("SightMark") or Stuff.Name:find("FlameSUP") or Stuff.Name:find("Flame") then
                                                    Joints[1].C0 = Joints[1].Part0.CFrame:ToObjectSpace(CFrame.lookAt(Joints[1].Part1.Position, Hitpart.Position))
                                                end
                                            end)
                                        end
                                    end
                                end

                            end
                            
    
                        end
    
                    end
    
                    do --// Visuals

                        for i,Players in Functions.Normal:GetPlayers() do --// bro... so p1000
                            Functions.ESP:Create(Players)
                        end
    
                        do --// Box ESP
    
                            for i,Player in Storage.ESP.Boxes do --// Box logic (obviously)
                                if typeof(Player) == "Instance" then
    
                                    local Box = Storage.ESP.Boxes[i-1]
                    
                                    if FeatureTable.Visuals.Box.Enabled and Player:IsDescendantOf(workspace) then
                                        local Torso = Player:GetChildren()[6]
                                        if Torso ~= nil then
                                            local Position, OnScreen = Camera:WorldToViewportPoint(Torso.Position) --// Convert to screen pos since we're rendering the boxes on the screen (duh)
    
                                            local Team = Functions.Normal:GetTeam(Player)
                                            local TeamColor = Team.TeamColor
                    
                                            if OnScreen and FeatureTable.Visuals.TeamCheck and tostring(Team) ~= game.Players.LocalPlayer.Team.Name or not FeatureTable.Visuals.TeamCheck then
                    
                                                local PosX = Position.X - (Box.Size.X / 2)
                                                local PosY = Position.Y - (Box.Size.Y / 2)
                                                local Scale = 1000/(Camera.CFrame.Position - Torso.Position).Magnitude*80/Camera.FieldOfView --// Very simple box distance scale
                                                
                                                Box.Position = Vector2.new(PosX, PosY)
                                                Box.Size = Vector2.new(2 * Scale, 3 * Scale)
                                                Box.Visible = true
                                                
                                                if FeatureTable.Visuals.UseTeamColor then --// 😭
                                                    if tostring(TeamColor) == "Bright blue" then
                                                        Box.Color = Color3.fromRGB(0, 162, 255)
                                                    elseif tostring(TeamColor) == "Bright orange" then
                                                        Box.Color = Color3.fromRGB(255, 162, 0)
                                                    end
                                                else
                                                    Box.Color = FeatureTable.Visuals.Box.Color
                                                end
                    
                                            else
                    
                                                Functions.ESP:ClearTable({Box}, Storage.ESP.Boxes, i)
                    
                                            end
                    
                                        else
                    
                                            Functions.ESP:ClearTable({Box}, Storage.ESP.Boxes, i)
                    
                                        end
                                    else
                    
                                        Functions.ESP:ClearTable({Box}, Storage.ESP.Boxes, i)
                    
                                    end
                                end
                            end

                        end

                        do --// Tracer ESP

                            for i,Player in Storage.ESP.Tracers do --// Tracer logic (obviously once again)
                                if typeof(Player) == "Instance" then
    
                                    local Tracer = Storage.ESP.Tracers[i-1]
                    
                                    if FeatureTable.Visuals.Tracers.Enabled and Player:IsDescendantOf(workspace) then
                                        local Torso = Player:GetChildren()[6]
                                        if Torso ~= nil then
                                            local Position, OnScreen = Camera:WorldToViewportPoint(Torso.Position) --// Convert to screen pos since we're rendering the boxes on the screen (duh)
    
                                            local Team = Functions.Normal:GetTeam(Player)
                                            local TeamColor = Team.TeamColor
                    
                                            if OnScreen and FeatureTable.Visuals.TeamCheck and tostring(Team) ~= game.Players.LocalPlayer.Team.Name or not FeatureTable.Visuals.TeamCheck then
                                                
                                                local Origin = FeatureTable.Visuals.Tracers.Origin
                                                local Value
                                                if Origin ~= "Gun" then

                                                    if Origin == "Top" then
                                                        Value = 0 
                                                    elseif Origin == "Middle" then
                                                        Value = Storage.Other.ViewportSize.Y / 2
                                                    elseif Origin == "Bottom" then
                                                        Value = Storage.Other.ViewportSize.Y
                                                    end

                                                    Tracer.From = Vector2.new(Storage.Other.ViewportSize.X / 2, Value)
                                                    Tracer.To = Vector2.new(Position.X, Position.Y)
                                                else

                                                    local Gun = Functions.Normal:GetGun()
                                                    if Gun ~= nil and Gun:FindFirstChild("Flame") then
                                                        local TipPosition = Camera:WorldToViewportPoint(Gun["Flame"].Position) or Camera:WorldToViewportPoint(Gun["FlameSUP"].Position)
                                                        Tracer.From = Vector2.new(TipPosition.X, TipPosition.Y)
                                                        Tracer.To = Vector2.new(Position.X, Position.Y)
                                                    else
                                                        Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                                                    end

                                                end
                                                
                                                if FeatureTable.Visuals.UseTeamColor then --// emm
                                                    if tostring(TeamColor) == "Bright blue" then
                                                        Tracer.Color = Color3.fromRGB(0, 162, 255)
                                                    elseif tostring(TeamColor) == "Bright orange" then
                                                        Tracer.Color = Color3.fromRGB(255, 162, 0)
                                                    end
                                                else
                                                    Tracer.Color = FeatureTable.Visuals.Tracers.Color
                                                end
                    
                                            else
                    
                                                Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                    
                                            end
                    
                                        else
                    
                                            Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                    
                                        end
                                    else
                    
                                        Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                    
                                    end
                                end
                            end
                            
                        end

                        do --// Cham ESP

                            for i, Player in Functions.Normal:GetPlayers() do
                                if Player ~= nil then
                                    
                                    local Highlight = Player:FindFirstChildOfClass("Highlight")
                                    local Team = Functions.Normal:GetTeam(Player)
                                    local TeamColor = Team.TeamColor
                            
                                    if FeatureTable.Visuals.Chams.Enabled and (FeatureTable.Visuals.TeamCheck and tostring(Team) ~= game.Players.LocalPlayer.Team.Name or not FeatureTable.Visuals.TeamCheck) then
                                        
                                        if not Highlight then
                                            Highlight = Instance.new("Highlight", Player)
                                        end
                            
                                        Highlight.Enabled = true
                                        Highlight.Adornee = Player
                                        Highlight.FillColor = FeatureTable.Visuals.Chams.FillColor
                                        Highlight.OutlineColor = FeatureTable.Visuals.Chams.OutlineColor
                                        Highlight.FillTransparency = FeatureTable.Visuals.Chams.FillTransparency
                                        Highlight.OutlineTransparency = FeatureTable.Visuals.Chams.OutlineTransparency
                                        Highlight.DepthMode = FeatureTable.Visuals.Chams.VisibleOnly and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop

                                        if FeatureTable.Visuals.UseTeamColor then --// 😭
                                            if tostring(TeamColor) == "Bright blue" then
                                                Highlight.FillColor = Color3.fromRGB(0, 162, 255)
                                                Highlight.OutlineColor = Color3.fromRGB(0, 162, 255)
                                            elseif tostring(TeamColor) == "Bright orange" then
                                                Highlight.FillColor = Color3.fromRGB(255, 162, 0)
                                                Highlight.OutlineColor = Color3.fromRGB(255, 162, 0)
                                            end
                                        else
                                            Highlight.FillColor = FeatureTable.Visuals.Chams.FillColor
                                            Highlight.OutlineColor = FeatureTable.Visuals.Chams.OutlineColor
                                        end
                  
                                    else

                                        if Highlight then
                                            Highlight:Destroy()
                                        end

                                    end
									
                                end
                            end
                            
                        end
    
                    end

                    do --// Misc

                        do --// Player

                            local LocalPlayer = Ignore:FindFirstChild("RefPlayer")
                            if LocalPlayer then
                                local Humanoid = LocalPlayer:FindFirstChildOfClass("Humanoid")

                                do --// Player Modifications

                                    if Humanoid then
    
                                        if FeatureTable.Misc.Player.JumpPowerModifier.Enabled then
                                            Humanoid.JumpPower = FeatureTable.Misc.Player.JumpPowerModifier.Power
                                        end
                                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and FeatureTable.Misc.Player.Bhop then
                                            Humanoid.Jump = true
                                        end
                                        Humanoid.HipHeight = FeatureTable.Misc.Player.HipHeight
                                    
                                    end
                                    
                                end

                            end
                            
                        end
                        
                    end

                    do --// Extra
                        FOVCircle.Position = Vector2.new(Storage.Other.ViewportSize.X/2, Storage.Other.ViewportSize.Y/2)
                    end
    
                end
            end)
    
        end
    
        do --// Connections
            
            Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                Storage.Other.ViewportSize = Camera.ViewportSize
            end)

            do --// Lighting (I love this part)

                Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
                    Functions.Normal:SetAmbient("Ambient", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)

                Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
                    Functions.Normal:SetAmbient("OutdoorAmbient", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)

                Lighting:GetPropertyChangedSignal("ColorShift_Top"):Connect(function()
                    Functions.Normal:SetAmbient("ColorShift_Top", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)

                Lighting:GetPropertyChangedSignal("ColorShift_Bottom"):Connect(function()
                    Functions.Normal:SetAmbient("ColorShift_Bottom", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)
                
            end

            Misc.ChildAdded:Connect(function(Child)
                if tostring(Child.Name):find("Trigger") then 
                    if FeatureTable.Visuals.Grenade.GrenadeESP.Enabled then
                        local Billboard = Instance.new("BillboardGui", Child)
                        local Frame = Instance.new("Frame", Billboard)
                        local UICorner = Instance.new("UICorner", Frame)
                        
                        do --// Properties
                            do --// BillboardGui
                                Billboard.Enabled = true
                                Billboard.AlwaysOnTop = true
                                Billboard.Size = UDim2.new(1, 0, 1, 0)
                                Billboard.Adornee = Child
                            end
                            do --// Frame
                                Frame.Size = UDim2.new(1, 0, 1, 0)
                                Frame.BackgroundTransparency = FeatureTable.Visuals.Grenade.GrenadeESP.Transparency
                                Frame.BackgroundColor3 = FeatureTable.Visuals.Grenade.GrenadeESP.Color
                            end
                            do --// UICorner
                                UICorner.CornerRadius = UDim.new(0, 50)
                            end
                        end
                    end
                    if FeatureTable.Visuals.Grenade.TrailModifier.Enabled then
                        local Trail = Child:WaitForChild("Trail")
                        Trail.Lifetime = FeatureTable.Visuals.Grenade.TrailModifier.TrailLifetime
                        Trail.Color = ColorSequence.new(FeatureTable.Visuals.Grenade.TrailModifier.Color)
                    end
                end
            end)
            
            
        end
    
        --// Made by @dementia enjoyer 😁
    
    end
    
end

Library:OnUnload(function()
    Library.Unloaded = true
end)

local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Homohack')
SaveManager:SetFolder('Homohack/PhantomForces')

SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])
SaveManager:LoadAutoloadConfig()
