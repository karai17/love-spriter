--[[
Note:  most of the "meat" of the loading, transformations, interpolation etc. is going on is in libs/Spriter.lua


Copyright (c) 2014, Hardcrawler Games LLC

This library is free software; you can redistribute it and/or modify it
under the terms of the MIT license. See LICENSE for details.

I haven't actually read the MIT license.  I think it's permissive and stuff.  Send me a keg of Newcastle beer if this makes you rich.
--]]

local Spriter = require("libs/Spriter")

local spriterDatas = {}
local spriterDataIndex = 1
local spriterData

local directories = {"GreyGuy"}

local screenWidth = 800
local screenHeight = 600

local fullscreen = false
local inverted = false
local debug = false
local currentAnimation = 1
local interpolation = true 
--For off-screen rendering and flipping (see below
local canvas

function love.keypressed(key)

	--Flip animation
        if key == "i" then
		inverted = not inverted
	end

	--Toggle bones
        if key == "b" then
		debug = not debug
	end

	--Load next spriter file loaded from directories array above
        if key == "l" then
		spriterDataIndex = spriterDataIndex + 1
		if spriterDataIndex > # spriterDatas then
			spriterDataIndex = 1
		end
		spriterData = spriterDatas[ spriterDataIndex ] 
		local animationNames = spriterData:getAnimationNames()
		currentAnimation = 1
		spriterData:setCurrentAnimationName( animationNames[1] )
	end

	--Next animation of current spriterData render
        if key == "n" then
		local animationNames = spriterData:getAnimationNames()
		currentAnimation = currentAnimation + 1
		if currentAnimation > # animationNames then
			currentAnimation = 1
		end
		--Set the first animation found as the active animation
		spriterData:setCurrentAnimationName( animationNames[currentAnimation] )
	end

	--Toggle interpolation
	if key == "p" then
		interpolation = not interpolation
		if interpolation then
			spriterData:setInterpolation( false )
		else
			spriterData:setInterpolation( true )
		end
	end

	--Toggle Fullscreen
        if key == "f" then
                local width, height, flags = love.window.getMode( )
                if fullscreen then
                        love.window.setMode( width, height, {fullscreen=false} )
                        fullscreen = false
                else
                        love.window.setMode( width, height, {fullscreen=true} )
                        fullscreen = true
                end
        end
end

--Called once when program is first loaded
function love.load()
	love.window.setMode( screenWidth, screenHeight )

	--I am using canvases to support flipping spriter animations after rendering regularly.
	--A more fancy-pants approach could be used to render the animations backwards, but this was easier
	--If your video card doesn't support canvases and non-power-of-two canvases, this won't work.
	assert(love.graphics.isSupported("canvas"), "This graphics card does not support canvases.")
	assert(love.graphics.isSupported("npot"), "This graphics card does not support non power-of-two canvases.") 

	 canvas = love.graphics.newCanvas(screenWidth, screenHeight)

	--Load spriterData for all directories specified above
	for i = 1, # directories do
		local directory = directories[i]
		spriterData = Spriter:loadSpriter( "", directory )
		assert(spriterData, "nil spriterData")

		local animationNames = spriterData:getAnimationNames()
		--Set the first animation found as the active animation
		spriterData:setCurrentAnimationName( animationNames[1] )
		spriterDatas[ # spriterDatas + 1 ] = spriterData
	end
	spriterData = spriterDatas[ spriterDataIndex ]
end

--Called once per game "tick" with number of seconds elapsed since last game tick -- generally a floating point like .02114321 or something
function love.update( dt )
	--spriterData must be called with dt (delta time) as floating point seconds -- NOT MILLISECONDS -- for animation to update
	spriterData:update( dt )
end


--Called once per "tick" after update
function love.draw()
	spriterData:setInverted( inverted )
	if inverted then
		--See comments in library.  This value will be dependent on the asset used
		spriterData:setInversionOffset( 900 )
	end
	spriterData:setDebug( debug )
	spriterData:draw( 0, 0 )
	
	local instructions = {
		"F : Toggle full screen",
		"I : Invert animation",
		"B : Toggle Bones",
		"N : Next Animation",
		"P : Toggle interpolation",
		"L : Load another spriter file"
	}

	local y = 100
	for i = 1, #instructions do
		local instruction = instructions[i]
		love.graphics.print( instruction, 10, y)
		y = y + 30
	end
end


