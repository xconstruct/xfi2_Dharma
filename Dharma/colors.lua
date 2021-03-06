--[[!

	@name		Dharma
	@author		Constantin Schomburg <xconstruct@gmail.com>
	@version	0.1

	@section DESCRIPTION

	Dharma is a framework for Creative Zen X-Fi 2 Applications.
	The core introduces methods for creating OOP classes and
	handles loading of additional files, including the GUI widgets.

	@section LICENSE

    Dharma: A Framework for Creative Zen X-Fi 2 Applications

    Copyright (C) 2010  Constantin Schomburg <xconstruct@gmail.com>

    This file is part of Dharma.

    Dharma is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Dharma is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dharma.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[!
	@section Colors
	Holds all colorStrings and their color-tables
]]

local Colors = {
	aqua	= color.new(0x00,0xFF,0xFF),
	black	= color.new(0x00,0x00,0x00),
	blue	= color.new(0x00,0x00,0xFF),
	fuchsia	= color.new(0xFF,0x00,0xFF),
	gray	= color.new(0x80,0x80,0x80),
	green	= color.new(0x00,0x80,0x00),
	lime	= color.new(0x00,0xFF,0x00),
	maroon	= color.new(0x80,0x00,0x00),
	navy	= color.new(0x00,0x00,0x80),
	olive	= color.new(0x80,0x80,0x00),
	purple	= color.new(0x80,0x00,0x80),
	red		= color.new(0xFF,0x00,0x00),
	silver	= color.new(0xC0,0xC0,0xC0),
	teal	= color.new(0x00,0x80,0x80),
	white	= color.new(0xFF,0xFF,0xFF),
	yellow	= color.new(0xFF,0xFF,0x00),
}

Dharma.Colors = Colors