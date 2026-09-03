extends Node
enum States {
	IDLE,
	MOVING,
	JUMPING,
	DASHING,
	WALL_HANGING,
	}


var state = States.IDLE
var is_pressed: bool = false
var health: int = 4
var player_testers: Array = [false, false, false, false]
