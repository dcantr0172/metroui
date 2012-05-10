---------------------------------------------
-- $Revision: 2337 $
-- $Date: 2009-07-31 11:41:44 +0800 (五, 2009-07-31) $
-- Author: 月色狼影@cwdg
-- 公用接口以及设置数据提供调用接口
-- 在开发过程中参考Bartender4的开发思路.
---------------------------------------------
Skylark = LibStub("AceAddon-3.0"):NewAddon("Skylark", "AceEvent-3.0", "AceConsole-3.0");
local revision = tonumber(("$Revision: 2337 $"):match("%d+"))
Skylark.revision = revision
local L = wsLocale:GetLocale("Skylark");

local defaults = {
	profile = {
		buttonlock = false,
		selfcastmodifier = true,
		focuscastmodifier = true,
		selfcastrightclick = false,
		tooltip = "enabled",
		buttons = {},--保存动作按钮的配置
		outofrange = "button",
		colors = {
			range = {r=0.8, g=0.1, b=0.1},
			mana = {r=0.5,g=0.5,b=1},
		}
	},
}

function Skylark:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New('SkylarkDB', defaults, UnitName("player").." - "..GetRealmName())
	self.db.RegisterCallback(self, "OnProfileChanged", "UpdateModuleConfig");
	self.db.RegisterCallback(self, "OnProfileCopied", "UpdateModuleConfig");
	self.db.RegisterCallback(self, "OnProfileReset", "UpdateModuleConfig");

	self:SetupOptions()
	self.Locked = true
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatLockdown")

	--binding name
	BINDING_HEADER_SKYLARK = L["额外动作条"];
	BINDING_CATEGORY_SKYLARK = "Action Bars";
	for i=1, 10 do
		for k=1, 12 do
			_G[("BINDING_NAME_CLICK LarkButton%d:LeftButton"):format((i-1)*12 + k)] = (L["额外动作条%d 按钮%d"]):format(i, k)
		end
	end
end

function Skylark:UpdateModuleConfig()
	local unlock = false
	if not self.Lock then
		self:Lock()
		unlock = true
	end

	for k, v in LibStub("AceAddon-3.0"):IterateModulesOfAddon(self) do
		if v:IsEnabled() and type(v.ApplyConfig) == "function" then
			v:ApplyConfig();
		end
	end

	if unlock then
		self:Unlock()
	end
end

--merge source's config into target
function Skylark:Merge(target, source)
	if type(target) ~= "table" then target = {} end

	for k, v in pairs(source) do
		if type(v) == "table" then
			target[k] = self:Merge(target[k], v);
		elseif not target[k] then
			target[k] = v
		end
	end
	return target
end

function Skylark:ToggleLock()
	if self.Locked then
		self:Unlock()
	else
		self:Lock()
	end
end

function Skylark:ShowUnLockDialog()
	if not self.unlock_dialog then
		local font = ChatFontNormal:GetFont();
		local f = CreateFrame("Frame", "Skylark_UnlockDialog", UIParent);
		f:SetFrameStrata("DIALOG");
		f:SetToplevel(true)
		f:EnableMouse(true);
		f:SetClampedToScreen(true)
		f:SetWidth(360);
		f:SetHeight(110);
		f:SetBackdrop{
			bgFile='Interface\\DialogFrame\\UI-DialogBox-Background' ,
			edgeFile='Interface\\DialogFrame\\UI-DialogBox-Border',
			tile = true,
			insets = {left = 11, right = 12, top = 12, bottom = 11},
			tileSize = 32,
			edgeSize = 32,
		}
		f:SetPoint('TOP', 0, -80)
		f:Hide()

		local text = f:CreateTitleRegion();
		text:SetAllPoints();

		local header = f:CreateTexture(nil, "ARTWORK");
		header:SetTexture('Interface\\DialogFrame\\UI-DialogBox-Header')
		header:SetWidth(256); header:SetHeight(64)
		header:SetPoint('TOP', 0, 14)

		local title = f:CreateFontString('ARTWORK')
		title:SetFontObject('GameFontNormal')
		title:SetPoint('TOP', header, 'TOP', 0, -14)
		title:SetText(L["额外动作条"])

		local desc = f:CreateFontString('ARTWORK');
		desc:SetFont(font, 12)
		desc:SetTextColor(1, 1, 1);
		desc:SetShadowColor(0, 0, 0);
		desc:SetShadowColor(0.8, -0.8);
		desc:SetJustifyV('TOP');
		desc:SetJustifyH('LEFT');
		desc:SetPoint('TOPLEFT', 18, -32);
		desc:SetPoint('BOTTOMRIGHT', -18, 48);
		desc:SetWidth(300);

		--desc:Set
		desc:SetText(L["提示: 界面已经解锁. 现在你可以移动, 完成后点击锁定."])

		local lock = CreateFrame("CheckButton", "Skylark_LockButton", f, "OptionsButtonTemplate");
		_G[lock:GetName().."Text"]:SetText(L["锁定"]);
		lock:SetScript('OnClick', function(self)
			Skylark:Lock()
			LibStub("AceConfigRegistry-3.0"):NotifyChange("Skylark")
		end)
		lock:SetPoint('BOTTOMRIGHT', -14, 14)

		self.unlock_dialog = f
	end
	self.unlock_dialog:Show()
end

function Skylark:HideUnLockDialog()
	if not self.unlock_dialog then return end
	self.unlock_dialog:Hide();
end

function Skylark:Unlock()
	if self.Locked then
		self.Locked = false
		Skylark.Bar:ForAll("Unlock")
		self:ShowUnLockDialog();
	end
end

function Skylark:Lock()
	if not self.Locked then
		self.Locked = true
		Skylark.Bar:ForAll("Lock")
		self:HideUnLockDialog();
	end
end

function Skylark:CombatLockdown()
	self:Lock()
	LibStub("AceConfigDialog-3.0"):Close("Skylark")
end