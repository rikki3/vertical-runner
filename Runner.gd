extends KinematicBody2D

onready var anim = get_node("AnimatedSprite")
onready var sfxJump = get_node("jump")
var motion = Vector2()
var direc

func _ready():
	direc = "Right"

func _run(vec2):
	move_and_slide(vec2)
	
func _direction(status, pwrSpd):
	if status == "Climbing":
		anim.play("Climbing")
		if pwrSpd:
			motion.y = -600
			motion.x = 0
		elif !pwrSpd:
			motion.y = -300
			motion.x = 0
	elif status == "JumpR":
			sfxJump.play()
			anim.set_flip_h(false)
			anim.play("Jumping")
			if pwrSpd:
				motion.x = 1560
				motion.y = -260
			elif !pwrSpd:
				motion.x = 780
				motion.y = -130
	elif status == "JumpL":
			sfxJump.play()
			anim.set_flip_h(true)
			anim.play("Jumping")
			if pwrSpd:
				motion.x = -1560
				motion.y = -260
			elif !pwrSpd:
				motion.x = -780
				motion.y = -130