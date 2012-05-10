
local CC = LibStub('AceAddon-3.0'):NewAddon('wsCC')
local _, ns = ...
_G['wsCC'] = CC

local L = ns.L
ns.CC = CC

local LIBSM = LibStub('LibSharedMedia-3.0')


local defaults = {
    char = {
        enabled = true,
        font = "Friz Quadrata TT",
        font_size = 24,
        min_scale = .75, -- in percentage
        font_size_small = 24,
        cd_text_righttop_if_too_small = true,
    },
}


function CC:OnInitialize()
    self.acedb = LibStub('AceDB-3.0'):New('wsCCDB', defaults)
    self.db = self.acedb.char

    --self:SetupOptions()
end

function CC:SetupOptions()
end

