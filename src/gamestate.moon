State = require "state"
Field = require "field"

class GameState extends State
	new: =>
		@field = Field!

	draw: =>
		@field\draw!
		love.graphics.draw @field.canvas,
			love.graphics.getWidth! / 2 - @field.cellSize * @field.width / 2,
			love.graphics.getHeight! / 2 - @field.cellSize * @field.height /2

return GameState