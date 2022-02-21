extends Node2D

# variables
export var roofSize : Vector2 = Vector2.ZERO
var tileId : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# get the real world size
	var worldSize = $TileMap.map_to_world(roofSize) - Vector2(16, 16)
	var realWorldSize = worldSize * 0.85
	
	# adjust the RoofArea
	var roofAreaSize = Vector2((realWorldSize.x / 2), realWorldSize.y / 2)
	var roofAreaPosition = Vector2((worldSize.x + 16) / 2, ((worldSize.y + 16) / 2) - 3)
	$TileMap/Roof_Area/CollisionShape2D.shape.extents = roofAreaSize
	$TileMap/Roof_Area/CollisionShape2D.position = roofAreaPosition
	
	# adjust the HouseArea
	var houseAreaSize = Vector2((worldSize.x / 4) + 15, (worldSize.y / 4) - 4)
	var houseAreaPosition = Vector2(worldSize.x / 2, (worldSize.y / 2) + 8)
	$TileMap/House_Area/CollisionShape2D.shape.extents = houseAreaSize
	$TileMap/House_Area/CollisionShape2D.position = houseAreaPosition

	# create the roof
	for x in range(roofSize.x):
		for y in range(roofSize.y):
			var halfRoof = round(roofSize.y / 2) - 1
			
			if (x == 0 && y == 0):
				tileId = $TileMap.tile_set.find_tile_by_name("0")
				$TileMap.set_cell(x, y, tileId)
			
			if (x > 0 && x < (roofSize.x - 1) && y == 0):
				tileId = $TileMap.tile_set.find_tile_by_name("1")
				$TileMap.set_cell(x, y, tileId)
			
			if (x == (roofSize.x - 1) && y == 0):
				print("tile 2")
				tileId = $TileMap.tile_set.find_tile_by_name("2")
				$TileMap.set_cell(x, y, tileId)
			
			if (x == 0 && y > 0 && y < halfRoof):
				tileId = $TileMap.tile_set.find_tile_by_name("3")
				$TileMap.set_cell(x, y, tileId)
			
			if (x > 0 && y > 0 && y < halfRoof):
				tileId = $TileMap.tile_set.find_tile_by_name("4")
				$TileMap.set_cell(x, y, tileId)
			
			if (x == (roofSize.x - 1) && y > 0 && y < halfRoof):
				tileId = $TileMap.tile_set.find_tile_by_name("5")
				$TileMap.set_cell(x, y, tileId)
			
			if (x == 0 && y == halfRoof):
				tileId = $TileMap.tile_set.find_tile_by_name("6")
				$TileMap.set_cell(x, y, tileId)
			
			if (x > 0 && y == halfRoof):
				tileId = $TileMap.tile_set.find_tile_by_name("7")
				$TileMap.set_cell(x, y, tileId)
			
			if (x == (roofSize.x - 1) && y == halfRoof):
				tileId = $TileMap.tile_set.find_tile_by_name("8")
				$TileMap.set_cell(x, y, tileId)
			
			if (x == 0 && y > halfRoof && y < (roofSize.y - 1)):
				tileId = $TileMap.tile_set.find_tile_by_name("9")
				$TileMap.set_cell(x, y, tileId)
			
			if (x > 0 && y > halfRoof && y < (roofSize.y - 1)):
				tileId = $TileMap.tile_set.find_tile_by_name("10")
				$TileMap.set_cell(x, y, tileId)
			
			if (x == (roofSize.x - 1) && y > halfRoof && y < (roofSize.y - 1)):
				tileId = $TileMap.tile_set.find_tile_by_name("11")
				$TileMap.set_cell(x, y, tileId)
				
			if (x == 0 && y == (roofSize.y - 1)):
				tileId = $TileMap.tile_set.find_tile_by_name("12")
				$TileMap.set_cell(x, y, tileId)
			
			if (x > 0 && y == (roofSize.y - 1)):
				tileId = $TileMap.tile_set.find_tile_by_name("13")
				$TileMap.set_cell(x, y, tileId)
				
			if (x == (roofSize.x - 1) && y == (roofSize.y - 1)):
				tileId = $TileMap.tile_set.find_tile_by_name("14")
				$TileMap.set_cell(x, y, tileId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
