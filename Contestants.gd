extends CharacterBody2D
class_name Contestant
@export var JUMP_VELOCITY = -400.0

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
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
		Global.States.MOVING:
<<<<<<< HEAD
			SPEED = default_speed_value
			print(SPEED)
=======
			match self.get_index():
				var x when x == 1:
					set_speed(200)
				var x when x == 2:
					set_speed(400)
				var x when x == 3:
					set_speed(300)
				var x when x == 4:
					set_speed(500)
func set_speed(speed_change: int) -> void:
	if Global.state == Global.States.MOVING:
		SPEED = speed_change
>>>>>>> 5225b71f3754dfd430d38c48a9c4fe5b4e8a65ac
