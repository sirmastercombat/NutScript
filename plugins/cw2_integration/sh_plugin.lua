PLUGIN.name = "CW2 Integration"
PLUGIN.author = "Sir Masters"
PLUGIN.desc = "Basic nutscript integration into CW2"
PLUGIN.AutoGenCW2Items = true --Change this to true if you wish for the plugin to generate the items for ALL CW2 attachments, otherwise false
local cw2stuff = CustomizableWeaponry or {}
	
if(SERVER)then
	local function removeSpecificAttachment(client, wep, attachmentName)
		if(wep.CW20Weapon)then
			for category, data in pairs(wep.Attachments) do
				for key, attachment in ipairs(data.atts) do
					if attachment == attachmentName then
						wep:detach(category)
					end
				end
			end
		end
	end
	local function attachSpecificAttachment(client, wep, attachmentName)
		if(wep.CW20Weapon)then
			for category, data in pairs(wep.Attachments) do
				for key, attachment in ipairs(data.atts) do
					if attachment == attachmentName then
						wep:attach(category, key - 1, false)
					end
				end
			end
		end
	end
end

function cw2stuff:hasAttachment(client, att, lookIn)
	--[[if not self.useAttachmentPossessionSystem then
		return true
	end
	
	lookIn = lookIn or ply.CWAttachments
	
	if lookIn[att] then
		return true
	end
	--]]
	return client:getChar():getInv():hasItem(att)
	--return false
end

local attachmentBase = nut.item.register("base_attachment", nil, true, nil, true )

attachmentBase:hook("drop", function(item)
	if(SERVER)then
		local client = item.player
		for k, v in pairs(client:GetWeapons())do
			removeSpecificAttachment(client, v, item.uniqueID)
		end
	end
end)

if(PLUGIN.AutoGenCW2Items)then
	PLUGIN.AttachmentPrice = {
		["default"] = 30
	}

	for k,v in pairs(cw2stuff.registeredAttachments) do
		local newItemAttachment = nut.item.register(v.name, "base_attachment", false, nil, true )
		newItemAttachment.name = v.displayNameShort--v.displayName
		newItemAttachment.desc = "A " .. v.displayName
		newItemAttachment.category = "Weapon Attachments"
		if(PLUGIN.AttachmentPrice[v.name])then
			newItemAttachment.price = PLUGIN.AttachmentPrice[v.name]
		else
			newItemAttachment.price = PLUGIN.AttachmentPrice["default"]
		end
		if(v.isSuppressor)then
			newItemAttachment.category = "Weapon Silencers"
		end
		if(v.isSight)then
			newItemAttachment.category = "Weapon Sights"
		end 
		newItemAttachment.model = "models/Items/BoxMRounds.mdl"
	end
end