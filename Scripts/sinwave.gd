extends Node2D
@export var y: float = 0
@export var x: float = -320
var position_adder: float = 0

# # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while x != 321:
		draw_line(Vector2(x, y), Vector2(x + 1, set_y(20 * sin(0.1 * x))), Color("ffff"), 1.0)
# 	while x != 321:
# 		self.add_point(Vector2(x, y))
# 		print(Vector2(x, y))
# 		x += 1
# 		set_y(20 * sin(0.1 * x))


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
# func _physics_process(delta: float) -> void:
# 	pass
func set_y(new_value: float):
	if y != new_value:
		y = new_value
	return y
#func _draw() -> void:
	#while x != 321:
		#draw_line(Vector2(x, y), Vector2(x + 1, set_y(20 * sin(0.1 * x))), Color("ffff"), 1.0)
