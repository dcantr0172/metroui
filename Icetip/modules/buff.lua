local addonName, Icetip = ...;
local mod = Icetip:NewModule("Buff");
local db
--update function
local update

local buffFrame, debuffFrame;

function mod:OnEnable()
	local db = self.db["auras"];
	self.db = db;

end

function mod:OnDisable()

end

function mod:CreateAuraFrame()
end

function mod:OnTooltipShow()

end

function mod:OnTooltipHide()

end
