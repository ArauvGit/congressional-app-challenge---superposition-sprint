extends Node
enum States {
	IDLE,
	MOVING_RIGHT,
	MOVING_LEFT,
	SPRINTING_RIGHT,
	SPRINTING_LEFT,
	JUMPING_RIGHT,
	JUMPING_LEFT,
	DASHING_RIGHT,
	DASHING_LEFT,
	WALL_HANGING_RIGHT,
	WALL_HANGING_LEFT
	}


var state = States.IDLE
var is_pressed: bool = false
var health: int = 5
