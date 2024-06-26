onready var introPlayer = get_node("VideoPlayer")
onready var streamPlayer = get_node("StreamPlayer")

func _ready():
	streamPlayer.play()
	introPlayer.play()
	set_process_input(true)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://MainMenu.tscn")

func _on_StreamPlayer_finished():
	get_tree().change_scene("res://MainMenu.tscn")