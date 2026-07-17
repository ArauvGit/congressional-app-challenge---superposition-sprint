extends CharacterBody2D
class_name Contestant
@export var SPEED = 0
@export var JUMP_VELOCITY = -400.0
@export var default_speed_value: int = 300
@export var animated_sprite: AnimatedSprite2D


func _ready():
	_physics_process(false)
	Global.button_press.connect(_on_button_press)
	Global.state = Global.States.IDLE
func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_right"):
		Global.state = Global.States.MOVING
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_action_strength("ui_right")
	velocity.x = SPEED
	move_and_slide()

func state_machine():
	match Global.state:
		Global.States.IDLE:
			SPEED = 0 
		Global.States.MOVING:
			animated_sprite.play("run")
			SPEED = default_speed_value

func _on_button_press():	
	match self:
		var x when x.is_in_group("player"):
			self.set_script("res://Scenes/player.gd")
		var x when x.is_in_group("enemy"):
			self.set_script("res://Scripts/enemy.gd")
			
