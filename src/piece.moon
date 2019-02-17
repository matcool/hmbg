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

		oldShape = @shape
		@shape = newShape

		if @collides!
			@shape = oldShape

	move: (dir) =>
		xOff, yOff = switch dir
			when "left" then -1, 0
			when "right" then 1, 0
			when "down" then 0, 1

		unless @collides dir
			@x += xOff
			@y += yOff
			return true

		return false

	collides: (dir) =>
		colXOff, colYOff = switch dir
			when "left" then -1, 0
			when "right" then 1, 0
			when "down" then 0, 1
			else 0, 0

		for x = @x + colXOff, @x + colXOff + @size - 1
			for y = @y + colYOff, @y + colYOff + @size - 1
				xOff, yOff = x - @x + (-colXOff) + 1, y - @y + (-colYOff) + 1
				if @shape[yOff][xOff] == 1
					-- If is outside field
					if x < 1 or x > @parent.width or y < 1 or y > @parent.height + @parent.hidden
						return true

		return false

	update: (dt) =>
		moved = false

		if Input\hasHeld "game_left", @parent.parent.das / 1000
			if @parent.parent.arr == 0
				while @move "left" do nil
			else
				@parent.parent.arrTimer -= dt
				if @parent.parent.arrTimer <= 0
					@move "left"
					@parent.parent.arrTimer = @parent.parent.arr / 1000

			moved = true
		elseif Input\pressed "game_left"
			@move "left"
			@parent.parent.arrTimer = @parent.parent.arr / 1000

			moved = true

		if (Input\hasHeld "game_right", @parent.parent.das / 1000) and not moved
			if @parent.parent.arr == 0
				while @move "right" do nil
			else
				@parent.parent.arrTimer -= dt
				if @parent.parent.arrTimer <= 0
					@move "right"
					@parent.parent.arrTimer = @parent.parent.arr / 1000
		elseif Input\pressed "game_right"
			@move "right"
			@parent.parent.arrTimer = @parent.parent.arr / 1000

		if Input\pressed "game_harddrop"
			while @move "down" do nil
		if Input\pressed "game_softdrop"
			@move "down"
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