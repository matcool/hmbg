Rotation = require "rotation"

class Piece
	new: (parent, type, x=1, y=1) =>
		@parent = parent
		@type = type
		@x = x
		@y = y
		@shape = Shapes[parent.parent.rotationSystem][type]
		@size = #@shape
		@hasSet = false
		@setTimer = 0
		@fallTimer = 0
		@softDropTimer = 0
		-- 0: Spawn state
		-- 1: Clockwise from spawning
		-- 2: 180 rotation from spawning
		-- 3: Counter-clockwise from spawning
		@rotation = 0

	rotate: (dir) =>
		-- Space between the square brackets because [[ is multiline string in Lua
		newShape = [ [0 for _ = 1, @size] for _ = 1, @size ]

		prevRotation = @rotation
		@rotation = (@rotation + if dir == "right" then 1 else -1) % 4

		for y = 1, @size
			for x = 1, @size
				if @shape[y][x] == 1
					if dir == "left"
						newShape[@size + 1 - x][y] = 1
					elseif dir == "right"
						newShape[x][@size + 1 - y] = 1

		oldShape = @shape
		@shape = newShape

		wallkickData = Rotation[@parent.parent.rotationSystem][@type]
		if wallkickData == nil
			wallkickData = Rotation[@parent.parent.rotationSystem]["default"]

		-- TODO: Explain this
		testOffset = (2 * prevRotation + if dir == "right" then 0 else -1) % 8 + 1
		for _, test in pairs wallkickData
			offset = test[testOffset]
			if not @collides nil, offset[1], offset[2]
				@x += offset[1]
				@y += offset[2]
				return

		@shape = oldShape
		@rotation = prevRotation

	move: (dir) =>
		xOff, yOff = switch dir
			when "left" then -1, 0
			when "right" then 1, 0
			when "down" then 0, 1

		unless @collides dir
			@x += xOff
			@y += yOff
			return true

		false

	collides: (dir, colXOff, colYOff) =>
		if colXOff == nil or colYOff == nil
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
					-- If colliding with grid
					if @parent\getCell x, y
						return true

		return false

	set: =>
		for x = 1, @size
			for y = 1, @size
				if @shape[y][x] == 1
					@parent\setCell @x + x - 1, @y + y - 1, @type
		@hasSet = true

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
			@setTimer = @parent.parent.setAfter
		if Input\down "game_softdrop"
			if @softDropTimer >= @parent.parent.softDropAfter
				@move "down"
				@softDropTimer = 0
			@softDropTimer += dt
		else
			@softDropTimer = 0
		if Input\pressed "game_rotateleft"
			@rotate "left"
		if Input\pressed "game_rotateright"
			@rotate "right"

		if @collides "down"
			@fallTimer = 0
			if @setTimer >= @parent.parent.setAfter
				@set!
			@setTimer += dt
		else
			if @parent.parent.fallAfter < 0
				while @move "down" do nil
			else
				if @fallTimer >= @parent.parent.fallAfter
					@move "down"
					@fallTimer = 0
				@fallTimer += dt


	draw: =>
		love.graphics.setCanvas @parent.canvas

		for x = 1, @size
			for y = 1, @size
				if @shape[y][x] == 1
					-- Draw ghost
					love.graphics.setColor [i/2 for _, i in pairs Colors[@parent.parent.colors][@type]]
					oldY = @y
					while @move "down" do nil
					love.graphics.rectangle "fill", (@x + x - 2) * @parent.cellSize,
						(@y + y - 2 - @parent.hidden) * @parent.cellSize, @parent.cellSize,
						@parent.cellSize
					@y = oldY

					love.graphics.setColor Colors[@parent.parent.colors][@type]
					love.graphics.rectangle "fill", (@x + x - 2) * @parent.cellSize,
						(@y + y - 2 - @parent.hidden) * @parent.cellSize, @parent.cellSize,
						@parent.cellSize

		love.graphics.setCanvas!

Piece