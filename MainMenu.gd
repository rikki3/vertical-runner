extends Control

@onready var sfxBg = get_node("BackgroundMusic")
@onready var sfxSt = get_node("Start")
@onready var lblVertical = get_node("Vertical")
@onready var lblRunner = get_node("Runner")
@onready var lblGame = get_node("Game")
@onready var lblOver = get_node("Over")
@onready var lblText = get_node("Text")
@onready var lblHigh = get_node("HighScore")
@onready var animFlag = get_node("anim")
@onready var textButton = get_node("VBoxContainer/TextureButton")


var save = FileAccess.open("res://save.dat", FileAccess.WRITE)
var score
var starting

func _load():	
	save = FileAccess.open("res://save.dat", FileAccess.READ)
	score = int(save.get_as_text())
	save.close()

func _ready():
	set_process(true)
	_load()
	starting = false
	sfxBg.play()
	animFlag.play("Flag")
	if _app.isInitialLoad:
		lblGame.hide()
		lblOver.hide()
		if score != null && score > 0:
			lblHigh.set_text(str(score))
			#lblText.show()
			#lblHigh.show()
		else:
			lblText.hide()
			lblHigh.hide()
		lblVertical.show()
		lblRunner.show()
	else:
		lblGame.show()
		lblOver.show()
		if score != null && score > 0:
			lblHigh.set_text(str(score))
			#lblText.show()
			#lblHigh.show()
		else:
			lblText.hide()
			lblHigh.hide()
		lblVertical.hide()
		lblRunner.hide()

func _process(delta):
	if Input.is_action_pressed("ui_up") && !starting:
		starting = true
		textButton.set_texture_normal(textButton.get_texture_hover())
		
		sfxSt.play()
		
func _on_TextureButton_pressed():
	if !starting:
		starting = true
		sfxSt.play()
		
func _on_Start_finished():
	get_tree().change_scene_to_file("res://Stage.tscn")

func _on_anim_animation_finished(anim_name):
	animFlag.play("Flag")
