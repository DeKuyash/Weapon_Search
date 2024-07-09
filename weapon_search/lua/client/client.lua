


local weaponsList = {
    ['ПП-шка'] = 'weapon_smg1',
    ['9мм пистолет'] = 'weapon_pistol',
    ['Физган'] = 'weapon_physgun',
    ['Револьвер'] = 'weapon_357',
    ['Дробовик'] = 'weapon_shotgun',
    ['РПГ'] = 'weapon_rpg',
}



local function searchTarget(target)
    local weaponsTarget = target:GetWeapons()

    local temp = {}

    LocalPlayer():PrintMessage(HUD_PRINTTALK, 'У игрока ' .. target:Name() .. ' следующее оружие в инвентаре:')

    for k, v in ipairs(weaponsTarget) do
        table.insert(temp, v:GetClass())
    end

    for k, v in pairs(weaponsList) do
        for j, z in pairs(temp) do
            if z == v then
                LocalPlayer():PrintMessage(HUD_PRINTTALK, k)

                
            end
        end
    end
end


surface.CreateFont('HUDFont', {font = 'Default', size = 24, weight = 54 } ) 

local function searchProgressBar() 

    draw.SimpleText('Обыскиваем...', 'HUDFont', 990, 528, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.RoundedBox(4, 990, 553, 183, 10, Color (255, 255, 255, 200)) 
    draw.RoundedBox(4, 990, 553, math.Clamp(progressbar, 1, 183), 10, Color (0, 161, 255, 200))

    hook.Add("Think", "UpdateValueHook", function()
    if progressbar < 183 then progressbar = progressbar + 1.25  

        end       
    end) 
end


local function buttonCreate()


    local searchButton = vgui.Create('DButton')

    searchButton:SetText('Обыскать игрока')
    searchButton:SetTextColor(Color(255,255,255))
    searchButton:SetPos(1000, 500)
    searchButton:SetSize(100, 30)
    searchButton:MakePopup()

    searchButton.Paint = function()
        draw.RoundedBox(5, 0, 0, 100, 30, Color(41, 128, 185, 250))
    end

    searchButton.DoClick = function()

        local target = LocalPlayer():GetEyeTrace().Entity
        if target:IsPlayer() then
            searchButton:Remove()
            progressbar = 0
            hook.Add('HUDPaint', 'searchProgressBar', searchProgressBar)
            timer.Simple(2.5, function() hook.Remove('HUDPaint', 'searchProgressBar') end)

            timer.Simple(2.5, function()
            searchTarget(target)
            
            end)
        end
    end


end


local holdingTime = 0
local searchButtonActive = false

hook.Add('Think', 'CheckUsePress', function()
    if input.IsKeyDown(KEY_E) then
        if holdingTime == 0 and searchButtonActive == false then
            holdingTime = CurTime()

        elseif CurTime() - holdingTime >= 0.5 and searchButtonActive == false then
            buttonCreate()
            searchButtonActive = true
            holdingTime = 0

        end

    else
        holdingTime = 0
        searchButtonActive = false
    end
end)