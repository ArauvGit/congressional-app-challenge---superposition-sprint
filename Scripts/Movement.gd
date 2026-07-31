extends Contestant
class_name Movement


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func set_jump(jump_change: int) -> int:
	if Global.state != Global.States.IDLE:
		JUMP_VELOCITY = jump_change
		velocity.y = JUMP_VELOCITY
	return JUMP_VELOCITY
func set_speed(speed_change: int) -> int:
	if Global.state == Global.States.MOVING:
		SPEED = speed_change
	return SPEED
