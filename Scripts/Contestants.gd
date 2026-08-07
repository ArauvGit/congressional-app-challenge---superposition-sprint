extends CharacterBody2D
class_name Contestant
@warning_ignore("unused_signal")
signal update_health
#region variables
var animated_sprite = get_child(1)
var checker: bool = false
var jump_powerup_active: bool = false
var JUMP_VELOCITY = 0:
	set = set_jump
var SPEED = 0:
	set = set_speed
#endregion
#region dictionaries
var Contestant_information: Dictionary = {
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
		"JUMP": -400,
		"STAMINA": 6,
		"HEALTH": 4,
	},
	
	"Blue": {
		"SPEED": 190,
		"JUMP": -275,
		"STAMINA": 8,
		"HEALTH": 6
	}
}
var Powerup_information: Dictionary = {
	"SPEED_BOOST": 1.25,
	"JUMP_BOOST": 1.5,
	"RESTORATION": 1,
}
#endregion
#region important functions
func _ready():
	set_physics_process(false)
	Global.state = Global.States.IDLE
func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("move_right") and checker == false:
		for Name in Contestant_information.keys():
			if get_groups()[0] == Name:
				set_speed(Contestant_information.get(Name)["SPEED"])
		Global.state = Global.States.MOVING_RIGHT
		state_machine()
		checker = true
	velocity.x = SPEED
	move_and_slide()
func state_machine():
	if not is_in_group("Green"):
		return #debugging purposes remove later
	animated_sprite.animation_state()
	match Global.state:
		Global.States.IDLE:
			print("idle")
			set_speed(0)
			set_jump(0)
		Global.States.JUMPING:
			print("jumping")
			for Name in Contestant_information.keys():
				if get_groups()[0] == Name and jump_powerup_active == false:
					set_jump(Contestant_information.get(Name)["JUMP"])
		Global.States.SPRINTING:
			for Name in Contestant_information.keys():
				if get_groups()[0] == Name:
					set_speed(Contestant_information.get(Name)["SPEED"] * 1.2)
		Global.States.MOVING_RIGHT:
			print("moving right")
			for Name in Contestant_information.keys():
				if get_groups()[0] == Name:
					match SPEED:
						var x when x < 0:
							set_speed(SPEED * -1)
						var x when x > 0:
							set_speed(SPEED)
			animated_sprite.flip_h = false
		Global.States.MOVING_LEFT:
			print("moving left")
			for Name in Contestant_information.keys():
				if get_groups()[0] == Name:
					match SPEED:
						var x when x > 0:
							set_speed(SPEED * -1)
						var x when x < 0:
							set_speed(SPEED)
			animated_sprite.flip_h = true
		Global.States.JUMPING_RIGHT:
			print("jumping right")
			for Name in Contestant_information.keys():
				if get_groups()[0] == Name and jump_powerup_active == false:
					set_jump(Contestant_information.get(Name)["JUMP"])
					match SPEED:
						var x when x < 0:
							set_speed(SPEED * -1)
						var x when x > 0:
							set_speed(SPEED)
			#animated_sprite.flip_h = false
		Global.States.JUMPING_LEFT:
			print("jumping left")
			for Name in Contestant_information.keys():
				if get_groups()[0] == Name and jump_powerup_active == false:
					set_jump(Contestant_information.get(Name)["JUMP"])
					match SPEED:
						var x when x > 0:
							set_speed(SPEED * -1)
						var x when x < 0:
							set_speed(SPEED)
			#animated_sprite.flip_h = true	
			if SPEED > 0:
				set_speed(SPEED * -1)
#endregion
#region setters
func set_jump(jump_change: int) -> int:
	if Global.state != Global.States.IDLE:
		JUMP_VELOCITY = jump_change
	return JUMP_VELOCITY
func set_speed(speed_change: int) -> int:
	if Global.state == Global.States.MOVING_RIGHT \
	or Global.state == Global.States.MOVING_LEFT:
		SPEED = speed_change
	return SPEED
#endregion
#region movement
#endregion
#region powerups
func speed_powerup():
	set_speed(SPEED * Powerup_information["SPEED_BOOST"])
	await get_tree().create_timer(1).timeout
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			set_speed(Contestant_information.get(Name)["SPEED"])
func jump_powerup():
	set_jump(JUMP_VELOCITY * Powerup_information["JUMP_BOOST"])
	jump_powerup_active = true
	await get_tree().create_timer(3).timeout
	jump_powerup_active = false
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			set_jump(Contestant_information.get(Name)["JUMP"])
#endregion
