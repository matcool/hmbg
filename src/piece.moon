class Piece
	new: (parent, type, x=1, y=1) =>
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

	move: (dir) =>
		if dir == "left" and not @collides -1
			@x -= 1
			return true
		elseif dir == "right" and not @collides 1
			@x += 1
			return true

		return false

	collides: (off) =>
		for x = @x + off, @x + off + @size - 1
			for y = @y, @y + @size - 1
				xOff, yOff = x - @x + 1, y - @y + 1
				if @shape[yOff][xOff] == 1
					-- If is outside field
					if x <= 1 or x >= @parent.width
						return true
		return false

	update: (dt) =>
		if Input\pressed "game_left"
			@move "left"
		if Input\pressed "game_right"
			@move "right"
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