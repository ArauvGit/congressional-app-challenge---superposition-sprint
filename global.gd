extends Node
signal button_press
enum States {
	IDLE,
	MOVING
}

var state = States.IDLE
