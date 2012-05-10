assert(WSUF, "Not found Wowshell_UnitFrames");
local parent, ns = ...
local defaults = {
	profile = {
		tags = {},
		units = {},
		positions = {}
	}
}
ns = WSUF:RegisterStyle(ns, "Shell", "现代风格", defaults);
local oUF = WSUF.oUF
local L = WSUF.L;

function ns:OnInitialize()
		self:RegisterOUFStyle(parent);
		self:SpawnUnits();
end
