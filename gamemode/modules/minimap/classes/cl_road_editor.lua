
function RPGM.Classes.RoadEditor()
    local tbl = {
        menuItems = {},
        layers = {},
        showCursor = false,
        connectToCursor = false,
        cursorSnap = 0,
        previewScale = 0.04,
        previewOffsetX = 500,
        previewOffsetY = 500
    }

    function tbl:openMenu()
        self.frame = vgui.Create("DFrame")
        self.frame:SetTitle("RPGM - Road Editor")
        self.frame:SetSize(400, 340)
        self.frame:Center()
        self.frame:MakePopup()

        self.scroller = vgui.Create("DScrollPanel", self.frame)
        self.scroller:Dock(FILL)

        self:gotoMainMenu()

        return self.frame
    end

    function tbl:clearScroller()
        for _, item in ipairs(self.menuItems) do
            if IsValid(item) then item:Remove() end
        end

        table.Empty(self.menuItems)
    end

    function tbl:gotoMainMenu()
        self:clearScroller()
        self:showSelectedLayer()
        self:addButton("View layers", function() self:gotoLayers() end)
        self:addButton("Dump map", function()
            local fileName = "rpgm/map_dumps/map_" .. os.time() .. ".json"

            file.CreateDir("rpgm/map_dumps")
            file.Write(fileName, util.TableToJSON(self.layers))

            RPGM.AddNotification("Map Dumped", "The enitre map was dumped into " .. fileName .. ".", NOTIFY_GENERIC, 5)
        end)
        self:addButton("Import a map", function()
            Derma_StringRequest("RPGM Map Editor", "Enter the file name of your export (MAP ONLY):", "rpgm/map_dumps/map_", function(text)
                if text == "" then return end

                local txt = file.Read(text, "DATA")
                if not txt then
                    RPGM.AddNotification("Map Import Failed", "The specified file was empty.", NOTIFY_ERROR, 5)
                    return
                end

                local data = util.JSONToTable(txt)
                if not data then
                    RPGM.AddNotification("Map Import Failed", "The file contents couldn't be parsed.", NOTIFY_ERROR, 5)
                    return
                end

                RPGM.AddNotification("Map Import Completed", "The map import was performed successfully.", NOTIFY_GENERIC, 5)
                self.layers = data

                hook.Run("RPGM.Minimap.EditorUpdate")
            end, nil, "Submit", "Cancel")
        end)
        self:addLabel("Cursor Snap Amount:")
        self:addSlider(self.cursorSnap, 0, 90, 5, function(s, val)
            self.cursorSnap = val
            hook.Run("RPGM.Minimap.EditorUpdate")
        end)
        self:addButton(self.showCursor and "Disable cursor" or "Enable cursor", function(s)
            self.showCursor = not self.showCursor
            s:SetText(self.showCursor and "Disable cursor" or "Enable cursor")
        end)
        self:addButton(self.connectToCursor and "Disable connect to cursor" or "Enable connect to cursor", function(s)
            self.connectToCursor = not self.connectToCursor
            s:SetText(self.connectToCursor and "Disable connect to cursor" or "Enable connect to cursor")
        end)
        self:addLabel("Preview Scale:")
        self:addSlider(self.previewScale, 0, 2, 10, function(s, val)
            self.previewScale = val
            hook.Run("RPGM.Minimap.EditorUpdate")
        end)
        self:addLabel("Preview Offset (X):")
        self:addSlider(self.previewOffsetX, -2048, 2048, 10, function(s, val)
            self.previewOffsetX = val
            hook.Run("RPGM.Minimap.EditorUpdate")
        end)
        self:addLabel("Preview Offset (Y):")
        self:addSlider(self.previewOffsetY, -2048, 2048, 10, function(s, val)
            self.previewOffsetY = val
            hook.Run("RPGM.Minimap.EditorUpdate")
        end)
    end

    function tbl:gotoLayers()
        self:clearScroller()

        self:addButton("Select a layer", function() self:gotoLayerSelector() end)
        self:addButton("Edit/add layers", function() self:gotoEditLayers() end)
        self:addButton("Import a layer", function()
            Derma_StringRequest("RPGM Map Editor", "Enter the file name of your export (LAYER ONLY):", "rpgm/map_dumps/layer_", function(text)
                if text == "" then return end

                local txt = file.Read(text, "DATA")
                if not txt then
                    RPGM.AddNotification("Layer Import Failed", "The specified file was empty.", NOTIFY_ERROR, 5)
                    return
                end

                local data = util.JSONToTable(txt)
                if not data then
                    RPGM.AddNotification("Layer Import Failed", "The file contents couldn't be parsed.", NOTIFY_ERROR, 5)
                    return
                end

                RPGM.AddNotification("Layer Import Completed", "The layer import was performed successfully.", NOTIFY_GENERIC, 5)
                table.insert(self.layers, data)
            end, nil, "Submit", "Cancel")
        end)

        self:addMenuButton()
    end

    function tbl:gotoLayerSelector()
        self:clearScroller()
        self:showSelectedLayer()

        local hasLayers = false
        for i, layer in ipairs(self.layers) do
            self:addButton("Select layer: " .. self:getLayerName(i), function()
                self.selectedLayer = i
                self:gotoMainMenu()

                hook.Run("RPGM.Minimap.EditorUpdate")
            end)
            hasLayers = true
        end

        if not hasLayers then
            self:addLabel("No layers found.")
        end

        self:addButton("Back to layers menu", function() self:gotoLayers() end)
        self:addMenuButton()
    end

    function tbl:gotoEditLayers()
        self:clearScroller()
        self:showSelectedLayer()

        local hasLayers = false
        for i, layer in ipairs(self.layers) do
            self:addButton("Edit layer: " .. self:getLayerName(i), function() self:gotoLayerEditor(i) end)
            hasLayers = true
        end

        if not hasLayers then
            self:addLabel("No layers found.")
        end

        self:addButton("Add a new layer", function()
            self:requestNumber("Enter a new layer number (This will auto-insert your layer between existing ones):", function(layerNo)
                local layerCount = table.Count(self.layers)
                if layerNo > layerCount then layerNo = layerCount + 1
                elseif layerNo < 1 then layerNo = 1 end

                table.insert(self.layers, layerNo, {roads = {}})
                self.selectedLayer = layerNo

                hook.Run("RPGM.Minimap.EditorUpdate")

                self:gotoLayerEditor(layerNo)
            end, nil, "Submit", "Cancel")
        end)

        self:addButton("Back to layers menu", function() self:gotoLayers() end)
        self:addMenuButton()
    end

    function tbl:gotoLayerEditor(layerNo)
        self:clearScroller()

        local layerName = self:addLabel("Editing layer: " .. self:getLayerName(layerNo))
        self:addButton("Set layer name", function()
            Derma_StringRequest("RPGM Map Editor", "Enter a new layer name:", "", function(text)
                if text == "" then return end
                self.layers[layerNo].name = text
                layerName:SetText("Editing layer: " .. text)
            end, nil, "Submit", "Cancel")
        end)

        self:addButton("Dump layer", function()
            local fileName = "rpgm/map_dumps/layer_" .. self:getLayerName(layerNo) .. "_" .. os.time() ..  ".json"

            file.CreateDir("rpgm/map_dumps")
            file.Write(fileName, util.TableToJSON(self.layers[layerNo]))

            RPGM.AddNotification("Layer Dumped", "The layer was dumped into " .. fileName .. ".", NOTIFY_GENERIC, 5)
        end)

        self:addButton("Delete layer", function()
            if self.selectedLayer == layerNo then self.selectedLayer = nil end
            self.layers[layerNo] = nil
            self:gotoMainMenu()

            hook.Run("RPGM.Minimap.EditorUpdate")
        end)

        self:addButton("Back to layers menu", function() self:gotoLayers() end)
        self:addMenuButton()
    end

    function tbl:getLayerName(layerNo)
        return self.layers[layerNo] and self.layers[layerNo].name or layerNo
    end

    function tbl:requestNumber(subTitle, onComplete, onCancel, submitText, cancelText)
        Derma_StringRequest("RPGM Map Editor", subTitle, "", function(text)
            local num = tonumber(text)
            if not num then
                self:requestNumber(subTitle, onComplete, onCancel, submitText, cancelText)
                return
            end
            onComplete(num)
        end, onCancel, submitText, cancelText)
    end

    function tbl:addLabel(text)
        local label = vgui.Create("DLabel", self.scroller:GetCanvas())
        label:Dock(TOP)
        label:DockMargin(0, 5, 2, 0)
        label:SetAutoStretchVertical(true)

        label:SetText(text)

        table.insert(self.menuItems, label)

        return label
    end

    function tbl:addButton(text, click)
        local button = vgui.Create("DButton", self.scroller:GetCanvas())
        button:Dock(TOP)
        button:DockMargin(0, 5, 2, 0)
        button:SetTall(30)

        button:SetText(text)
        button.DoClick = click

        table.insert(self.menuItems, button)

        return button
    end

    function tbl:addSlider(default, min, max, decimals, valueChange)
        local slider = vgui.Create("DNumSlider", self.scroller:GetCanvas())
        slider:Dock(TOP)
        slider:DockMargin(0, 5, 2, 0)
        slider:SetTall(30)

        slider:SetMinMax(min, max)
        slider:SetDecimals(decimals)
        slider:SetValue(default)

        slider.OnValueChanged = valueChange

        table.insert(self.menuItems, slider)

        return slider
    end

    function tbl:addMenuButton()
        self:addButton("Back to the main menu", function() self:gotoMainMenu() end)
    end

    function tbl:showSelectedLayer()
        self:addLabel("Selected Layer: " .. (self:getLayerName(self.selectedLayer) or "None"))
    end

    return tbl
end