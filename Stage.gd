extends Node2D

onready var runner = get_node("KinematicBody2D")
onready var flag = get_node("Area2D")
onready var powerUp1 = get_node("Area2D1")
onready var powerUp2 = get_node("Area2D4")
onready var powerUp3 = get_node("Area2D5")
onready var particles = get_node("Particles2D")
onready var particlesHP = get_node("Particles2D1")
onready var particlesStr = get_node("Particles2D2")
onready var wallR = get_node("Area2D3/RightWall")
onready var soundVi = get_node("Area2D/victory")
onready var soundDe = get_node("Area2D2/death")
onready var soundBg = get_node("BackgroundMusic")
onready var soundPs = get_node("Area2D1/power")
onready var soundGo = get_node("GameOver")
onready var soundOu = get_node("Area2D4/1up")
onready var soundSd = get_node("Speed")
onready var soundIn = get_node("Area2D5/powerInvin")
onready var lblScore = get_node("Score")
onready var lblLives = get_node("Lives")
onready var life1 = get_node("life1")
onready var life2 = get_node("life2")
onready var life3 = get_node("life3")
onready var indiS = get_node("indiSpeed")
onready var indiI = get_node("indiInvin")
onready var anim1 = get_node("Area2D2/AnimationPlayer")
onready var anim2 = get_node("Area2D2/AnimationPlayer2")
onready var anim3 = get_node("Area2D2/AnimationPlayer3")
var oneUp = true
var dead
var jumping
var startingPos
var score
var scene = ""
var lives
var powerSpeed
var powerInvin
var save = File.new()

func _ready():
	set_process_input(true)
	set_process(true)
	startingPos = runner.get_global_pos()
	runner._direction("Climbing", false)
	set_fixed_process(true)
	soundBg.play()
	particles.hide()
	particlesHP.hide()
	powerUp2.hide()
	anim3.play("Spike03")
	indiI.hide()
	indiS.hide()
	
func _fixed_process(delta):
	if dead:
		runner.hide()
		anim1.stop_all()
		anim2.stop_all()
		anim3.stop_all()
	if Input.is_action_pressed("ui_up") && !jumping && !dead:
		if runner.direc == "Left":
			runner.direc = "Right"
		elif runner.direc == "Right":
			runner.direc = "Left"
		jumping = true;
		if !powerSpeed:
			if runner.direc == "Left":
				runner._direction("JumpR", false)
			elif runner.direc == "Right":
				runner._direction("JumpL", false)
		elif powerSpeed:
			if runner.direc == "Left":
				runner._direction("JumpR", true)
			elif runner.direc == "Right":
				runner._direction("JumpL", true)
	if !dead:
		runner._run(runner.motion)

func _on_Area2D_body_enter( body ):
	soundVi.play()
	score = int(lblScore.get_text())+1
	lblScore.set_text(str(score))
	if score == 3:
		OS.delay_msec(650)
		get_tree().change_scene("res://Stage01.tscn")
	else:
		runner.set_global_pos(startingPos)
		runner.direc = "Right"
		jumping = false
		runner._direction("Climbing", powerSpeed)

func _on_Area2D2_body_enter( body ):
	if !powerInvin:
		soundDe.play()
		indiS.hide()
		powerSpeed = false
		soundSd.stop()
		if soundBg.is_paused():
			soundBg.set_paused(false)
		lives = int(lblLives.get_text())-1
		if lives == 0:
			trackLife()
			lblLives.set_text(str(lives))
			Globals.set("initial", false)
			if score != null && Globals.has("score") && Globals.get("score") < score:
				Globals.set("score", score)
			elif score != null && !Globals.has("score"):
				Globals.set("score", score)
			soundGo.play()
			dead = true
		else:
			trackLife()
			lblLives.set_text(str(lives))
			runner.set_global_pos(startingPos)
			runner.direc = "Right"
			jumping = false
			runner._direction("Climbing", false)
		if lives < 3 && oneUp == true:
			powerUp2.show()
	else:
		print("metal clank/spark sfx")

func trackLife():
		if lives == 3:
			life1.show()
			life2.show()
			life3.show()
		elif lives == 2:
			life1.show()
			life2.show()
			life3.hide()
		elif lives == 1:
			life1.show()
			life2.hide()
			life3.hide()
		elif lives == 0:
			life1.hide()
			life2.hide()
			life3.hide()

func _on_Area2D3_body_enter( body ):
	jumping = false
	if !powerSpeed:
		runner._direction("Climbing", false)
	elif powerSpeed:
		runner._direction("Climbing", true)

func _on_Area2D1_body_enter( body ):
	particles.show()
	powerSpeed = true
	soundSd.play()
	soundBg.set_paused(true)
	soundPs.play()
	powerUp1.hide()
	indiS.show()

func _on_power_finished():
	particles.queue_free()
	powerUp1.queue_free()

func _on_GameOver_finished():
	save.open("res://save.dat", 3)
	if Globals.has("score") && int(save.get_as_text()) < Globals.get("score"):
		_save()
	save.close()
	get_tree().change_scene("res://MainMenu.tscn")
	
func _save():
	save.open("res://save.dat", 3)
	save.store_string(str(score))
	save.close()

func _on_Area2D4_body_enter( body ):
	if lives != 3 && lives != null && oneUp == true:
		oneUp = false
		powerUp2.hide()
		particlesHP.show()
		soundOu.play()
		lives = lives + 1
		trackLife()
		lblLives.set_text(str(lives))

func _on_1up_finished():
	particlesHP.queue_free()
	powerUp2.queue_free()

func _on_Area2D5_body_enter( body ):
	indiI.show()
	powerInvin = true
	soundIn.play()

func _on_powerInvin_finished():
	#indiI.hide()
	#powerInvin = false
	particlesStr.queue_free()
	powerUp3.queue_free()