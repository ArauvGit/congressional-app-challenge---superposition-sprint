extends Node
enum States {
	IDLE,
	MOVING,
	JUMPING
}

var state = States.IDLE
var is_pressed: bool = false
