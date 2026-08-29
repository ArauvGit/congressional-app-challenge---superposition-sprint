extends Line2D
@export var y: float = 0
@export var x: float = 0
var position_adder: float = 0
@onready var players: Node2D = $players

# # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while x != 641:
		self.add_point(Vector2(x, y))
		print(Vector2(x, y))
		x += 1
		set_y(15 * sin(0.15 * x))
	


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass
func _physics_process(delta: float) -> void:
	if x >= 641:
		for i in range(2):
			self.add_point(Vector2(x, y))
			x += 1
			set_y(15 * sin(0.15 * x))
			self.remove_point(0)
			self.translate(Vector2(-1, 0))
func set_y(new_value: float):
	if y != new_value:
		y = new_value
	return y
func player_position(): 
	for child in players.get_children(): 
		if is_instance_valid(child): 
			child.position = self.get_point_position(11)
