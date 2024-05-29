extends Area2D

@export var speed:int

var tile_size = 64
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
	$AnimationPlayer.playback_speed = speed
	facing = dir
	if raycasts[facing].is_colliding():
		return

	can_move = false
	$AnimationPlayer.play(facing)
	var tween = create_tween()
	tween.tween_property($Sprite2D,
			'position',
			position + moves[facing] * tile_size,
			1.0 / speed)
	tween.set_trans(tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", on_tween_finished)
	return true


func on_tween_finished():
	can_move = true
