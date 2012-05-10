
local f = CreateFrame'Frame'
f:SetScript('OnEvent', function(self, event, addon)
    if(not AuctionFrameBrowse_Update) then return end
    self:UnregisterAllEvents()

    hooksecurefunc('AuctionFrameBrowse_Update', function()
        local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

        for i = 1, NUM_BROWSE_TO_DISPLAY do
            local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)

            local btn = _G['BrowseButton' .. i]
            if(btn:IsShown()) then
                local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo('list', offset + i)
				
                if(sold and highestBidder > 0) then
                    local namebtn = _G['BrowseButton' .. i .. 'Name']
                    namebtn:SetText(name .. '|cffffff00(已拍)|r')
                end
            end
        end
    end)
end)
f:RegisterEvent'ADDON_LOADED'

