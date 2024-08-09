-- Инициализация иконок
local icons = {
    "{крест}",
    "{треугольник}",
    "{квадрат}",
    "{звезда}",
    "{ромб}",
    "{полумесяц}"
}

-- Инициализация имени персонажа
local playerName = UnitName("player")

-- Главное окно
local RollerMainFrame = CreateFrame("Frame", "RollerMainFrame", UIParent)
RollerMainFrame:SetSize(150, 150)
RollerMainFrame:SetPoint("CENTER", 0, 0)
RollerMainFrame:SetMovable(true)
RollerMainFrame:EnableMouse(true)
RollerMainFrame:SetClampedToScreen(true)
-- Скрывать окно по умолчанию
RollerMainFrame:Hide()

-- Фон главного окна
local texture = RollerMainFrame:CreateTexture(nil, "BACKGROUND")
texture:SetTexture("Interface/DialogFrame/UI-DialogBox-Background")
texture:SetAllPoints(RollerMainFrame)

-- Название окна
local AddonNameTitle = RollerMainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
AddonNameTitle:SetPoint("CENTER", texture, "CENTER", 0, 60)
AddonNameTitle:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
AddonNameTitle:SetWidth(150)
AddonNameTitle:SetHeight(40)
AddonNameTitle:SetText("|cFF87CEFARoller|r")
AddonNameTitle:SetJustifyH("CENTER")

-- Кнопка закрытия
local ButtonClose = CreateFrame("BUTTON", "ButtonClose", RollerMainFrame, "SecureHandlerClickTemplate")
ButtonClose:SetNormalTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Up")
ButtonClose:SetHighlightTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Highlight")
ButtonClose:SetPushedTexture("Interface/BUTTONS/UI-Panel-MinimizeButton-Down")
ButtonClose:SetSize(32, 32)
ButtonClose:SetPoint("TOPRIGHT", RollerMainFrame, 0, 0)
ButtonClose:SetScript("OnClick", function(self)
    RollerMainFrame:Hide()
end)
ButtonClose:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Закрыть")
    GameTooltip:Show()
end)
ButtonClose:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Кнопка помощи
local ButtonHelp = CreateFrame("BUTTON", "ButtonHelp", RollerMainFrame, "UIPanelButtonTemplate")
ButtonHelp:SetSize(18, 18)
ButtonHelp:SetText("?")
ButtonHelp:SetPoint("TOPLEFT", RollerMainFrame, 6, -6)
ButtonHelp:SetScript("OnClick", function(self)
    print("|cFF87CEFA[Roller] - статы:|r")
	print("|cffff0000Сила (красный крест)|r |cFFF5DEB3- Атака (ОД), Блокирование (ПД), Превозмогание (н. телосложение, ПД), Рывок (ДД).|r")
	print("|cff00ff00Ловкость (зеленый треугольник)|r |cFFF5DEB3- Атака (ОД), Спешка (н. атлетика, ПД), Уклонение (н. акробатика, ПД), Реакция (н. реакция, ПД), Выхватывание (н. реакция, ДД).|r")
	print("|cFF6A5ACDИнтеллект (синий квадрат)|r |cFFF5DEB3- Колдовство (н. сила заклинателя, ОД), Воля (ПД), Анализ (н. анализ, ДД), Обнаружение (н. внимание, ДД).|r")
	print("|cffffff00Дух (желтая звезда)|r |cFFF5DEB3- Воодушевление (+ н. лидерство, ДД), Поддержка (н. поддержка, ДД), Героизм (+ н. героизм, ПД), Стабилизация (+ н. стабилизация, ОД).|r")
	print("|cFF800080Боль (сиреневый ромб)|r |cFFF5DEB3- Обман (ПД), Провокация (н. влияние, ДД), Запугивание (+ н. влияние, ДД), Засада/Удар из тени (н. скрытность, ДД).|r")
	print("|cFF87CEFAУдача (полумесяц)|r |cFFF5DEB3- Удача (ПД), Энергичность (ПД), Концентрация (ОД).|r")
end)
ButtonHelp:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Подсказка")
    GameTooltip:Show()
