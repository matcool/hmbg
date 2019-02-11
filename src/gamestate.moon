State = require "state"
Field = require "field"

class GameState extends State
	new: =>
		@rotationSystem = "SRS"
		@field = Field @rotationSystem

	update: (dt) =>
		@field\update dt

	draw: =>
		@field\draw!
		love.graphics.draw @field.canvas,
			love.graphics.getWidth! / 2 - @field.canvas\getWidth! / 2,
			love.graphics.getHeight! / 2 - @field.canvas\getHeight! /2

return GameState