extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var SPEED = 0
const JUMP_VELOCITY = -400.0
const default_speed_value: int = 300

func _ready() -> void:
	Global.state = Global.States.IDLE


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_right"):
		Global.state = Global.States.MOVING
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_action_strength("ui_right")
	velocity.x = SPEED

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_right"):
		Global.state = Global.States.MOVING
		state_machine()

func state_machine():
	match Global.state:
		Global.States.IDLE:
			SPEED = 0 
		Global.States.MOVING:
			SPEED = default_speed_value
			animated_sprite.play("walking")
	
	
