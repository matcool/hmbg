_G.inspect = require "libs.inspect"
_G.input = (require "libs.input")!

GameState = require "gamestate"

-- This function should only run ONCE! Otherwise the binds should be moved elsewhere
love.load = ->
	input\bind "left", "game_left"
	input\bind "right", "game_right"
	export state = GameState!

love.update = (dt) ->
	input\update dt
	state\update!

love.draw = ->
	state\draw!

love.keypressed = ->
	state\keyPressed!