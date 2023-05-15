local UnnamedLibrary = {
    _Functions = {
    	get_gc = getgc or false,
	    is_closure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or checkclosure or iskrnlclosure or isexecutorclosure or false,
	    get_info = debug.getinfo or getinfo or get_info or false,
	    set_identity = (syn and syn.set_thread_identity) or (fluxus and fluxus.set_thread_identity) or setidentity or setthreadcontext or false,
	    get_identity = (syn and syn.get_thread_identity) or (fluxus and fluxus.get_thread_identity) or getidentity or getthreadcontext or false,
	    executor_indentification = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or false,
	    get_up_values = debug.getconstants or getconstants or debug.getupvalue or getupvalue or debug.getupvalues or getupvalues or debug.getstack or getstack or get_up_value or debug.getconstants or getconstants or false,
	    set_up_values = debug.setconstants or setconstants or debug.setupvalue or setupvalue or debug.setupvalues or setupvalues or debug.setstack or setstack or set_up_value or debug.setconstant or setconstant or false,
	    clipboard = setclipboard or toclipboard or set_clipboard or (syn and syn.write_clipboard) or (Clipboard and Clipboard.set) or false,
	    sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop or false,
	    gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop or false,
	    setsimulation = setsimulationradius or set_simulation_radius or false,
	    queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport) or false,
	    httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request or false,
      getasset = getsynasset or getcustomasset or false
    },
    Client = game:GetService("Players").LocalPlayer,
    service = function(ServiceName: string)
        return game:GetService(ServiceName) or game[ServiceName]
    end,
}

local InvalidSupports = 0
function UnnamedLibrary.CheckExploitSupport()
    for FuncName, IsValidFunction in pairs(UnnamedLibrary._Functions) do
    	if IsValidFunction == false then
    		warn(`{FuncName} - Doesn't support with your current exploit.`)
    		InvalidSupports += 1
    	end
    end
    
    if InvalidSupports > 5 then
    	return false
    end
    
    return true
end

if not UnnamedLibrary.CheckExploitSupport() then
    warn("Invalid Exploit - Unsupported")
    return
end

UnnamedLibrary.FindFunction = function(Name: string)
    for i,v in pairs(UnnamedLibrary._Functions.get_gc()) do
        if type(v) == "function" and not UnnamedLibrary._Functions.is_closure(v) then
            if UnnamedLibrary._Functions.get_info(v).name == Name then
                return v
            end
        end
    end
end

function UnnamedLibrary.ConvertToAsset(String: string)
    if isfile(String) then
        return UnnamedLibrary._Functions.getasset(String)
        
    elseif String:find("rbxassetid") or tonumber(String) then
        local numberId = String:gsub("%D", "")
        return "rbxassetid://".. numberId
        
    elseif String:sub(1, 4) == "http" then
        local req = UnnamedLibrary._Functions.httprequest({Url = String, Method = "GET"}) or game:HttpGetAsync(String)
        
        if (type(req) == "table" and req.Success) or req ~= "" or #req > 14 then
            local name = "customObject_".. tick().. ".txt"
            writefile(name, req.Body)
            return UnnamedLibrary._Functions.getasset(name)
        end
    end

    return String
end

function UnnamedLibrary.LoadCustomAsset(str)
    if str == "" then
        return ""
    end

    return UnnamedLibrary.ConvertToAsset(str)
end

function UnnamedLibrary.LoadCustomInstance(str)
    if str ~= "" then
        local asset = UnnamedLibrary.ConvertToAsset(str)
        local success, result = pcall(function()
            return game:GetObjects(asset)[1]
        end)
    
        if success then
            return result
        else
            warn(`Error loading instance | {result}`)
            return nil
        end
    end
end

function UnnamedLibrary.GetRoot(Model: Model | Player)
    if not UnnamedLibrary.HasProperty(Model, "IsA") then return end

    if Model:IsA("Player") then
        Model = UnnamedLibrary.GetCharacter(Model)
    end

    return Model.PrimaryPart or Model.HumanoidRootPart or Model.Torso or Model.LowerTorso
end

