local locale = GetLocale()

local translations = {
    -- Default (English)
    enUS = {
        MSG_SHORTCUT_SET = "|cff00ccff[Ebonhold Skill Tree]|r: Shortcut |cffffff00SHIFT+N|r configured to open the skill tree.",
        TOOLTIP_SHORTCUT = "Shortcut: ",
        SEARCH_PLACEHOLDER = "Search skills...",
        BINDING_HEADER = "Ebonhold App",
        BINDING_NAME = "Toggle Skill Tree"
    },
    -- Spanish
    esES = {
        MSG_SHORTCUT_SET = "|cff00ccff[Ebonhold Skill Tree]|r: Se ha configurado el atajo |cffffff00SHIFT+N|r para abrir el árbol de habilidades.",
        TOOLTIP_SHORTCUT = "Atajo: ",
        SEARCH_PLACEHOLDER = "Buscar habilidades...",
        BINDING_HEADER = "Aplicación Ebonhold",
        BINDING_NAME = "Abrir/Cerrar Árbol de Habilidades"
    },
    esMX = { -- Same as esES for Latin American clients
        MSG_SHORTCUT_SET = "|cff00ccff[Ebonhold Skill Tree]|r: Se ha configurado el atajo |cffffff00SHIFT+N|r para abrir el árbol de habilidades.",
        TOOLTIP_SHORTCUT = "Atajo: ",
        SEARCH_PLACEHOLDER = "Buscar habilidades...",
        BINDING_HEADER = "Aplicación Ebonhold",
        BINDING_NAME = "Abrir/Cerrar Árbol de Habilidades"
    },
    -- French
    frFR = {
        MSG_SHORTCUT_SET = "|cff00ccff[Ebonhold Skill Tree]|r: Le raccourci |cffffff00SHIFT+N|r a été configuré pour ouvrir l'arbre de compétences.",
        TOOLTIP_SHORTCUT = "Raccourci: ",
        SEARCH_PLACEHOLDER = "Rechercher des compétences...",
        BINDING_HEADER = "App Ebonhold",
        BINDING_NAME = "Afficher/Masquer l'arbre de compétences"
    },
    -- German
    deDE = {
        MSG_SHORTCUT_SET = "|cff00ccff[Ebonhold Skill Tree]|r: Der Hotkey |cffffff00SHIFT+N|r wurde konfiguriert, um den Talentbaum zu öffnen.",
        TOOLTIP_SHORTCUT = "Tastenkürzel: ",
        SEARCH_PLACEHOLDER = "Fähigkeiten suchen...",
        BINDING_HEADER = "Ebonhold App",
        BINDING_NAME = "Talentbaum umschalten"
    },
    -- Russian
    ruRU = {
        MSG_SHORTCUT_SET = "|cff00ccff[Ebonhold Skill Tree]|r: Горячая клавиша |cffffff00SHIFT+N|r настроена для открытия древа талантов.",
        TOOLTIP_SHORTCUT = "Горячая клавиша: ",
        SEARCH_PLACEHOLDER = "Поиск способностей...",
        BINDING_HEADER = "Приложение Ebonhold",
        BINDING_NAME = "Открыть/Закрыть Древо Талантов"
    },
    -- Italian
    itIT = {
        MSG_SHORTCUT_SET = "|cff00ccff[Ebonhold Skill Tree]|r: La scorciatoia |cffffff00SHIFT+N|r è stata configurata per aprire l'albero delle abilità.",
        TOOLTIP_SHORTCUT = "Scorciatoia: ",
        SEARCH_PLACEHOLDER = "Cerca abilità...",
        BINDING_HEADER = "App Ebonhold",
        BINDING_NAME = "Mostra/Nascondi Albero delle Abilità"
    }
}

-- Fallback to EN if locale is missing
EbonholdLocals = translations[locale] or translations["enUS"]
