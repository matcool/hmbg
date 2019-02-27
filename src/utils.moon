utils = {}

utils.shrinkColorRange = (color) ->
	color[1] /= 255
	color[2] /= 255
	color[3] /= 255

utils.shuffle = (table) ->
    for i = #table, 1, -1
        r = math.random #table
        table[i], table[r] = table[r], table[i]
    table

utils.copyTable = (table) ->
    return [v for k, v in pairs table]

return utils