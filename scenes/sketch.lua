-----------------------------------------------------------------------------------------
-- sketch.lua
-- (c) 2018, Behavior Jar, Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local sounds = require("assets.libraries.sounds")

local topY = display.screenOriginY
local bottomY = display.contentHeight - display.screenOriginY
local leftX = display.screenOriginX
local rightX = display.contentWidth - display.screenOriginX
local screenW = rightX - leftX
local screenH = bottomY - topY

local coin_count
local count
local onTick
local jar
local coins = {}
local objects = {}
local physics = require( "physics" )
physics.start()

physics_paramaters = {
    density = 5.0,
    friction = 0.3,
    bounce = 0.5
}

function scene:create( event )
    coins = {["coins"] = {}}
    coins["coins"][1] = {["total"] = 0}
    count = loadCoins()
    coin_count = display.newText(count, display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 22 )
    coin_count:setFillColor(139 / 255, 69 / 255, 19 / 255)
    coin_count.x = display.viewableContentWidth / 2 - 220
    coin_count.y = display.viewableContentHeight / 2 - 130
    coin_count.alpha = 0.20
    if count ~= 0 and count ~= nil then
        for i = 1, count do
            local coin_img = {"1.png", "2.png", "3.png", "4.png", "5.png", "6.png", "7.png", "8.png", "9.png", "10.png"}
            local img = coin_img[math.random(1, #coin_img)]
            objects[#objects + 1] = display.newImage("assets/coins/" .. img, display.contentCenterX, display.contentCenterY - 100)
            coin_img = objects[#objects]
            coin_img.width = 34
            coin_img.height = 34
            coin_img.rotation = math.random(0, 360)
            coin_img.linearDamping = 0.10
            coin_img.angularDamping = 0.6
            coin_img.rotation = math.random( 1, 360 )
            physics.addBody(coin_img, physics_paramaters)
            for k, v in pairs(coins["coins"]) do
                if v.total >= 0 then
                    coins["coins"][k].total = coins["coins"][k].total + 1
                    count = #objects
                end
            end
        end
    end
    local sceneGroup = self.view
    local add_button
    local subtract_button
    -- ========== SCENE FRAME ========== --
    local frame_group = display.newGroup()
    local r, g, b = 100 / 255, 25 / 255, 120 / 255
    local strokeWidth = 10
    local Y_top = display.newLine(leftX + screenW, topY, rightX - screenW, topY)
    Y_top.strokeWidth = strokeWidth
    Y_top:setStrokeColor(r, g, b)
    physics.addBody(Y_top, "static", {friction = 0.5, bounce = 0.3})

    local Y_Bottom = display.newLine(leftX + screenW, bottomY, rightX - screenW, bottomY)
    Y_Bottom.strokeWidth = Y_top.strokeWidth
    Y_Bottom:setStrokeColor(r, g, b)
    physics.addBody(Y_Bottom, "static", {friction = 0.5, bounce = 0.3})

    local X_right = display.newLine(leftX + screenW, topY, leftX + screenW, bottomY)
    X_right.strokeWidth = Y_Bottom.strokeWidth
    X_right:setStrokeColor(r, g, b)
    physics.addBody(X_right, "static", {friction = 0.5, bounce = 0.3})

    local X_left = display.newLine(leftX, topY, rightX - screenW, bottomY)
    X_left.strokeWidth = X_right.strokeWidth
    X_left:setStrokeColor(r, g, b)
    physics.addBody(X_left, "static", {friction = 0.5, bounce = 0.3})

    -- frame_group:insert(Y_top)
    -- frame_group:insert(Y_Bottom)
    -- frame_group:insert(X_right)
    -- frame_group:insert(X_left)
    -- frame_group.strokeWidth = 50
    -- frame_group:setStrokeColor(r, g, b)
    -- physics.addBody(frame_group, "static", {friction = 0.5, bounce = 0.3})

    -- ========== SCENE BACKGROUND ========== --
    background = display.newImage(sceneGroup, "assets/backgrounds/background.png")
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local random_number = math.random(1, 7)
    jar = display.newImage(sceneGroup, "assets/jars/" .. random_number .. ".png")
    jar.x = display.contentWidth * 0.5
    jar.y = display.contentHeight * 0.5
    jar:scale(0.50, 0.50)
    -- ========== SCENE BUTTONS ========== --
    local button_group = display.newGroup()
    x_scale = 0.3
    y_scale = 0.3
    add_button = widget.newButton ({
        defaultFile = 'assets/buttons/add_button.png',
        overFile = 'assets/buttons/add_button-over.png',
        x = display.contentCenterX,
        y = display.contentCenterY,
        onPress = function()
            transition.to(add_button, {time = 100, xScale = 0.5, yScale = 0.5})
        end,
        onRelease = function()
            AddCoin(1)
            sounds.play("coindrop" .. math.random(1, 6))
            transition.to(add_button, {time = 100, xScale = x_scale, yScale = y_scale})
        end
    })
    add_button:scale(x_scale, y_scale)
    button_group:insert(add_button)
    subtract_button = widget.newButton ({
        defaultFile = 'assets/buttons/subtract_button.png',
        overFile = 'assets/buttons/subtract_button-over.png',
        x = add_button.x,
        y = add_button.y + 150,
        onPress = function()
            transition.to(subtract_button, {time = 100, xScale = 0.5, yScale = 0.5})
        end,
        onRelease = function()
            SubtractCoin(1)
            sounds.play("takeaway")
            transition.to(subtract_button, {time = 100, xScale = x_scale, yScale = y_scale})
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
    local coinGfx = {"1.png", "2.png", "3.png", "4.png", "5.png", "6.png", "7.png", "8.png", "9.png", "10.png"}
    randImage = coinGfx[math.random(1, #coinGfx)]
    objects[#objects + 1] = display.newImage("assets/coins/" .. randImage, display.contentCenterX, display.contentCenterY - 100)
    local coin = objects[#objects]
    coin.width = 34
    coin.height = 34
    physics.addBody(coin, physics_paramaters)
    coin.linearDamping = 0.10
    coin.angularDamping = 0.6
    coin.rotation = math.random( 1, 360 )
    for k, v in pairs(coins["coins"]) do
        if v.total >= 0 then
            coins["coins"][k].total = coins["coins"][k].total + number
            count = #objects
        end
    end
    saveCoins(count)
end

function SubtractCoin(number)
    for i = 1, 1 do
        local oneDisk = objects[i]
        if (oneDisk and oneDisk.x) then
            oneDisk:removeSelf()
            table.remove(objects, i)
        end
    end
    for k, v in pairs(coins["coins"]) do
        if v.total >= 1 then
            coins["coins"][k].total = coins["coins"][k].total - number
            count = #objects
        end
    end
    saveCoins(count)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        Runtime:addEventListener( "enterFrame", onTick)
        local offset = 184
        local hide = false
        local frame_left = display.newLine(leftX + offset, topY, rightX - screenW + offset, bottomY)
        frame_left.strokeWidth = 5
        frame_left:setStrokeColor(0, 0, 0)
        frame_left.isVisible = hide

        local frame_right = display.newLine(leftX + screenW - offset, topY, leftX + screenW - offset, bottomY)
        frame_right.strokeWidth = 5
        frame_right:setStrokeColor(0, 0, 0)
        frame_right.isVisible = hide

        local bottom_pos = 25
        local frame_bottom = display.newLine(leftX + screenW - 184, bottomY - bottom_pos, rightX - screenW + 184, bottomY - bottom_pos)
        frame_bottom.strokeWidth = 5
        frame_bottom:setStrokeColor(0, 0, 0)
        frame_bottom.isVisible = hide

        local top_pos = 90
        local frame_top = display.newLine(leftX + screenW - 300, topY + top_pos - 90, rightX - screenW + 184, topY + top_pos)
        frame_top.strokeWidth = 5
        frame_top:setStrokeColor(0, 0, 0)
        frame_top.isVisible = hide
        local frame_top2 = display.newLine(leftX + screenW - 184, topY + top_pos, rightX - screenW + 300, topY + top_pos - 90)
        frame_top2.strokeWidth = 5
        frame_top2:setStrokeColor(0, 0, 0)
        frame_top2.isVisible = hide

        physics.addBody(frame_top, "static", {friction = 0.0, bounce = 0.3})
        physics.addBody(frame_top2, "static", {friction = 0.0, bounce = 0.3})
        physics.addBody(frame_bottom, "static", {friction = 0.0, bounce = 0.3})
        physics.addBody(frame_left, "static", {friction = 0.0, bounce = 0.3})
        physics.addBody(frame_right, "static", {friction = 0.0, bounce = 0.3})
    end
    local height_from_bottom = -100
    local yPos = display.contentCenterX + display.contentCenterY + height_from_bottom
    local text_render = display.newText("Shakira's Behavior Jar", display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 14)
    text_render:setFillColor(100 / 255, 25 / 255, 120 / 255)
    text_render.x = rightX - screenW + 95
    text_render.y = yPos + 2
end

function onTick(event)
    if count then
        coin_count.isVisible = true
        coin_count.text = "Coins: " .. tostring(count)
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

function loadCoins()
    local path = system.pathForFile("coins.txt", system.DocumentsDirectory)
    local file = io.open ( path, "r" )
    local sum
    if file == nil then return 0 end
    local contents = file:read( "*a" )
    file:close()
    for i = 1, string.len(contents) do sum = tonumber(contents) end
    if sum == 0 or sum == nil then sum = 0 end
    return sum
end

function saveCoins(c)
    local path = system.pathForFile( "coins.txt", system.DocumentsDirectory )
    local file = io.open (path, "w")
    local contents = tostring(c)
    file:write(contents)
    file:close( )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
Runtime:addEventListener( "enterFrame", onTick);

return scene
