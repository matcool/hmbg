State = require "state"
Field = require "field"

class GameState extends State
	new: =>
		@rotationSystem = "SRS"
		@colors = "SRS"
		@das = 120
		@arr = 0
		@arrTimer = @arr / 1000
		@setAfter = 1
		@fallAfter = 1
		@softDropAfter = 0.1
		@field = Field self

	update: (dt) =>
		@field\update dt

	draw: =>
		@field\draw!
		
		love.graphics.setColor 1, 1, 1
		love.graphics.draw @field.canvas,
			love.graphics.getWidth! / 2 - @field.canvas\getWidth! / 2,
			love.graphics.getHeight! / 2 - @field.canvas\getHeight! / 2

GameState