extends Contestant
class_name Player



func _ready() -> void:
	Global.state = Global.States.IDLE


func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action("ui_right"):
		Global.state = Global.States.MOVING
		state_machine()

func state_machine():
	match Global.state:
		Global.States.IDLE:
			SPEED = 0 
		Global.States.MOVING:
			animated_sprite.play("")
			SPEED = default_speed_value

	
