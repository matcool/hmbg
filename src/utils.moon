utils = {}

utils.shrinkColorRange = (color) ->
	color[1] /= 255
	color[2] /= 255
	color[3] /= 255

return utils