function UnnamedLibrary:FireTouch(Part: Instance, Reverse: boolean)
    if type(Part) == "Instance" then
        if not UnnamedLibrary.HasProperty(Part, "IsA") then return end

        if Reverse then
            firetouchinterest(UnnamedLibrary.GetRoot(UnnamedLibrary.Client), Part, 1)
            wait()
            firetouchinterest(UnnamedLibrary.GetRoot(UnnamedLibrary.Client), Part, 0)
        else
            firetouchinterest(Part, UnnamedLibrary.GetRoot(UnnamedLibrary.Client), 1)
            wait()
            firetouchinterest(Part, UnnamedLibrary.GetRoot(UnnamedLibrary.Client), 0)
        end
    end
end

function UnnamedLibrary:FireFunction(FunctionName: string)

    local Function_Found = UnnamedLibrary.FindFunction(FunctionName)

    if not Function_Found then return warn("Invalid Function") end
    return function(...)
        local Arguments = {...}

        UnnamedLibrary._Functions.set_up_values(Function_Found, unpack(Arguments))
    end
end

function UnnamedLibrary.CheckNumber(Type: string, Number: number)
    if Type:lower():gsub("[ ]", "") == "float" then
        local _, isFloat = math.modf(Number)

        return isFloat > 0
    elseif Type:lower():gsub("[ ]", "") == "int" then
        local _, isFloat = math.modf(Number)

        return isFloat <= 0
    end
end

