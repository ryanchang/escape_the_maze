extends Area2D

var textures = {
		"coin": "res://assets/coin.jpg",
		"key_red": "res://assets/keyRed.jpg",
		"star": "res://assets/star.jpg",	
	}
	
var type


func _ready():
	pass


func init(_type, pos):
	$Sprite2D.texture = load(textures[_type])
	type = _type
	position = pos


func pickup():
	$CollisionShape2D.disabled = true
	var tween = create_tween()
	tween.set_trans(tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Sprite2D,
			'scale',
			Vector2(3, 3),
			0.5)
	tween.tween_property($Sprite2D,
			'modulate',
			Color(1, 1, 1, 0),
			0.5)
	tween.tween_callback(queue_free)
