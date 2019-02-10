GameState = require "gamestate"

love.load = ->
	export state = GameState!

love.update = ->
	state\update!

love.draw = ->
	state\draw!