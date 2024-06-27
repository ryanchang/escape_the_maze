extends Area2D

@export var speed:int

var tile_size:Vector2 = Vector2(64.0, 64.0)
var can_move = true
var facing = "right"
var moves = {
		"right": Vector2(1, 0),
		"left": Vector2(-1, 0),
		"up": Vector2(0, -1),
		"down": Vector2(0, 1),
}

@onready var raycasts = {
		"right": $RayCastRight,
		"left": $RayCastLeft,
		"up": $RayCastUp,
		"down": $RayCastDown,
}


func move(dir):
	facing = dir
	print("[move]%s, position: %s, delta: %s"
			% [dir, position + moves[facing] * tile_size, moves[facing] * tile_size])	
	$AnimationPlayer.speed_scale = speed

	if raycasts[facing].is_colliding():
		print("[move]colliding")
		return

	can_move = false
	$AnimationPlayer.play(facing)
	var new_position = position + moves[facing] * tile_size
	var tween = create_tween()
	tween.tween_property($Sprite2D,
			'position',
			new_position,
			1.0 / speed)
	tween.set_trans(tween.TRANS_SINE)
	tween.set_ease(tween.EASE_IN_OUT)
	tween.connect("finished", on_tween_finished)
	position = new_position
	return true


func on_tween_finished():
	can_move = true
