-- by yaroot <yaroot AT gmail.com>


local parent, ns = ...
local oUF = ns.oUF

local function Update(self, event)
    local shown = self.VehicleTexture:IsShown()
    local vehicle = self.realUnit and UnitInVehicle(self.realUnit)

    if(vehicle) then
        if(event == 'PLAYER_ENTERING_WORLD' or not shown) then
            self.VehicleTexture:Show()
            self.VehicleTextureNormal:Hide()

            if(self.VehicleTexture.PostUpdate) then
                self.VehicleTexture:PostUpdate(event, true)
            end
        end
    else
        if(event == 'PLAYER_ENTERING_WORLD' or shown) then
            self.VehicleTexture:Hide()
            self.VehicleTextureNormal:Show()

            if(self.VehicleTexture.PostUpdate) then
                self.VehicleTexture:PostUpdate(event)
            end
        end
    end
end

local function Enable(self)
    if(self.VehicleTexture) then
        -- nothing to do
        -- oUF will add <Update> to self.__elements
        -- so that the frame will be updated
        -- everytime the unit changed
        self.VehicleTexture:Hide()

        return true
    end
end

local function Disable(self)
    -- nothing to do
end

oUF:AddElement('VehicleTexture', Update, Enable, Disable)




