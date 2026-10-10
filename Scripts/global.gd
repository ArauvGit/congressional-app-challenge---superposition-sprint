extends Node
enum States {
	IDLE,
	MOVING,
	JUMPING,
	DAMAGING,
	DASHING,
	WALL_HANGING,
	}


var state = States.IDLE
var can_interact: bool = true
var is_pressed: bool = false
var health: int = 4
var player_testers: Array = [false, false, false, false]
var interference_activated: bool = false
var damaged: bool = false
var dead: bool = false
var can_be_pressed: bool = false
var distance_placement: Array = []
