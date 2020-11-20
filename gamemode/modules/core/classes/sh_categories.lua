
local categories = {}

function RPGM.AddCategory(classType, name, color, order)
    if not name then return end
    if not categories[classType] then categories[classType] = {} end
    if categories[classType][name] and not table.IsEmpty(categories[classType][name]) then return end

    categories[classType][name] = {
        color = color or color_white,
        order = order or 0
    }
end

function RPGM.GetCategories()
    return categories
end

function RPGM.GetClassCategories(classType)
    return categories[classType]
end