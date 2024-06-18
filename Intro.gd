onready var introPlayer = get_node("VideoPlayer")
onready var streamPlayer = get_node("StreamPlayer")

func _ready():
	streamPlayer.play()
	introPlayer.play()

func _on_StreamPlayer_finished():
	get_tree().change_scene("res://MainMenu.tscn")