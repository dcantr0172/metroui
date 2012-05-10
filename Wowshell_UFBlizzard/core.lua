assert(WSUF, "Not found Wowshell_UnitFrames");

local parent, ns = ...
local defaults = {
	profile = {
		tags = {},
		units = {},
		positions = {}
	}
}
ns = WSUF:RegisterStyle(ns, "Blizzard", "暴雪风格", defaults);

function ns:OnInitialize()
	self:RegisterOUFStyle(parent);

	self:SpawnUnits();
end
