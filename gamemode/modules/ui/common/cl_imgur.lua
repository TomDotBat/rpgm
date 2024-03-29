
local materials = {}

file.CreateDir("rpgm")
function RPGM.GetImgur(id, callback, useproxy)
    if materials[id] then return callback(materials[id]) end

    if file.Exists("rpgm/" .. id .. ".png", "DATA") then
        materials[id] = Material("../data/rpgm/" .. id .. ".png", "noclamp smooth")
        return callback(materials[id])
    end

    http.Fetch(useproxy and "https://proxy.duckduckgo.com/iu/?u=https://i.imgur.com" or "https://i.imgur.com/" .. id .. ".png",
        function(body, len, headers, code)
            file.Write("rpgm/" .. id .. ".png", body)
            materials[id] = Material("../data/rpgm/" .. id .. ".png", "noclamp smooth")
            return callback(materials[id])
        end,
        function(error)
            if useproxy then
                materials[id] = Material("nil")
                return callback(materials[id])
            end
            return RPGM.GetImgur(id, callback, true)
        end
    )
end