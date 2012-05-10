local Speed, Nudgers = 1, {}
--basic slider
local Slider
do
	local function Slider_OnMouseWheel(self, arg1)
		local step = self:GetValueStep() * arg1
		local value = self:GetValue()
		local minVal, maxVal = self:GetMinMaxValues()

		if step > 0 then
			self:SetValue(min(value+step, maxVal))
		else
			self:SetValue(max(value+step, minVal))
		end
	end

	function Slider(self, text, low, high, step)
		local name = self:GetName() .. text
		local f = CreateFrame('Slider', name, self, 'OptionsSliderTemplate')
		f:SetScript('OnMouseWheel', Slider_OnMouseWheel)
		f:SetMinMaxValues(low, high)
		f:SetValueStep(step)
		f:EnableMouseWheel(true)

		_G[name .. 'Text']:SetText(text)
		_G[name .. 'Low']:SetText('')
		_G[name .. 'High']:SetText('')

		local text = f:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlightSmall')
		text:SetPoint('LEFT', f, 'RIGHT', 7, 0)
		f.valText = text

		return f
	end
end

local function Load()
	local Config = Dominos.configHelper
	
	local nToggle = CreateFrame("Button", Config:GetName().."NudgeToggle", Config, "OptionsButtonTemplate")
	_G[nToggle:GetName() .. 'Text']:SetText("Nudge")
	nToggle:SetScript('OnClick', function()
		for i = 1, #Nudgers do
			ToggleFrame(Nudgers[i])
		end
	end)
	nToggle:SetPoint('BOTTOMLEFT', 14, 14)

	local nSpeed = Slider(Config, "Nudge Speed", 1, 20, 1)
	nSpeed:SetScript("OnValueChanged", function(self, value) Speed = value end)
	nSpeed:SetScript("OnShow", function(self, value) nSpeed:SetValue(Speed) end)
	nSpeed:GetScript("OnShow")()
	nSpeed:SetPoint("Bottom", 0, 14)
end

local dominos_ShowConfigHelper = Dominos.ShowConfigHelper
Dominos.ShowConfigHelper = function(self)
	dominos_ShowConfigHelper(self)
	Load()
end

local Sides = {
	{ name = 'Right', Rotation = 0,		   val = "x", dir =  1,},
	{ name = 'Top',	  Rotation = 3.145/2,	   val = "y", dir =  1,},
	{ name = 'Left',  Rotation = 3.145, 	   val = "x", dir = -1,},
	{ name = 'Bottom',Rotation = (3.145/2) * 3,val = "y", dir = -1,}
}

local function NudgeButtons(frame)
	for k , v  in pairs(Sides) do
		local f = CreateFrame("Button", v.name.."Nudger"..frame.owner.id, frame, "ActionButtonTemplate")
		f:SetFrameLevel(frame:GetFrameLevel()+1)
		f:SetPoint(v.name, frame)
		f:SetSize(20, 20)
		_G[f:GetName().."Border"]:SetTexture("");
		_G[f:GetName().."NormalTexture"]:SetTexture("Interface/CHATFRAME/ChatFrameExpandArrow");
		_G[f:GetName().."NormalTexture"]:SetRotation(v.Rotation)
		_G[f:GetName().."NormalTexture"]:SetAllPoints()
		local icon = _G[f:GetName().."Icon"]
		f:SetScript("OnClick", function(self)
			self:GetParent().owner.sets[v.val] = self:GetParent().owner.sets[v.val] + (v.dir * Speed)
			self:GetParent().owner:Reposition()
		end)
		f:Hide()

		tinsert(Nudgers, f)
	end
end

local dragFrame_New = Dominos.DragFrame.New
Dominos.DragFrame.New = function(self, owner)
	local f = dragFrame_New(self, owner)
	NudgeButtons(f)
	return f
end