UnnamedLibrary.Random = {}
UnnamedLibrary.Random._Rand = Random.new()
function UnnamedLibrary.Random.String(Amount: number, IncludeCaps: boolean)
    local RandString = ""
    if not Amount then Amount = 5 end

    for _ = 1, Amount do
        local Char = availableCharacters[math.random(1, #availableCharacters)]
        local IsCapital = math.random(0, 10)

        if IsCapital > 5 and IncludeCaps then
            Char = Char:upper()
        end

        RandString ..= Char
    end
    
    return RandString
end

function UnnamedLibrary.Random.Int(Min: number, Max: number)
    if not Min then Min = 0 end
    if not Max then Max = 1 end

    return UnnamedLibrary.Random._Rand:NextInteger(Min, Max)
end

function UnnamedLibrary.Random.Float(Min: number, Max: number)
    if not Min then Min = 0 end
    if not Max then Max = 1 end

    return UnnamedLibrary.Random._Rand:NextNumber(Min, Max)
end

UnnamedLibrary.Math = {}
function UnnamedLibrary.Math.rval(Number: number, ReturnValue: any)
    if not ReturnValue then ReturnValue = true end
    if Number > 0 then
        return ReturnValue
    else
        return 0 or false
    end
end

function UnnamedLibrary.Replace(String: string, Replacement: string, ReplaceTo: string)
	local StringTable = String:split("")
	local FinishedString = ""
	
	for i = 1, #StringTable do
		if StringTable[i] == Replacement then
			FinishedString ..= ReplaceTo
		else
			FinishedString ..= StringTable[i]
		end
	end
	
	return FinishedString
end

UnnamedLibrary.Conversions = {}
UnnamedLibrary.Conversions.Algorithms = {}
function UnnamedLibrary.Conversions.CustomEncodingAlgorithm(AlgorithmName: string, Table: { string: string })
    local Algorithm = function(String: string)
        local AlgorithmString = ""
        for Str, Value in next, Table do
            local BrokenString = UnnamedLibrary.Replace(String, Str, Value)
            String = BrokenString
            AlgorithmString = BrokenString
        end

        return AlgorithmString
    end
    local DAlgorithm = function(String: string)
        local AlgorithmString = ""
        for Str, Value in next, Table do
            local UnbrokenString = UnnamedLibrary.Replace(String, Value, Str)
            String = UnbrokenString
            AlgorithmString = UnbrokenString
        end

        return AlgorithmString
    end

    UnnamedLibrary.Conversions.Algorithms[AlgorithmName] = {
        EncodeFunction = Algorithm,
        DecodeFunction = DAlgorithm,
        EncodingTable = Table
    }

    return UnnamedLibrary.Conversions.Algorithms[AlgorithmName].EncodeFunction, UnnamedLibrary.Conversions.Algorithms[AlgorithmName].DecodeFunction
end

function UnnamedLibrary.Directory(Module: { any: any })
    local DirectoryData = {}

    setreadonly(Module, false)
    for IndexData, ValueData in next, getrawmetatable(Module) or {} do
        table.insert(IndexData, ValueData)
    end
    setreadonly(Module, true)

    return DirectoryData
end

local ObjectListFunctions = {}
ObjectListFunctions.__index__ = ObjectListFunctions
local ObjectListNew = {}
ObjectListNew.__index__ = ObjectListNew
function ObjectListNew:new(Inst: Instance)
    self.Obj = Inst
    return setmetatable(self, ObjectListFunctions)
end
function ObjectListFunctions:SetName(Name: string)
    self.Obj.Name = Name or UnnamedLibrary.Random.String(6, true)
end
function ObjectListFunctions:SetCFrame(_CFrame: CFrame)
    if UnnamedLibrary.HasProperty(self.Obj, 'CFrame') then
        self.Obj.CFrame = _CFrame or self.Obj.CFrame
    end
end
function ObjectListFunctions:SetColor(Color: Color3 | BrickColor)
    if UnnamedLibrary.HasProperty(self.Obj, 'Color') then
        self.Obj.Color =  Color or Color.Color or Color3.new(1,1,1) or self.Obj.Color
    elseif UnnamedLibrary.HasProperty(self.Obj, 'BackgroundColor3') then
        self.Obj.BackgroundColor3 =  Color or Color.Color or Color3.new(1,1,1) or self.Obj.BackgroundColor3
    end
end
function ObjectListFunctions:SetPropertyData(Data: { string: any }, Lerp: float, TweenData: {Lerp: float | nil, Easing: EasingStyle, Direction: EasingDirection, Repeat: number, Reverse: boolean, Delay: float})
    for PropName, PropValue in next, Data or {} do
        if UnnamedLibrary.Replace(PropName:lower(), ' ', '') ~= "color" then
            if UnnamedLibrary.HasProperty(self.Obj, PropName) then
                self.Obj[PropName] = PropValue
                UnnamedLibrary.service("TweenService"):Create(
                    self.Obj,
                    TweenInfo.new(
                        Lerp or TweenData['Lerp'] or 0,
                        TweenData['Easing'] or Enum.EasingStyle.Linear,
                        TweenData['Direction'] or Enum.EasingDirection.InOut,
                        TweenData['Repeat'] or 0,
                        TweenData['Reverse'] or false,
                        TweenData['Delay'] or 0
                    ),
                    {
                        PropName = PropValue
                    }
                ):Play()
            end
        end
    end
end
function ObjectListFunctions:SetPosition(Position: Vector3 | UDim2)
    if UnnamedLibrary.HasProperty(self.Obj, 'Position') then
        self.Obj.Position = Position or self.Obj.Position
    end
end

function UnnamedLibrary.Create(InstanceType: string, Parent: Instance, Properties: { string: any })
    local ObjInstance = Instance.new(InstanceType)
    ObjInstance.Parent = Parent or nil
    local ObjectInstance = ObjectListNew:new(ObjInstance)

    for PropertyName, PropertyValue in next, Properties or {} do
        if UnnamedLibrary.HasProperty(ObjInstance, PropertyName) then
            ObjInstance[PropertyName] = PropertyValue
        end
    end

    return ObjectInstance
end

function UnnamedLibrary.GetNil(NilName: string, NilClass: string, Properties: { string: any })
    local INSTANCE = nil
    Properties["Name"] = NilName
    INSTANCE = UnnamedLibrary:FindByProperty(Properties, getnilinstances(), NilClass)

    return INSTANCE[1], INSTANCE
end

function UnnamedLibrary:FireEvent(EventName: string, ...)
    local Service = game:FindFirstChild(EventName, true)

    assert(Service ~= nil, "Remote can\"t be invalid")

    local Arguments = {...}

    if Service:IsA("RemoteFunction") then
        Service:InvokeServer(unpack(Arguments))
    elseif Service:IsA("RemoteEvent") then
        Service:FireServer(unpack(Arguments))
    elseif Service:IsA("BindableEvent") then
        Service:Fire(unpack(Arguments))
    elseif Service:IsA("BindableFunction") then
        Service:Invoke(unpack(Arguments))
    end
end

function UnnamedLibrary.HasProperty(Object: any, Property: string)
    local Result, _ = pcall(function()
        return Object[Property]
    end)

    return Result
end

local availableCharacters = ("qwertyuiopasdfghjklzxcvbnm`1234567890-=[]\\;\",./~!#%^&*()_+{}|:<>?"):split("")

function UnnamedLibrary.SendChat(Message: string, To: string)
	local ChatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest")
    if not ChatRemote then
        return
    end
    if To == "" or not To then
        local Success, _ = pcall(function()
            ChatRemote:FireServer(Message, "All")
        end)

        if not Success then
            UnnamedLibrary:FireEvent("SayMessageRequest", Message, "All")
        end
    elseif To ~= "" and To and UnnamedLibrary.GetPlayerByToken(To) ~= nil then
        local Success, _ = pcall(function()
            ChatRemote:FireServer(`/w {To} {Message}`, "All")
        end)

        if not Success then
            UnnamedLibrary:FireEvent("SayMessageRequest", `/w {To} {Message}`, "All")
        end
    end
end

function UnnamedLibrary:WaitForChildOfClass(Parent: Instance, Name: string, Type: string, WaitFor: number)
    local Indexes = 0
    local Child = nil
    while true do
        wait()
        Indexes += 0.075
        if Child ~= nil then break end
        if WaitFor then
            if math.floor(Indexes) >= math.floor(WaitFor) then
                warn(`Infinite yield possible on :WaitForChildOfClass in {Parent} {Name}:{Type}`)
                break
            end
        else
            if math.floor(Indexes) >= 3 then
                warn(`Infinite yield possible on :WaitForChildOfClass in {Parent} {Name}:{Type}`)
                break
            end
        end
        
        for _, c in next, Parent:GetDescendants() do
            if c.Name == Name and c:IsA(Type) then
                Child = c
                break
            end
        end
    end
    return Child
end

function UnnamedLibrary:FindByProperty(Properties: { string: any }, Parent: Instance, Type: string)
    local FoundTable = {}
    for _, Child in next, Parent:GetDescendants() or Parent do
        if Type ~= nil then 
            if not Child:IsA(Type) then
                continue
            end
        end

        for PropName, PropVal in next, Properties do
            if UnnamedLibrary.HasProperty(Child, PropName) then
                if Child[PropName] == PropVal then
                    table.insert(FoundTable, Child)
                end
            end
        end
    end

    return FoundTable
end

function UnnamedLibrary.GetPlayersByToken(Token: string)
    local Name, Len, FoundPlayers = Token:lower(), #Token, {}
    for _, Player in pairs(UnnamedLibrary.service("Players"):GetPlayers()) do
        if Player.Name:lower():sub(1, Len) == Name or Player.DisplayName:lower():sub(1, Len) == Name then
            table.insert(FoundPlayers, Player)
        end
    end

    return FoundPlayers
end

function UnnamedLibrary.GetPlayerByToken(Token: string)
    local Name, Len, FoundPlayers = Token:lower(), #Token, {}
    for _, Player in pairs(UnnamedLibrary.service("Players"):GetPlayers()) do
        if Player.Name:lower():sub(1, Len) == Name or Player.DisplayName:lower():sub(1, Len) == Name then
            table.insert(FoundPlayers, Player)
        end
    end

    return FoundPlayers[1]
end

function UnnamedLibrary.GetCharacter(Player: Player | string | Model)
    if UnnamedLibrary.HasProperty(Player, "IsA") then
        if Player:IsA("Player") then
            return Player.Character or Player.CharacterAdded:Wait()
        elseif Player:IsA("Model") then
            if UnnamedLibrary.service("Players"):GetPlayerFromCharacter(Player) then
                return UnnamedLibrary.service("Players"):GetPlayerFromCharacter(Player).Character or UnnamedLibrary.service("Players"):GetPlayerFromCharacter(Player).CharacterAdded:Wait()
            else
                return nil
            end
        end
    elseif type(Player) == "string" then
        return UnnamedLibrary.GetPlayerFromCharacter(Player).Character or nil
    end
end

UnnamedLibrary.CustomNotification = nil
function UnnamedLibrary.Notify(Title: string, Text: string, Duration: number)
    if not UnnamedLibrary.CustomNotification then
        UnnamedLibrary.service("StarterGui"):SetCore("SendNotification", {
            Title = Title or "UnnamedLibrary Notification";
            Text = Text or "Hello!";
            Duration = Duration or 2;
        })
    elseif UnnamedLibrary.CustomNotification ~= nil and UnnamedLibrary.HasProperty(UnnamedLibrary.CustomNotification, "IsA") then
        if UnnamedLibrary.CustomNotification:IsA("Frame") then
            if UnnamedLibrary.CustomNotification.Name == "NotificationFrame" then
                local NotificationFrame = UnnamedLibrary.CustomNotification:Clone()
                local NotificationScreenGui = UnnamedLibrary.service("CoreGui"):FindFirstChild("NotificationUI") or UnnamedLibrary.Create("ScreenGui", UnnamedLibrary.service("CoreGui"), {Name="NotificationUI"})
                local NotificationSize = UnnamedLibrary.ScaleToOffset(NotificationFrame.Size)
                NotificationFrame.Position = UDim2.new(1, -25 - tonumber(tostring(NotificationSize["X"]):split(", ")[2]), 1, -25 - tonumber(tostring(NotificationSize["Y"]):split(", ")[2]))
                NotificationFrame.Name = #NotificationScreenGui:GetChildren()
                NotificationFrame.Parent = NotificationScreenGui
                local Title = UnnamedLibrary.Create("TextLabel", NotificationFrame, {
                	Text = Title or "UnnamedLibrary Notification",
                	Size = UDim2.new(1, 0, 0.2, 0),
                	TextScaled = true,
                	TextXAlignment = Enum.TextXAlignment.Center,
                	BackgroundTransparency = 1,
                    ZIndex = 99
                })
                local Description = UnnamedLibrary.Create("TextLabel", NotificationFrame, {
                	Text = Text or "Hello!",
                	Size = UDim2.new(1, 0, 0.7, 0),
                	TextSize = 10,
                	Position = UDim2.new(0, 0, 0.2, 0),
                	TextXAlignment = Enum.TextXAlignment.Center,
                	TextYAlignment = Enum.TextYAlignment.Top,
                	BackgroundTransparency = 1,
                    ZIndex = 99
                })
                
                task.delay(Duration or 2.5, function()
                	for _, C in next, NotificationFrame:GetChildren() do
                		if C:IsA("UICorner") then continue end
                		if UnnamedLibrary.HasProperty(C, "TextTransparency") then
                			UnnamedLibrary.service("TweenService"):Create(
		                		C,
		                		TweenInfo.new(1, Enum.EasingStyle.Linear),
		                		{BackgroundTransparency = 1, TextTransparency = 1}
		                	):Play()
		                else
			                UnnamedLibrary.service("TweenService"):Create(
		                		C,
		                		TweenInfo.new(1, Enum.EasingStyle.Linear),
		                		{BackgroundTransparency = 1}
		                	):Play()
		                end
		            end
		            UnnamedLibrary.service("TweenService"):Create(
                		NotificationFrame,
                		TweenInfo.new(2, Enum.EasingStyle.Linear),
                		{BackgroundTransparency = 1}
                	):Play()
                	task.wait(2)
                	NotificationFrame:Destroy()
               	end)
				
				if #NotificationScreenGui:GetChildren() < 1 then return end
				for _, Notif in pairs(NotificationScreenGui:GetChildren()) do
					local NewNotifPos = Notif.Position - UDim2.fromOffset(0, tonumber(tostring(NotificationSize["Y"]):split(", ")[2]) + 5)
					UnnamedLibrary.service("TweenService"):Create(
						Notif,
						TweenInfo.new(
							0.5,
							Enum.EasingStyle.Quart,
							Enum.EasingDirection.InOut
						),
						{
							Position = NewNotifPos
						}
					):Play()
				end                
            else
                UnnamedLibrary.service("StarterGui"):SetCore("SendNotification", {
                    Title = "UnnamedLibrary Notification Error";
                    Text = "Custom Notification MainFrame name must be \"NotificationFrame\"";
                    Duration = 2.5;
                })
            end
        else
            UnnamedLibrary.service("StarterGui"):SetCore("SendNotification", {
                Title = "UnnamedLibrary Notification Error";
                Text = "Custom Notification must be a Frame";
                Duration = 2.5;
            })
        end
    end
end

function UnnamedLibrary.ScaleToOffset(ScaledUdim: UDim2)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    return UDim2.new(0, ViewportSize.X * tonumber(tostring(ScaledUdim["X"]):split(", ")[1]), 0, ViewportSize.Y * tonumber(tostring(ScaledUdim["Y"]):split(", ")[1]))
end

function UnnamedLibrary.OffsetToScale(OffsetUdim: UDim2)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    return UDim2.new(tonumber(tostring(OffsetUdim["X"]):split(", ")[2]) / ViewportSize.X, tonumber(tostring(OffsetUdim["Y"]):split(", ")[2]) / ViewportSize.Y)
end

UnnamedLibrary.Player = {}
function UnnamedLibrary.Player.SetSpeed(Speed: number)
    UnnamedLibrary.GetCharacter(UnnamedLibrary.Client):WaitForChild("Humanoid", 2).WalkSpeed = tonumber(Speed) or 16
end

function UnnamedLibrary.Player.SetJump(Power: number)
    UnnamedLibrary.GetCharacter(UnnamedLibrary.Client):WaitForChild("Humanoid", 2).JumpPower = tonumber(Power) or 50
end

function UnnamedLibrary.Player.Kill(BreakJoints: boolean)
    if BreakJoints then
        UnnamedLibrary.GetCharacter(UnnamedLibrary.Client):BreakJoints()
    else
        UnnamedLibrary.GetCharacter(UnnamedLibrary.Client):WaitForChild("Humanoid", 2).Health = 0
    end
end

function UnnamedLibrary.Player.BreakJoint(JointName: string)
    for _, Child in next, UnnamedLibrary.GetCharacter(UnnamedLibrary.Client):GetDescendants() do
        if Child:IsA("Motor6D") and Child.Name == JointName then
            task.defer(function()
                Child:Destroy()
            end)
        end
    end
end

function UnnamedLibrary.GetIndexValue(Table: { any: any }, Value: string)
    for Index, _ in next, Table or {} do
        if Index == Value then
            return Index
        end
    end
end

local Binded = false
function UnnamedLibrary.SetCursor(Cursor: string, Size: UDim2)
	if not Cursor then Cursor = "" end
	if Cursor:find("rbxassetid") or (Cursor:find("http") and Cursor:find("roblox.com")) or Cursor:find("rbxthumb") and not Binded then
        Binded = true
        local ScreenGUI = UnnamedLibrary.Create("ScreenGui", UnnamedLibrary.service("CoreGui"), {
        	Name = "UnnamedLibrary-MouseGUI"
        })
        local CursorImage = UnnamedLibrary.Create("ImageLabel")
        CursorImage.Image = Cursor
        if Size then
        	CursorImage.Size = UnnamedLibrary.ScaleToOffset(Size)
        else
        	CursorImage.Size = UDim2.fromOffset(30, 30)
        end
        
        UnnamedLibrary.service("RunService"):BindToRenderStep("UnnamedLibrary_BindingMouse", 99, function()
            UnnamedLibrary.service("UserInputService").MouseIconEnabled = false
            local MousePosition = UnnamedLibrary.Client:GetMouse()
            CursorImage.Position = UDim2.fromOffset(MousePosition.X, MousePosition.Y)
        end)
	elseif Cursor == "" or not Cursor and Binded then
        Binded = false
        if UnnamedLibrary.service("CoreGui"):FindFirstChild("UnnamedLibrary-MouseGUI") then
        	UnnamedLibrary.service("CoreGui"):FindFirstChild("UnnamedLibrary-MouseGUI"):Destroy()
        end
        
        UnnamedLibrary.service("UserInputService").MouseIconEnabled = true
        UnnamedLibrary.service("RunService"):UnbindFromRenderStep("UnnamedLibrary_BindingMouse")
	end
end

return UnnamedLibrary, {
	Algorithms = UnnamedLibrary.Conversions.Algorithms,
	Random = UnnamedLibrary.Random,
	Conversions = UnnamedLibrary.Conversions,
    Math = UnnamedLibrary.Math,
    Player = UnnamedLibrary.Player,
    Functions = UnnamedLibrary._Functions
}
