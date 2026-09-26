extends Node2D


@export var position_transform: float
@export var position_adder: float
@export var position_x: int
@export var position_y: int
@export var radius_multiplier: int
var position_increase: float = 0 
var pos = Vector2(0, 0)
var pos_y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void: 
	self.modify_straight_position()
	for child in self.get_children(): 
		child.position = pos
func modify_straight_position(): 
	var sin_input = sin(position_transform)
	pos = Vector2(sin_input * position_x, sin_input * position_y)
	position_transform += position_adder
func modify_circular_position():
	var circular_input = 2*PI*position_transform
	pos = Vector2((circular_input * radius_multiplier), (circular_input * radius_multiplier))
