class Piece
	new: (parent, type, x=0, y=0) =>
		@parent = parent
		@type = type
		@x = x
		@y = y
		@shape = Shapes[parent.parent.rotationSystem][type]
		@size = #@shape

	rotate: (dir) =>
		-- Space between the square brackets because [[ is multiline comment in Lua
		newShape = [ [0 for _ = 1, @size] for _ = 1, @size ]

		for y = 1, @size
			for x = 1, @size
				if @shape[y][x] == 1
					if dir == "left"
						newShape[@size + 1 - x][y] = 1
					elseif dir == "right"
						newShape[x][@size + 1 - y] = 1

		@shape = newShape

	update: (dt) =>
		if Input\pressed "game_left"
			@x -= 1
		if Input\pressed "game_right"
			@x += 1
		if Input\pressed "game_softdrop"
			@y += 1
		if Input\pressed "game_rotateleft"
			@rotate "left"
		if Input\pressed "game_rotateright"
			@rotate "right"

	draw: =>
		love.graphics.setCanvas @parent.canvas
		love.graphics.setColor Colors[@parent.parent.colors][@type]

		for x = 1, @size
			for y = 1, @size
				if @shape[y][x] == 1
					love.graphics.rectangle "fill", (@x + x - 2) * @parent.cellSize,
						(@y + y - 2 - @parent.hidden) * @parent.cellSize, @parent.cellSize,
						@parent.cellSize

		love.graphics.setCanvas!

return Piece