end)
ButtonHelp:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Бросить дайсы
local ThrowBtn = CreateFrame("BUTTON", "ThrowBtn", RollerMainFrame, "UIPanelButtonTemplate")
ThrowBtn:SetSize(100, 25)
ThrowBtn:SetText("Бросок")
ThrowBtn:SetPoint("BOTTOM", RollerMainFrame, 0, 15)
ThrowBtn:SetFrameLevel(3)
ThrowBtn:SetScript("OnClick", function() DoRoll(tonumber(EditBox:GetText())) end)

-- Надпись "число бросков"
local DiceCountLabel = RollerMainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
DiceCountLabel:SetPoint("CENTER", texture, "CENTER", 0, 40)
DiceCountLabel:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
DiceCountLabel:SetWidth(150)
DiceCountLabel:SetHeight(40)
DiceCountLabel:SetText("Число бросков:")
DiceCountLabel:SetJustifyH("CENTER")

-- Окно ввода числа дайсов
local EditBox = CreateFrame("EditBox", "EditBox", RollerMainFrame, "InputBoxTemplate")
EditBox:SetMultiLine(false)
EditBox:SetAutoFocus(false)
EditBox:EnableMouse(true)
EditBox:SetPoint("CENTER", RollerMainFrame, "CENTER", 0, 15)
EditBox:SetFont("Fonts\\FRIZQT__.TTF", 15)
EditBox:SetJustifyH("CENTER")
EditBox:SetNumeric(true)
EditBox:SetMaxLetters(2)
EditBox:SetWidth(100)
EditBox:SetHeight(20)

-- Чекбокс рейда
local CheckBox = CreateFrame("CheckButton", "CheckBox", RollerMainFrame, "ChatConfigCheckButtonTemplate")
CheckBox:SetPoint("CENTER", 40, -15)

-- Надпись "Рейд?"
local CheckBoxLabel = CheckBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
CheckBoxLabel:SetPoint("CENTER", CheckBox, "CENTER", -20, 0)
CheckBoxLabel:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
CheckBoxLabel:SetWidth(80)
CheckBoxLabel:SetHeight(40)
CheckBoxLabel:SetText("Рейд?")
CheckBoxLabel:SetJustifyH("LEFT")

-- Скрыть/показать окно
function ToggleWindow()
    if RollerMainFrame:IsShown() then
        RollerMainFrame:Hide()
    else
        RollerMainFrame:Show()
    end
end

-- Двигать окно
RollerMainFrame:SetScript("OnMouseDown", function(self)
    self:StartMoving()
end)
RollerMainFrame:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
end)

-- Инициализация команды
SLASH_ICONROLLERCOMMAND1 = "/eledice"
-- Вызов функции по команде
SlashCmdList["ICONROLLERCOMMAND"] = ToggleWindow

-- Основная функция
function DoRoll(count)
    -- Проверка валидности числа
    if not count or count <= 0 or count > 12 then
        print("|cFF87CEFA[Roller]|r |cFFF5DEB3Необходимо ввести значение от 1 до 12.|r")
        return
    end

    -- Инициализация против дублей имени в эмоуте
    local resultMessage = ""
    local prefix = ""

    -- Проверка состояния чекбокса
    if CheckBox:GetChecked() then
        prefix = playerName .. " выбрасывает: "
    end

    -- Цикл для обработки по числу дайсов
    for i = 1, count do
        -- Рандом одного дайса
        local result = math.random(6)
        -- Вытащить иконку по итогу дайса
        local icon = icons[result]
        -- Добавление иконок в сообщение
        resultMessage = resultMessage .. icon
        if i < count then
            resultMessage = resultMessage .. " "
        end
    end

    -- Добавление точки в конец отписи
    resultMessage = resultMessage .. "."

    -- Отправка сообщения
    if CheckBox:GetChecked() then
        -- Отправка в рейд
        SendChatMessage(prefix .. resultMessage, "RAID")
    else
        -- Отправка в эмоут
        SendChatMessage("выбрасывает: " .. resultMessage, "EMOTE")
    end
end