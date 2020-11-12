
local categories = {}

function RPGM.AddCategory(classType, categoryName, color, order)
    if not categoryName then return end
    if not categories[classType] then categories[classType] = {} end

    categories[classType][categoryName] = {
        color = color,
        order = order
    }
end