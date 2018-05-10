-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created by: adam
-- Created on: may 8
-- 
-- This file animates 2 characters 
-----------------------------------------------------------------------------------------
local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) 


local playerBullets = {} 

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround1 = display.newImage( "./assets/sprites/land.png" )
theGround1.x = 520
theGround1.y = display.contentHeight
theGround1.id = "the ground"
physics.addBody( theGround1, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround2 = display.newImage( "./assets/sprites/land.png" )
theGround2.x = 1520
theGround2.y = display.contentHeight
theGround2.id = "the ground" 
physics.addBody( theGround2, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

display.setStatusBar(display.HiddenStatusBar)
 
centerX = display.contentWidth * .5
centerY = display.contentHeight * .5

local playerBullets = {} -- Table that holds the players Bullets


local dPad = display.newImage( "./assets/sprites/dpad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 200
dPad.alpha = 0.50
dPad.id = "d-pad"


local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 200
rightArrow.id = "right arrow"

local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 200
leftArrow.id = "left arrow"


local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 200
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

--ninja
local sheetOptionsIdle =
{
    width = 536,
    height = 495,
    numFrames = 10
}
local ninjaBoyAttack = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyAttack.png", sheetOptionsIdle )

local sheetOptionsWalk =
{
    width = 363,
    height = 458,
    numFrames = 10
}
local ninjaBoyJumpRun = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyJumpRun.png", sheetOptionsWalk )


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = ninjaBoyAttack
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = ninjaBoyJumpRun
    }
}

local ninja = display.newSprite( ninjaBoyAttack, sequence_data )
ninja.x = centerX - 500
ninja.y = centerY
ninja.id = "ninja"
physics.addBody( ninja, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
ninja.isFixedRotation = true 
ninja:setSequence( "idle" )
ninja:play()

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninja, { 
            x = 150, 
            y = 0, 
            time = 1000 
            } )
        ninja:setSequence( "walk" )
        ninja:play()
    end

    return true
end

-- rest to idle 
local function resetToIdle (event)
    if event.phase == "ended" then
        ninja:setSequence("idle")
        ninja:play()
        print(reset)
    end
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        
        transition.moveBy( ninja, { 
            x = -150, 
            y = 0, 
            time = 100 
            } )
    end

    return true
end


--robot
local sheetOptionsShoot =
{
    width = 567,
    height = 556,
    numFrames = 4
}
local robotShoot = graphics.newImageSheet( "./assets/spritesheets/robotShoot.png", sheetOptionsShoot )

local sheetOptionsJump =
{
    width = 567,
    height = 556,
    numFrames = 10
}
local robotJump = graphics.newImageSheet( "./assets/spritesheets/robotJump.png", sheetOptionsJump )


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "shoot",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = robotShoot
    },
    {
        name = "jump",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = robotJump
    }
}

local robot = display.newSprite( robotShoot, sequence_data )
robot.x = centerX + 500
robot.y = centerY
robot.id = "robot"
physics.addBody( robot, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
robot.isFixedRotation = true 
robot:setSequence( "shoot" )
robot:play()

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( robot, { 
            x = 0, 
            y = -120, 
            time = 1000 
            } )
        robot:setSequence( "jump" )
        robot:play()
    end

    return true
end

-- rest to idle 
local function resetToIdleRobot (event)
    if event.phase == "ended" then
        robot:setSequence("shoot")
        robot:play()
    end
end

--explostion

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        
        local aSingleBullet = display.newImage( "./assets/sprites/Kunai.png" )
        aSingleBullet.x = ninja.x
        aSingleBullet.y = ninja.y
        physics.addBody( aSingleBullet, 'dynamic' )
        aSingleBullet.isBullet = true
        aSingleBullet.isFixedRotation = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 1500, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

 
local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end


local function checkCharacterPosition( event )
    
    if ninja.y > display.contentHeight + 500 then
        ninja.x = display.contentCenterX - 200
        ninja.y = display.contentCenterY
    end
end

local function checkPlayerBulletsOutOfBounds()
    
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 , -1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y

        if ( ( obj1.id == "robot" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "robot" ) ) then
            
            -- remove the bullet
            local bulletCounter = nil
            
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            --remove character
            robot:removeSelf()
            robot = nil

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "./assets/sounds/8bit_bomb_explosion.wav" )
            local explosionChannel = audio.play( expolsionSound )

            -- make an explosion happen
            -- Table of emitter parameters
            local emitterParams = {
                startColorAlpha = 0.1,
                startParticleSizeVariance = 2,
                startColorGreen = 0.3031555,
                yCoordFlipped = 1,
                blendFuncSource = 770,
                rotatePerSecondVariance = 153.95,
                particleLifespan = 0.7237,
                tangentialAcceleration = -1440.74,
                finishColorBlue = 0.3699196,
                finishColorGreen = 0.5443883,
                blendFuncDestination = 1,
                startParticleSize = 400.95,
                startColorRed = 0.8373094,
                textureFileName = "./assets/sprites/fire.png",
                startColorVarianceAlpha = 1,
                maxParticles = 256,
                finishParticleSize = 540,
                duration = 0.25,
                finishColorRed = 0.3,
                maxRadiusVariance = 72.63,
                finishParticleSizeVariance = 250,
                gravityy = -671.05,
                speedVariance = 90.79,
                tangentialAccelVariance = -420.11,
                angleVariance = -142.62,
                angle = 244.11
            }
            local emitter = display.newEmitter( emitterParams )
            emitter.x = whereCollisonOccurredX
            emitter.y = whereCollisonOccurredY

        end
    end
end



rightArrow:addEventListener( "touch", rightArrow )
leftArrow:addEventListener( "touch", leftArrow )

ninja:addEventListener("sprite", resetToIdle)
robot:addEventListener("sprite", resetToIdleRobot)

jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )