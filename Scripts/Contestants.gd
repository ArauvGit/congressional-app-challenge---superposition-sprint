extends CharacterBody2D
class_name Contestant

signal update_health
var checker: bool = false
var JUMP_VELOCITY = 0:
	set = set_jump
var SPEED = 0:
	set = set_speed
var Contestant_information : Dictionary = {
	"Yellow": {
		"SPEED": 180,
		"JUMP": -300,
		"STAMINA": 5,
		"HEALTH": 5,
	},
	
	"Green": {
		"SPEED": 185,
		"JUMP": -350,
		"STAMINA": 4,
		"HEALTH": 4,
	},
	
	"Red": {
		"SPEED": 195,
		"JUMP": -500,
		"STAMINA": 6,
		"HEALTH": 3,
	},
	
	"Blue": {
		"SPEED": 190,
		"JUMP": -250,
		"STAMINA": 8,
		"HEALTH": 6
	}
}

func _ready():
	set_physics_process(false)
	Global.state = Global.States.IDLE
func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_right") and checker == false:
		Global.state = Global.States.MOVING
		state_machine()
		checker = true
	velocity.x = SPEED
	move_and_slide()


func state_machine():
	for sprite in get_children():
		if sprite.has_method("animation_state"):
			sprite.animation_state()
	match Global.state:
		Global.States.IDLE:
			SPEED = 0 			
			JUMP_VELOCITY = 0
		Global.States.MOVING:
			match self:
				var x when x.is_in_group("yellow"):
					set_speed(Contestant_information.Yellow["SPEED"])
				var x when x.is_in_group("green"):
					set_speed(Contestant_information.Green["SPEED"])
				var x when x.is_in_group("red"):
					set_speed(Contestant_information.Red["SPEED"])
				var x when x.is_in_group("blue"):
					set_speed(Contestant_information.Blue["SPEED"])
		Global.States.JUMPING:
			match self:
				var x when x.is_in_group("yellow"):
					set_jump(Contestant_information.Yellow["JUMP"])
				var x when x.is_in_group("green"):
					set_jump(Contestant_information.Green["JUMP"])
				var x when x.is_in_group("red"):
					set_jump(Contestant_information.Red["JUMP"])
				var x when x.is_in_group("blue"):
					set_jump(Contestant_information.Blue["JUMP"])
		Global.States.SPRINTING:
			match self:
				var x when x.is_in_group("yellow"):
					set_speed(Contestant_information.Yellow["SPEED"] * 1.5)
				var x when x.is_in_group("green"):
					set_speed(Contestant_information.Green["SPEED"] * 1.5)
				var x when x.is_in_group("red"):
					set_speed(Contestant_information.Red["SPEED"] * 1.5)
				var x when x.is_in_group("blue"):
					set_speed(Contestant_information.Blue["SPEED"] * 1.5)
func set_jump(jump_change: int) -> int:
	if Global.state != Global.States.IDLE:
		JUMP_VELOCITY = jump_change
		velocity.y = JUMP_VELOCITY
	return JUMP_VELOCITY
func set_speed(speed_change: int) -> int:
	if Global.state == Global.States.MOVING:
		SPEED = speed_change
	return SPEED
func speed_powerup():
	set_speed(SPEED * 1.25)
