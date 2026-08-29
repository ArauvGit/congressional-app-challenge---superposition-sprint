extends Line2D
@export var line_container: Node2D
@export var players: Node2D
var y: float = 0
var x: float = 0
var position_adder: float = 0
var wave_speed_multiplier: int = 1


# # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match self.get_index():
		0:
			wave_speed_multiplier = 4
		1:
			wave_speed_multiplier = 3
		2:
			wave_speed_multiplier = 5
		3:
			wave_speed_multiplier = 2
	while x != 641:
		self.add_point(Vector2(x, y))
		x += 1
		set_y(15 * sin(0.15 * x))
	player_position()

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func _physics_process(delta: float) -> void:
	if x >= 641:
		for i in range(wave_speed_multiplier):
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
	if is_instance_valid(players):
		for child in players.get_children():
			if is_instance_valid(child) and child is CharacterBody2D:
				match child:
					var character when character.name == "yellow":
						%Line1.get_child(0).position = %Line1.get_point_position(11)
					var character when character.name == "green":
						%Line2.get_child(0).position = %Line2.get_point_position(11)
					var character when character.name == "red":
						%Line3.get_child(0).position = %Line3.get_point_position(11)
					var character when character.name == "blue":
						%Line4.get_child(0).global_position = %Line4.get_point_position(11)
	else:
		push_error("players is null!")
