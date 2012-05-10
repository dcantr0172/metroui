-- by yaroot <yaroot AT gmail.com>
local parent, ns = ...
local oUF = WSUF.oUF

local objects = {}

local function update(self)
    self:DisableElement'Portrait'
    if(ns.db.portrait3d) then
        self.Portrait = self.portrait_3d
        self.portrait_2d:Hide()
        self.portrait_3d:Show()
        if(self.portrait_2d.discon) then
            self.portrait_2d.discon:Hide()
        end
    else
        self.Portrait = self.portrait_2d
        self.portrait_2d:Show()
        self.portrait_3d:Hide()
    end

    self:EnableElement'Portrait'
    self.Portrait:ForceUpdate()
end

oUF:RegisterInitCallback(function(self)
    if(self and type(self) == 'table' and self.portrait_3d and self.portrait_2d) then
        tinsert(objects, self)
        update(self)
    end
end)

function ns:Toggle3DPortrait()
    for _, f in ipairs(objects) do
        update(f)
    end
end


