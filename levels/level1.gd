extends Node2D

@export var Enemy:PackedScene
@export var Pickup:PackedScene

#@onready var items = $Items
var doors = []


func _ready():
	randomize()
	#$Items.hide()
	set_camera_limits()
	#var door_id = $Walls.tile_set.find_tile_by_name("door_red")
	#for cell in $Walls.get_used_cells_by_id(door_id):
	for cell in $TileMap.get_used_cells_by_id(1, 1, Vector2i(0, 0)):
		doors.append(cell)
	spawn_items()
	$Player.connect("dead", game_over)
	$Player.connect("grabbed_key", _on_player_grabbed_key)
	$Player.connect("win", _on_player_win)


func set_camera_limits():
	var map_size = $TileMap.get_used_rect()
	
	# TileMap.cell_size is replaced by TileMap.tile_set.tile_size in Godot 4
	#var cell_size = $Ground.cell_size
	var cell_size = $TileMap.tile_set.tile_size
	
	$Player/Camera2D.limit_left = map_size.position.x * cell_size.x
	$Player/Camera2D.limit_top = map_size.position.y * cell_size.y
	$Player/Camera2D.limit_right = map_size.end.x * cell_size.x
	$Player/Camera2D.limit_bottom = map_size.end.y * cell_size.y


func spawn_items():
	# get_used_cells() takes layer ID as argument
	#for cell in items.get_used_cells(2):
	for cell in $TileMap.get_used_cells(2):
		#var id = items.get_cellv(cell)
		print("cell: %s, local_to_map: %s, map_to_local: %s"
				% [cell, $TileMap.local_to_map(cell), $TileMap.map_to_local(cell)])
		# var type = items.tile_set.tile_get_name(id)
		var type = $TileMap.get_cell_tile_data(2, cell).get_custom_data("type")
		var pos = Vector2i($TileMap.map_to_local(cell)) + $TileMap.tile_set.tile_size/2
		print("pos: %s, type: %s" % [pos, type])
		match type:
			"slime_spawn":
				var s = Enemy.instantiate()
				s.position = pos
				s.tile_size = $TileMap.tile_set.tile_size
				add_child(s)
			"player_spawn":
				$Player.position = pos
				$Player.tile_size = $TileMap.tile_set.tile_size
			"coin", "key_red", "star":
				var p = Pickup.instantiate()
				p.init(type, pos)
				add_child(p)


func game_over():
	pass


func _on_player_win():
	pass


func _on_player_grabbed_key():
	for cell in doors:
		$Walls.set_cellv(cell, -1)
