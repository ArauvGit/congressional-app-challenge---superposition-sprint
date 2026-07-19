extends Node
enum States {
	IDLE,
	MOVING
}

var state = States.IDLE
var is_pressed: bool = false
