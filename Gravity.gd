extends Node2D

func _ready():
	set_process(true)

func _process(delta):
	set_position(Vector2(get_position().x, get_position().y + 2.35))
	if get_position().y >= 1450:
		queue_free()
