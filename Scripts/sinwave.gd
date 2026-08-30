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
	set_player_position()

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
	update_player_position()

func set_y(new_value: float):
	if y != new_value:
		y = new_value
	return y

func update_player_position():
	for child in players.get_children():
		var horizontal_direction: float = Input.get_axis("move_left", "move_right")
		var vertical_direction: float = Input.get_axis("move_up", "move_down")
		if child.is_in_group("player"):
			child.position.x += 1 * horizontal_direction
		match child:
			var player_node when player_node.is_in_group("Yellow"):
				child.position.y = 15 * sin(0.15 * abs(x) * 1.1)
			var player_node when player_node.is_in_group("Green"):
				child.position.y = 15 * sin(0.15 * abs(x) * 1.25) + 60
			var player_node when player_node.is_in_group("Red"):
				child.position.y = 15 * sin(0.15 * abs(position.x) * 1.5) + 140
				#child.position.y += 1 * vertical_direction
			var player_node when player_node.is_in_group("Blue"):
				child.position.y = 15 * sin(0.15 * abs(x)) + 220


func set_player_position():
	if is_instance_valid(players):
		for child in players.get_children():
			match child:
				var character when character.is_in_group("Yellow"):
					child.global_position = Vector2(50, %Line1.position.y)
				var character when character.is_in_group("Green"):
					child.global_position = Vector2(50, %Line2.position.y)
				var character when character.is_in_group("Red"):
					child.global_position = Vector2(50, %Line3.position.y)
				var character when character.is_in_group("Blue"):
					child.global_position = Vector2(50, %Line4.position.y)
		#if not is_instance_valid($yellow):
			#%Line1.queue_free()
		#if not is_instance_valid($green):
			#%Line2.queue_free()
		#if not is_instance_valid($red):
			#%Line3.queue_free()
		#if not is_instance_valid($blue):
			#%Line4.queue_free()
	else:
		push_error("players is null!")
