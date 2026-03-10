_G["BINDING_HEADER_EBONHOLD_HEADER"] = EbonholdLocals.BINDING_HEADER
_G["BINDING_NAME_EBONHOLD_SKILLTREE"] = EbonholdLocals.BINDING_NAME

-- ─── State ────────────────────────────────────────────────────────────────────
local nodeNameCache = {}     -- node frame -> {spell names lowercase}
local nodeBorders   = {}     -- node frame -> {top, bottom, left, right textures}
local nodeDims      = {}     -- node frame -> dark overlay texture
local matchResults  = {}     -- ordered list of matching nodes
local matchIndex    = 0
local isRestoringPlaceholder = false

-- ─── Node Cache ───────────────────────────────────────────────────────────────
local function BuildNodeCache()
    if not skillTreeCanvas then return end
    wipe(nodeNameCache)
    for _, node in ipairs({ skillTreeCanvas:GetChildren() }) do
        if node.spells then
            local names = {}
            for _, spellId in pairs(node.spells) do
                local name = GetSpellInfo(spellId)
                if name then tinsert(names, name:lower()) end
            end
            if #names > 0 then
                nodeNameCache[node] = names
            end
        end
    end
end

-- ─── Border Highlight helpers ─────────────────────────────────────────────────
local BORDER_T = 2

local function GetBorder(node)
    if not nodeBorders[node] then
        -- Create 4 thin red texture strips around the node edges
        local function makeEdge(p1, p2, horizontal)
            local t = node:CreateTexture(nil, "OVERLAY")
            t:SetTexture(1, 0.1, 0.1, 1)
            t:SetPoint(p1, node, p1, 0, 0)
            t:SetPoint(p2, node, p2, 0, 0)
            if horizontal then
                t:SetHeight(BORDER_T)
            else
                t:SetWidth(BORDER_T)
            end
            t:Hide()
            return t
        end
        nodeBorders[node] = {
            makeEdge("TOPLEFT",    "TOPRIGHT",    true),   -- top strip
            makeEdge("BOTTOMLEFT", "BOTTOMRIGHT", true),   -- bottom strip
            makeEdge("TOPLEFT",    "BOTTOMLEFT",  false),  -- left strip
            makeEdge("TOPRIGHT",   "BOTTOMRIGHT", false),  -- right strip
        }
    end
    return nodeBorders[node]
end

local function GetDim(node)
    if not nodeDims[node] then
        local t = node:CreateTexture(nil, "OVERLAY")
        t:SetAllPoints(node)
        t:SetTexture(0, 0, 0, 0.6)
        t:Hide()
        nodeDims[node] = t
    end
    return nodeDims[node]
end

local function ShowBorder(node, show)
    for _, t in ipairs(GetBorder(node)) do
        if show then t:Show() else t:Hide() end
    end
end

-- ─── Scroll Navigation ────────────────────────────────────────────────────────
local function NavigateTo(node)
    if not (node and skillTreeScroll and skillTreeCanvas) then return end

    local nL = node:GetLeft()
    local nT = node:GetTop()
    local cL = skillTreeCanvas:GetLeft()
    local cT = skillTreeCanvas:GetTop()
    if not (nL and cL) then return end

    local nodeX = nL - cL
    local nodeY = cT - nT
    local nW    = node:GetWidth()  or 32
    local nH    = node:GetHeight() or 32
    local sW    = skillTreeScroll:GetWidth()
    local sH    = skillTreeScroll:GetHeight()

    local tX = nodeX - (sW / 2) + (nW / 2)
    local tY = nodeY - (sH / 2) + (nH / 2)

    tX = math.max(0, math.min(tX, skillTreeScroll:GetHorizontalScrollRange()))
    tY = math.max(0, math.min(tY, skillTreeScroll:GetVerticalScrollRange()))

    skillTreeScroll:SetHorizontalScroll(tX)
    skillTreeScroll:SetVerticalScroll(tY)
end

