extends StaticBody2D


@export var position_transform: float
@export var position_x: int
@export var position_y: int
var position_increase: float = 0 
var pos = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void: 
	modify_position()
	self.position += pos
	
func modify_position(): 
	pos = Vector2(sin(position_increase) * position_x, 
	sin(position_increase) * position_y)
	
	position_increase += 0.0625 * position_transform 
	
	
