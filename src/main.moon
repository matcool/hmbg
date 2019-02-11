_G.inspect = require "libs.inspect"
_G.Input = (require "libs.input")!

_G.Shapes = require "shapes"
_G.Colors = require "colors"
_G.Utils = require "utils"

GameState = require "gamestate"

-- This function should only run once
love.load = ->
	-- Make canvases not do weird opacity stuff
	love.graphics.setBlendMode "replace", "premultiplied"

	-- Fix colors to have 0-1 range instead of 0-255
	for _, __ in pairs Colors
		for _, color in pairs __
			Utils.shrinkColorRange color

	Input\bind "left", "game_left"
	Input\bind "right", "game_right"

	export state = GameState!

love.update = (dt) ->
	Input\update dt
	state\update!

love.draw = ->
	state\draw!

love.keypressed = ->
	state\keyPressed!