-----------------------------------------------------------------------------------------
-- sketch.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local coin_count
local onTick
local coins = {}

local coindrop = audio.loadSound("coindrop.mp3")

function scene:create( event )
    coins = {["coins"] = {}}
    coins["coins"][1] = {["total"] = 0}
    local sceneGroup = self.view
    local add_button
    local subtract_button

    local topY = display.screenOriginY
    local bottomY = display.contentHeight - display.screenOriginY
    local leftX = display.screenOriginX
    local rightX = display.contentWidth - display.screenOriginX
    local screenW = rightX - leftX
    local screenH = bottomY - topY

    -- ========== SCENE FRAME ========== --
    -- x1, y1, x2, y2
    local r, g, b = 0, 0, 0
    local strokeWidth = 10
    local Y_top = display.newLine(leftX + screenW, topY, rightX - screenW, topY)
    Y_top.strokeWidth = strokeWidth
    Y_top:setStrokeColor(r, g, b)

    local Y_Bottom = display.newLine(leftX + screenW, bottomY, rightX - screenW, bottomY)
    Y_Bottom.strokeWidth = Y_top.strokeWidth
    Y_Bottom:setStrokeColor(r, g, b)

    local X_right = display.newLine(leftX + screenW, topY, leftX + screenW, bottomY)
    X_right.strokeWidth = Y_Bottom.strokeWidth
    X_right:setStrokeColor(r, g, b)

    local X_left = display.newLine(leftX, topY, rightX - screenW, bottomY)
    X_left.strokeWidth = X_right.strokeWidth
    X_left:setStrokeColor(r, g, b)

    -- ========== SCENE BACKGROUND ========== --
    local background = display.newImage(sceneGroup, "assets/backgrounds/background.png")
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local random_number = math.random(1, 7)
    local jar = display.newImage(sceneGroup, "assets/jars/" .. random_number .. ".png")
    jar.x = display.contentWidth * 0.5
    jar.y = display.contentHeight * 0.5
    jar:scale(0.50, 0.50)
    -- ========== SCENE BUTTONS ========== --
    local button_group = display.newGroup()
    x_scale = 0.3
    y_scale = 0.3
    add_button = widget.newButton ({
        defaultFile = 'assets/buttons/add_button.png',
        overFile = 'assets/buttons/add_button.png',
        x = display.contentCenterX,
        y = display.contentCenterY,
        onPress = function()
            transition.to(add_button, {time = 200, xScale = 0.4, yScale = 0.4})
        end,
        onRelease = function()
            AddCoin(1)
            audio.play(coindrop)
            transition.to(add_button, {time = 200, xScale = x_scale, yScale = y_scale})
        end
    })
    add_button:scale(x_scale, y_scale)
    button_group:insert(add_button)
    subtract_button = widget.newButton ({
        defaultFile = 'assets/buttons/subtract_button.png',
        overFile = 'assets/buttons/subtract_button.png',
        x = add_button.x,
        y = add_button.y + 150,
        onPress = function()
            transition.to(subtract_button, {time = 200, xScale = 0.4, yScale = 0.4})
        end,
        onRelease = function()
            SubtractCoin(1)
            transition.to(subtract_button, {time = 200, xScale = x_scale, yScale = y_scale})
        end
    })
    subtract_button:scale(0.3, 0.3)
    button_group:insert(subtract_button)
    local Xoffset = 40
    local Yoffset = 70
    button_group.x = button_group.x + screenW - screenH - Xoffset
    button_group.y = button_group.y + screenH - screenH - Yoffset
end

function AddCoin(number)
    for k, v in pairs(coins["coins"]) do
        if v.total >= 0 then
            coins["coins"][k].total = coins["coins"][k].total + number
            count = v.total
        end
    end
end

function SubtractCoin(number)
    for k, v in pairs(coins["coins"]) do
        if v.total >= 1 then
            coins["coins"][k].total = coins["coins"][k].total - number
            count = v.total
        end
    end
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        Runtime:addEventListener( "enterFrame", onTick)
    end
end

function onTick(event)
    if count then
        coin_count.isVisible = true
        coin_count.text = tostring(count)
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        coin_count.isVisible = false
    elseif ( phase == "did" ) then
    end
end

coin_count = display.newText("", display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 120 )
coin_count:setFillColor(1, 1, 1)
coin_count.x = display.viewableContentWidth / 2 - 220
coin_count.y = display.viewableContentHeight / 2 - 100
coin_count.alpha = 0.20
coin_count.isVisible = false

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
Runtime:addEventListener( "enterFrame", onTick);

return scene
