extends CharacterBody2D

@onready var anim = get_node("AnimatedSprite2D")
@onready var sfxJump = get_node("jump")
var motion = Vector2()
var direc

func _ready():
	direc = "Right"

func _run(vec2):
	set_velocity(vec2)
	move_and_slide()
	
func _direction(status, pwrSpd, pwrSlw):
	if status == "Climbing":
		anim.play("Climbing")
		motion.x = 0
	elif status == "JumpR":
			sfxJump.play()
			anim.set_flip_h(false)
			anim.play("Jumping")
			if pwrSpd:
				motion.x = 1560
			if pwrSlw:
				motion.x = 560
			elif !pwrSlw && !pwrSpd:
				motion.x = 780
	elif status == "JumpL":
			sfxJump.play()
			anim.set_flip_h(true)
			anim.play("Jumping")
			if pwrSpd:
				motion.x = -1560
			if pwrSlw:
				motion.x = -560
			elif !pwrSlw && !pwrSpd:
				motion.x = -780
