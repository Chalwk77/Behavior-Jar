-----------------------------------------------------------------------------------------
-- sketch.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")

function scene:create( event )
    local sceneGroup = self.view

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
    local jar = display.newImage(sceneGroup, "assets/jar.png")
    jar.x = display.contentWidth * 0.5
    jar.y = display.contentHeight * 0.5
    jar:scale(0.50, 0.50)
    -- ========== SCENE BUTTONS ========== --
    local button_group = display.newGroup()
    local add_button = widget.newButton ({
        defaultFile = 'assets/buttons/add_button.png',
        overFile = 'assets/buttons/add_button.png',
        x = display.contentCenterX,
        y = display.contentCenterY,
        onRelease = function()
            SubtractCoin(1)
        end
    })
    add_button:scale(0.3, 0.3)
    button_group:insert(add_button)
    local subtract_button = widget.newButton ({
        defaultFile = 'assets/buttons/subtract_button.png',
        overFile = 'assets/buttons/subtract_button.png',
        x = add_button.x,
        y = add_button.y + 150,
        onRelease = function()
            AddCoin(1)
        end
    })
    subtract_button:scale(0.3, 0.3)
    button_group:insert(subtract_button)
    local Xoffset = 40
    local Yoffset = 70
    button_group.x = button_group.x + screenW - screenH - Xoffset
    button_group.y = button_group.y + screenH - screenH - Yoffset
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
