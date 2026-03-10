_G["BINDING_HEADER_EBONHOLD_HEADER"] = "Ebonhold App"
_G["BINDING_NAME_EBONHOLD_SKILLTREE"] = "Abrir/Cerrar Skill Tree"

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    -- Intentamos asignar la tecla SHIFT-N la primera vez que carga el addon
    -- si el usuario aún no tiene un atajo configurado para esta acción.
    local key = GetBindingKey("EBONHOLD_SKILLTREE")
    if not key then
        SetBinding("SHIFT-N", "EBONHOLD_SKILLTREE")
        SaveBindings(GetCurrentBindingSet() or 1)
        print("|cff00ccff[Ebonhold Skill Tree]|r: Se ha configurado el atajo |cffffff00SHIFT+N|r para abrir el árbol de habilidades.")
    end
end)