local function NavigateNext()
    if #matchResults == 0 then return end
    matchIndex = matchIndex + 1
    if matchIndex > #matchResults then matchIndex = 1 end
    NavigateTo(matchResults[matchIndex])
    if EbonholdSearchNavBtn then
        EbonholdSearchNavBtn:SetText(matchIndex .. "/" .. #matchResults)
    end
end

-- ─── Search Logic ─────────────────────────────────────────────────────────────
local function ApplySearch(query)
    query = query and query:lower() or ""
    local isEmpty = (query == "")

    wipe(matchResults)
    matchIndex = 0

    for node, names in pairs(nodeNameCache) do
        local matched = false
        if not isEmpty then
            for _, name in ipairs(names) do
                if name:find(query, 1, true) then
                    matched = true
                    break
                end
            end
        end

        if isEmpty then
            ShowBorder(node, false)
            GetDim(node):Hide()
        elseif matched then
            ShowBorder(node, true)
            GetDim(node):Hide()
            tinsert(matchResults, node)
        else
            ShowBorder(node, false)
            GetDim(node):Show()
        end
    end

    if EbonholdSearchNavBtn then
        EbonholdSearchNavBtn:SetText(#matchResults > 0 and ("1/" .. #matchResults) or ">")
    end

    -- Auto-navigate to first result
    if #matchResults > 0 then
        matchIndex = 1
        NavigateTo(matchResults[1])
    end
end

-- ─── Search Box UI ────────────────────────────────────────────────────────────
local function ResetSearchBox()
    if not EbonholdSearchBox then return end
    local placeholder = EbonholdLocals.SEARCH_PLACEHOLDER or "Search skills..."
    isRestoringPlaceholder = true
    EbonholdSearchBox:SetText(placeholder)
    isRestoringPlaceholder = false
    EbonholdSearchBox:SetTextColor(0.5, 0.5, 0.5)
    if EbonholdSearchNavBtn then EbonholdSearchNavBtn:SetText(">") end
    wipe(matchResults)
    matchIndex = 0
    ApplySearch("")
end

local function CreateSearchBox()
    if not skillTreeFrame or EbonholdSearchContainer then return end

    -- Find the best parent
    local applyBtn = _G["skillTreeApplyButton"]
    local parent = applyBtn and applyBtn:GetParent() or _G["skillTreeBottomBar"] or skillTreeFrame
    
    local container = CreateFrame("Frame", "EbonholdSearchContainer", parent)
    container:SetSize(240, 26)
    
    -- Anchor to the RIGHT of the parent (bottom bar)
    container:SetPoint("RIGHT", parent, "RIGHT", -10, 0)

    local placeholder = EbonholdLocals.SEARCH_PLACEHOLDER or "Search skills..."

    -- Navigate / counter button (on the far right)
    local navBtn = CreateFrame("Button", "EbonholdSearchNavBtn", container)
    navBtn:SetSize(42, 22)
    navBtn:SetPoint("RIGHT", container, "RIGHT", 0, 0)
    navBtn:SetNormalFontObject(GameFontNormalSmall)
    navBtn:SetText(">")
    navBtn:GetFontString():SetTextColor(1, 0.82, 0)
    navBtn:SetScript("OnClick", NavigateNext)
    navBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Navigate to next result", 1, 1, 1)
        GameTooltip:Show()
    end)
    navBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- Interactive Icon Button (next to the counter)
    local iconBtn = CreateFrame("Button", nil, container)
    iconBtn:SetSize(20, 20)
    iconBtn:SetPoint("RIGHT", navBtn, "LEFT", -4, 0)
    
    local iconTex = iconBtn:CreateTexture(nil, "OVERLAY")
    iconTex:SetAllPoints()
    iconTex:SetTexture("Interface\\Icons\\ability_hisek_aim")
    
    iconBtn:SetScript("OnClick", NavigateNext)
    iconBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Navigate to next result", 1, 1, 1)
        GameTooltip:Show()
    end)
    iconBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- EditBox (Blizzard native InputBoxTemplate)
    local eb = CreateFrame("EditBox", "EbonholdSearchBox", container, "InputBoxTemplate")
    eb:SetPoint("LEFT",  container, "LEFT",   10,  0)
    eb:SetPoint("RIGHT", iconBtn,   "LEFT",  -6,  0)
    eb:SetHeight(20)
    eb:SetAutoFocus(false)
    eb:SetMaxLetters(50)
    eb:SetText(placeholder)

    eb:SetScript("OnEditFocusGained", function(self)
        if self:GetText() == placeholder then self:SetText("") end
    end)
    eb:SetScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then ResetSearchBox() end
    end)
    eb:SetScript("OnTextChanged", function(self)
        if isRestoringPlaceholder then return end
        local text = self:GetText()
        ApplySearch(text ~= placeholder and text or "")
    end)
    eb:SetScript("OnEscapePressed", function(self)
        self:ClearFocus(); ResetSearchBox()
    end)
    eb:SetScript("OnEnterPressed", function(self)
        self:ClearFocus(); NavigateNext()
    end)
end

-- ─── Hook ─────────────────────────────────────────────────────────────────────
local function HookSkillTreeFrame()
    if not skillTreeFrame then return end
    
    -- We hook OnShow to ensure UI sub-elements like bottomBar are fully loaded
    skillTreeFrame:HookScript("OnShow", function()
        if not EbonholdSearchContainer then
            CreateSearchBox()
        end
        BuildNodeCache()
        ResetSearchBox()
    end)
    
    -- If already visible, try creating it now
    if skillTreeFrame:IsVisible() then
        CreateSearchBox()
    end
end

-- ─── Main addon initialization ───────────────────────────────────────────────

local function Initialize()
    -- Default keybind
    if not GetBindingKey("EBONHOLD_SKILLTREE") then
        SetBinding("SHIFT-N", "EBONHOLD_SKILLTREE")
        SaveBindings(GetCurrentBindingSet() or 1)
        print(EbonholdLocals.MSG_SHORTCUT_SET)
    end

    -- Micro button tooltip: show dynamic keybind in gold
    if SkillTreeMicroButton then
        SkillTreeMicroButton:HookScript("OnEnter", function(self)
            local currentKey = GetBindingKey("EBONHOLD_SKILLTREE")
            if currentKey then
                local title = GameTooltipTextLeft1
                if title and title:GetText() then
                    local color = NORMAL_FONT_COLOR_CODE or "|cffffd200"
                    local close = FONT_COLOR_CODE_CLOSE or "|r"
                    title:SetText(title:GetText() .. " " .. color .. "(" .. GetBindingText(currentKey) .. ")" .. close)
                    GameTooltip:Show()
                end
            end
        end)
    end

    -- Hook skill tree frame (may not exist yet on login)
    if skillTreeFrame then
        HookSkillTreeFrame()
    else
        local waitFrame = CreateFrame("Frame")
        waitFrame:SetScript("OnUpdate", function(wf)
            if skillTreeFrame then
                wf:SetScript("OnUpdate", nil)
                HookSkillTreeFrame()
            end
        end)
    end
end

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", Initialize)
