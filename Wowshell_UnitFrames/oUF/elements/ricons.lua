local parent, ns = ...
local oUF = ns.oUF
local RaidIcon = {};
WSUF:RegisterModule(RaidIcon, "ricon", "Raid Icon");

function RaidIcon:Update(frame, event)
	local index = GetRaidTargetIndex(frame.unit)
	local icon = frame.RaidIcon

	if(index) then
		SetRaidTargetIconTexture(icon, index)
		icon:Show()
	else
		icon:Hide()
	end
end

local function Update(frame, event)
	RaidIcon:Update(frame, event);
end

function RaidIcon:Path(frame, ...)
	return (frame.RaidIcon.Override or Update) (frame, ...)
end

local function Path(frame, ...)
	return RaidIcon:Path(frame, ...);
end

local ForceUpdate = function(element)
	if(not element.__owner.unit) then return end
	return Path(element.__owner, 'ForceUpdate')
end

function RaidIcon:Enable(frame, debug)
	--print(frame.unit, debug)
	local ricon = frame.RaidIcon
	if(ricon) then
		ricon.__owner = frame
		ricon.ForceUpdate = ForceUpdate

		frame:RegisterEvent("RAID_TARGET_UPDATE", Path)

		if(ricon:IsObjectType"Texture" and not ricon:GetTexture()) then
			ricon:SetTexture[[Interface\TargetingFrame\UI-RaidTargetingIcons]]
		end

		return true
	end
end

local function Enable(frame)
	return RaidIcon:Enable(frame);
end

function RaidIcon:Disable(frame)
	local ricon = frame.RaidIcon
	if(ricon) then
		frame:UnregisterEvent("RAID_TARGET_UPDATE", Path)
	end
end

local function Disable(frame)
	return RaidIcon:Disable(frame);
end

oUF:AddElement('RaidIcon', Path, Enable, Disable)

function RaidIcon:OnLayoutApplied(frame, config)
	self:Disable(frame)

	if (config and config.indicators and config.indicators.raidIcon) then
		if (frame.RaidIcon) then
			self:Enable(frame, ">>>OnLayoutApplied");
		end
	end
end
