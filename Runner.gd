extends KinematicBody2D

onready var anim = get_node("AnimatedSprite")
onready var sfxJump = get_node("jump")
var motion = Vector2()
var direc

func _ready():
	direc = "Right"

func _run(vec2):
	move_and_slide(vec2)
	
func _direction(status, pwrSpd, pwrSlw):
	if status == "Climbing":
		anim.play("Climbing")
		if pwrSpd:
			motion.y = -600
		if pwrSlw:
			motion.y = -80
		elif !pwrSpd && !pwrSlw:
			motion.y = -300
		motion.x = 0
	elif status == "JumpR":
			sfxJump.play()
			anim.set_flip_h(false)
			anim.play("Jumping")
			if pwrSpd:
				motion.x = 1560
				motion.y = -260
			if pwrSlw:
				motion.x = 560
				motion.y = -18
			elif !pwrSlw && !pwrSpd:
				motion.x = 780
				motion.y = -130
	elif status == "JumpL":
			sfxJump.play()
			anim.set_flip_h(true)
			anim.play("Jumping")
			if pwrSpd:
				motion.x = -1560
				motion.y = -260
			if pwrSlw:
				motion.x = -560
				motion.y = -18
			elif !pwrSlw && !pwrSpd:
				motion.x = -780
				motion.y = -130