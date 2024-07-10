extends Node2D

@onready var runner = get_node("CharacterBody2D")
@onready var flag = get_node("Area2D")
@onready var powerUp1 = get_node("Area2D1")
@onready var powerUp2 = get_node("Area2D4")
@onready var powerUp3 = get_node("Area2D5")
@onready var powerUp4 = get_node("Area2D6")
@onready var particles = get_node("GPUParticles2D")
@onready var particlesHP = get_node("Particles2D1")
@onready var particlesStr = get_node("Particles2D2")
@onready var particlesSlw = get_node("Particles2D3")
@onready var wallR = get_node("Area2D3/RightWall")
@onready var soundVi = get_node("Area2D/victory")
@onready var soundDe = get_node("Area2D2/death")
@onready var soundBg = get_node("BackgroundMusic")
@onready var soundPs = get_node("Area2D1/power")
@onready var soundGo = get_node("GameOver")
@onready var soundOu = get_node("Area2D4/1up")
@onready var soundSd = get_node("Speed")
@onready var soundIn = get_node("Area2D5/powerInvin")
@onready var soundSl = get_node("Area2D6/powerSlow")
@onready var lblScore = get_node("Score")
@onready var lblLives = get_node("Lives")
@onready var life1 = get_node("life1")
@onready var life2 = get_node("life2")
@onready var life3 = get_node("life3")
@onready var indiS = get_node("indiSpeed")
@onready var indiI = get_node("indiInvin")
@onready var indiSl = get_node("indiSlow")
@onready var timerSpawnSpike = get_node("TimerSpawnSpike")

var oneUp = true
var dead
var jumping
var startingPos
var score
var scene = ""
var lives
var powerSpeed
var powerInvin
var powerSlow
var save = FileAccess.open("res://save.dat", FileAccess.WRITE_READ)
var rng = RandomNumberGenerator.new()
var rngVal
var sceneSpike

func duplicateObjectAtPosition(posLR):
	if posLR:
		sceneSpike = preload("res://TestSpike.tscn")
	else:
		sceneSpike = preload("res://TestSpikeR.tscn")
	var duplicatedObject = sceneSpike.instantiate()
	duplicatedObject.get_node("Area2D2").connect("body_entered", _on_area_2d_2_body_entered)
	add_child(duplicatedObject)

func _ready():
	set_process_input(true)
	set_process(true)
	startingPos = runner.get_global_position()
	runner._direction("Climbing", false, false)
	#set_physics_process(true)
	soundBg.play()
	particles.hide()
	particlesHP.hide()
	particlesSlw.hide()
	particlesStr.hide()
	powerUp2.hide()
	#powerUp3.hide()
	indiI.hide()
	indiS.hide()
	indiSl.hide()
	
func _physics_process(delta):
	if timerSpawnSpike.get_time_left() == 0:
		rngVal = rng.randi_range(0,1)
		if rngVal == 0:
			duplicateObjectAtPosition(true)
		else:
			duplicateObjectAtPosition(false)
		timerSpawnSpike.start()
	if dead:
		runner.hide()
	if Input.is_action_pressed("ui_up") && !jumping && !dead:
		if runner.direc == "Left":
			runner.direc = "Right"
		elif runner.direc == "Right":
			runner.direc = "Left"
		jumping = true;
		if runner.direc == "Left":
			runner._direction("JumpR", powerSpeed, powerSlow)
		elif runner.direc == "Right":
			runner._direction("JumpL", powerSpeed, powerSlow)
#		if !powerSpeed && !powerSlow:
#
#		elif powerSpeed:
#			if runner.direc == "Left":
#				runner._direction("JumpR", true)
#			elif runner.direc == "Right":
#				runner._direction("JumpL", true)
	if !dead:
		runner._run(runner.motion)

func _on_Area2D_body_enter( body ):
	soundVi.play()
	lblScore.set_text(str(score))
	OS.delay_msec(650)
	#get_tree().change_scene_to_file("res://Stage.tscn")

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
	runner._direction("Climbing", powerSpeed, powerSlow)
#	if !powerSpeed:
#		runner._direction("Climbing", false)
#	elif powerSpeed:
#		runner._direction("Climbing", true)

func _on_Area2D1_body_enter( body ):
	particles.show()
	powerSpeed = true
	powerSlow = false
	indiSl.hide()
	soundSd.play()
	soundBg._set_playing(false)
	soundPs.play()
	powerUp1.hide()
	indiS.show()

func _on_power_finished():
	particles.queue_free()
	powerUp1.queue_free()

func _on_GameOver_finished():
	save.open("res://save.dat", FileAccess.READ_WRITE)
	if int(save.get_as_text()) < _app.score:
		_save()
	save.close()
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	
func _save():
	save.open("res://save.dat", FileAccess.WRITE_READ)
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
	powerUp3.hide()
	particlesStr.show()
	indiI.show()
	powerInvin = true
	soundIn.play()

func _on_powerInvin_finished():
	indiI.hide()
	powerInvin = false
	particlesStr.queue_free()
	powerUp3.queue_free()

func _on_powerSlow_finished():
	#indiSl.hide()
	#powerSlow = false
	particlesSlw.queue_free()
	powerUp4.queue_free()


func _on_Area2D6_body_enter( body ):
	powerUp4.hide()
	particlesSlw.show()
	powerSpeed = false
	indiS.hide()
	indiSl.show()
	powerSlow = true
	soundSl.play()

func _on_area_2d_2_body_entered(body):
	if !powerInvin:
		if is_instance_valid(soundDe):
			soundDe.play()
		indiS.hide()
		indiSl.hide()
		powerSpeed = false
		powerSlow = false		
		if soundSd.is_playing():
			soundSd.stop()
		#if soundSl.is_playing():
			#soundSl.stop()
		if !soundBg.is_playing():
			soundBg._set_playing(true)
		lives = int(lblLives.get_text())-1
		if lives == 0:
			trackLife()
			lblLives.set_text(str(lives))
			_app.isInitialLoad = false
			if score != null && _app.score < score:
				_app.score = score
			soundGo.play()
			dead = true
		else:
			trackLife()
			lblLives.set_text(str(lives))
			runner.set_global_position(startingPos)
			runner.direc = "Right"
			jumping = false
			runner._direction("Climbing", false, false)
		if lives < 3 && oneUp == true:
			if is_instance_valid(powerUp2):
				powerUp2.show()
	else:
		print("metal clank/spark sfx")
