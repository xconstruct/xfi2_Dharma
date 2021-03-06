--[[##########################
	3D Engine
############################]]

-- Camera angles and distance
local camRoll, camPitch, camYaw, camDist = 0, 0, 0, 7

-- Field of view
local eX, eY, eZ = 0, 2, 0

-- lots of additional variables
local sin, cos = math.sin, math.cos

local screenWidth, screenHeight = screen.width(), screen.height()
local sPitch, cPitch, sRoll, cRoll, sYaw, cYaw
local camX, camY, camZ

-- Generate camera specific variables, once per update
local function Precalculate()
	local roll, pitch, yaw = math.rad(camRoll), math.rad(camPitch), math.rad(camYaw)

	-- If anyone knows why these need to be swapped ...
	local tmp = roll
	roll, pitch = pitch, tmp

	-- Reducing CPU time as much as possible
	sPitch, cPitch = sin(pitch), cos(pitch)
	sRoll, cRoll = sin(roll), cos(roll)
	sYaw, cYaw = sin(yaw), cos(yaw)

	-- Generating the camera coordinates relative to center, axes world
	camX, camY, camZ = 0, camDist, 0
	camY, camZ = camY*cRoll - camZ*sRoll, camZ*cRoll + camY*sRoll
	camX, camY = camX*cYaw - camY*sYaw, camY*cYaw + camX*sYaw
end

-- Init the variables once
Precalculate()

-- Get the screen pos of a 3D coordinate
local function WorldToScreen(x, y, z)
	-- Relative to camera, axes still world
	local dX, dY, dZ = x-camX, y-camY, z-camZ

	-- Rotate axes relative to camera - the Y-axis serves as the distance, going in the screen
	local cX = cPitch * (sYaw * dY + cYaw * dX) - sPitch * dZ
	local cY = sRoll * (cPitch * dZ + sPitch * (sYaw * dY + cYaw * dX)) + cRoll * (cYaw * dY - sYaw * dX)
	local cZ = cRoll * (cPitch * dZ + sPitch * (sYaw * dY + cYaw * dX)) - sRoll * (cYaw * dY - sYaw * dX)

	-- Now get the screen coordinates; screenY is the camera 3D Z-coordinate, remember?
	local screenX = (cX - eX) * (eY/cY) * screenWidth/2 + screenWidth/2
	local screenY = (cZ - eZ) * (eY/cY) * screenWidth/2 + screenHeight/2

	return screenX, screenY, cY < 0
end





--[[##########################
	Simple Objects
############################]]

-- Draws a line from (sX, sY, sZ) to (fX, fY, fZ)
function createLine(sX, sY, sZ, fX, fY, fZ, color)
	local x1, y1, vis1 = WorldToScreen(sX, sY, sZ)
	local x2, y2, vis2 = WorldToScreen(fX, fY, fZ)

	if(vis1 and vis2) then
		screen.drawline(x1, y1, x2, y2, color)
	end
end

-- Draws a cube with center at (x, y, z) and the dimensions (xW, yW, zW)
function createCube(x, y, z, xW, yW, zW, color)
	xW, yW, zW = xW/2, yW/2, zW/2

	createLine(x-xW, y-yW, z-zW, x+xW, y-yW, z-zW, color)
	createLine(x-xW, y+yW, z-zW, x+xW, y+yW, z-zW, color)
	createLine(x-xW, y-yW, z-zW, x-xW, y+yW, z-zW, color)
	createLine(x+xW, y-yW, z-zW, x+xW, y+yW, z-zW, color)

	createLine(x-xW, y-yW, z+zW, x+xW, y-yW, z+zW, color)
	createLine(x-xW, y+yW, z+zW, x+xW, y+yW, z+zW, color)
	createLine(x-xW, y-yW, z+zW, x-xW, y+yW, z+zW, color)
	createLine(x+xW, y-yW, z+zW, x+xW, y+yW, z+zW, color)

	createLine(x-xW, y-yW, z-zW, x-xW, y-yW, z+zW, color)
	createLine(x-xW, y+yW, z-zW, x-xW, y+yW, z+zW, color)
	createLine(x+xW, y-yW, z-zW, x+xW, y-yW, z+zW, color)
	createLine(x+xW, y+yW, z-zW, x+xW, y+yW, z+zW, color)
end




--[[##########################
	Dharma magic
		My GUI framework
		not necessary, but helpful
############################]]

-- Loading the library
require "Dharma/core"

-- The background widget, handling all events
local Application = Dharma.New("Widget", "black")
Application:EnableTouch(true, true)

-- Rotate the camera with touchscreen
function Application:OnTouchMove(x, y)
	local lX, lY = self:GetLastTouchPos()

	camYaw = camYaw + (lX-x) * 0.5
	camPitch = camPitch - (lY-y) * 0.5
	Precalculate()

	Application:UpdateScreen()
end

-- Yay, nice color
local darkGray = color.new(50, 50, 50)

-- Draw the 3D objects
function Application:OnDraw()
	Dharma.Classes.Widget.OnDraw(self)

	createLine(-1, 0, 0, 1, 0, 0, Dharma.Colors.red)
	createLine(0, -1, 0, 0, 1, 0, Dharma.Colors.lime)
	createLine(0, 0, -1, 0, 0, 1, Dharma.Colors.yellow)

	createCube(-2, -2, 0, 1, 1, 1, Dharma.Colors.white)
	createCube(-2, -2, 1.5, 0.2, 0.2, 2, Dharma.Colors.white)

	createCube(3, 0, 0, 0.5, 0.5, 0.5, darkGray)
end




--[[##########################
	3D Text
		A Dharma text widget
		with 3D coordinates
############################]]

-- Create the class, inheriting from Text
local Text3D = Dharma.NewClass("Text3D", "Text")

-- The new draw-function
function Text3D:OnDraw()
	self.x, self.y = WorldToScreen(self.wX, self.wY, self.wZ)
	Dharma.Classes.Text.OnDraw(self)
end

-- Function for setting coordinates
function Text3D:SetWorldPos(x, y, z)
	self.wX, self.wY, self.wZ = x, y, z
end

-- Create three instances, one for each axis
Application:New("Text3D", "X", 12, "red"):SetWorldPos(1, 0, 0)
Application:New("Text3D", "Y", 12, "lime"):SetWorldPos(0, 1, 0)
Application:New("Text3D", "Z", 12, "yellow"):SetWorldPos(0, 0, 1)

-- Start the event loop
Application:Loop(10)