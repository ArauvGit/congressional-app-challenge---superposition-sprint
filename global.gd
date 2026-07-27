extends Node
enum States {
	IDLE,
	MOVING,
	SPRINTING,
	JUMPING
}

var state = States.IDLE
var is_pressed: bool = false
var health: int = 3
