extends Node
enum States {
	IDLE,
	MOVING_RIGHT,
	MOVING_LEFT,
	SPRINTING,
	JUMPING,
	JUMPING_RIGHT,
	JUMPING_LEFT,
	ON_WALL
	}



var state = States.IDLE
var is_pressed: bool = false
var health: int = 5
