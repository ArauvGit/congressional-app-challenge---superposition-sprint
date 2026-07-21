extends CharacterBody2D
class_name Contestant


var Contestant_information : Dictionary = {
	"Yellow": {
		"SPEED": 160,
		"JUMP": 300,
	},
	
	"Green": {
		"SPEED": 175,
		"JUMP": 350
	},
	
	"Red": {
		"SPEED": 195,
		"JUMP": 500
	},
	
	"Blue": {
		"SPEED": 185,
		"JUMP": 250
	}
	
	
}


var yellow_information := {
	"speed": 200,
	"jump power": 400
}


var JUMP_VELOCITY = 0:
	set = set_jump
var SPEED = 0:
	set = set_speed
func _ready():
	set_physics_process(false)
	Global.state = Global.States.IDLE
func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_right"):
		Global.state = Global.States.MOVING
		state_machine()
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_action_strength("ui_right")
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
			velocity.y = JUMP_VELOCITY
			match self.get_index():
				var x when x == 0:
					set_jump(Contestant_information.Yellow["JUMP"])
				var x when x == 1:
					set_jump(Contestant_information.Green["JUMP"])
				var x when x == 2:
					set_jump(Contestant_information.Red["JUMP"])
				var x when x == 3:
					set_jump(Contestant_information.Blue["JUMP"])
func set_speed(speed_change: int) -> void:
	if Global.state != Global.States.IDLE:
		SPEED = speed_change
func set_jump(jump_change: int) -> void:
	if Global.state != Global.States.IDLE:
		JUMP_VELOCITY = jump_change
