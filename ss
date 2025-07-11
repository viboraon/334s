--[[
	sound visualizer by MyWorld
	dont worry - you can take it from the exploiting community, game developers
]]

local linescount=75
local soundid="rbxassetid://15689448519"

local freqRanges=10
local freqRangeStart=200+freqRanges
local freqRangeEnd=20000+freqRanges

local passGain=10
local filterGain=-80

local i=Instance.new
local e=Enum
local v2=Vector2.new
local c3=Color3.new
local u2=UDim2.new
local u1=UDim.new
local twait=task.wait
local next=next
local u2s=UDim2.fromScale
local max=math.max

local i1=i("ScreenGui")
local i2=i("Frame")
local i3=i("Frame")
local i4=i("Frame")
local i5=i("UIListLayout")
local i6=i("AudioPlayer")
local i7=i("AudioDeviceOutput")
local i8=i("Wire")

i1.ResetOnSpawn=false
i1.ZIndexBehavior=e.ZIndexBehavior.Sibling
i2.AnchorPoint=v2(0.5,1)
i2.AutomaticSize=e.AutomaticSize.XY
i2.BackgroundColor3=c3(0,0,0)
i2.BorderColor3=c3(0,0,0)
i2.BorderSizePixel=0
i2.Position=u2(0.5,0,1,0)
i3.AnchorPoint=v2(0.5,0.5)
i3.BackgroundColor3=c3(0,0.004,0.192)
i3.BorderColor3=c3(0,0,0)
i3.BorderSizePixel=0
i3.Position=u2(0.5,0,0.5,0)
i3.Size=u2(0,7,0,150)
i4.AnchorPoint=v2(0,1)
i4.BackgroundColor3=c3(0,0,0.627)
i4.BorderColor3=c3(0,0,0)
i4.BorderSizePixel=0
i4.Position=u2(0,0,1,0)
i4.Size=u2(1,0,0.5,0)
i5.FillDirection=e.FillDirection.Horizontal
i5.HorizontalAlignment=e.HorizontalAlignment.Center
i5.SortOrder=e.SortOrder.LayoutOrder
i5.VerticalAlignment=e.VerticalAlignment.Center
i5.Padding=u1(0,1)
i6.AssetId=soundid
i6.Looping=true
i8.SourceInstance = i6
i8.TargetInstance = i7

i8.Parent=i7
i7.Parent=i2
i6.Parent=i2
i5.Parent=i2
i4.Parent=i3
i2.Parent=i1

local frames={}
for x=1,linescount do
	local line=i3:Clone()
	local frame=line:FindFirstChildOfClass("Frame")
	local eq=i("AudioEqualizer")
	local wire0=i("Wire")
	local b=i("AudioAnalyzer")
	local wire1=i("Wire")
	eq.LowGain=filterGain
	eq.HighGain=filterGain
	eq.MidGain=passGain
	local v=freqRangeStart+(freqRangeEnd-freqRangeStart)*((x/linescount)^2.71828)
	eq.MidRange=NumberRange.new(v-freqRanges,v+freqRanges)
	wire0.SourceInstance=i6
	wire0.TargetInstance=eq
	b.SpectrumEnabled=false
	wire1.SourceInstance=eq
	wire1.TargetInstance=b
	eq.Parent=line
	wire0.Parent=eq
	b.Parent=wire0
	wire1.Parent=b
	frames[b]=frame
	line.Parent=i2
end

if not pcall(function()
	i1.Parent=game:FindFirstChildOfClass("CoreGui")
end) then
	i1.Parent=game:FindFirstChildOfClass("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
end

i6:Play()

local MaxVolume=1
while twait() do
	for i,v in next,frames do
		local PeakLevel=i.PeakLevel
		MaxVolume=max(MaxVolume,PeakLevel)
		v.Size=u2s(1,PeakLevel/MaxVolume)
	end
end
