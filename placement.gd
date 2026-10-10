extends Label
@export var yellow: Node2D
@export var green: Node2D
@export var red: Node2D
@export var blue: Node2D
@export var win_area: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	organize(Global.distance_placement)

func organize(array: Array):
	for item in array: 
		match self:
			var x when x == yellow.return_distance(yellow.global_position, win_area.global_position):
				self.font_color = Color("fad44bff")
			var x when x == green.return_distance(green.global_position, win_area.global_position):
				self.font_color = Color(0.0, 0.749, 0.476, 1.0)
			var x when x == red.return_distance(red.global_position, win_area.global_position):
				self.font_color = Color(0.99, 0.277, 0.325, 1.0)
			var x when x == blue.return_distance(blue.global_position, win_area.global_position):
				self.font_color = Color(0.185, 0.726, 1.0, 1.0)
