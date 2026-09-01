extends Line2D
@export var line_container: Node2D
@export var players: Node2D

var y: float = 0
var x: float = 0

var position_adder: float = 0
var enemy_movement_timer: float = 0
var wave_count: float = 3

var wave_speed_multiplier: int = 1
var vertical_movement: int = 1
var enemy_movement_multiplier: int = 1

var started_cancelling: bool = false
var cancelled: bool = false
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
	update_player_position(delta) 
	area_collisions(get_child(0))
func set_y(new_value: float):
	if y != new_value:
		y = new_value
	return y

func update_player_position(delta):
	enemy_movement_timer -= delta
	for child in players.get_children():
		var horizontal_direction: float = Input.get_axis("move_left", "move_right")
		var vertical_direction: float = Input.get_axis("move_up", "move_down")
		if child.is_in_group("player"):
			child.position.x += 1 * horizontal_direction
			if %Line3.position.y < 300 or %Line3.position.y > 60:
				vertical_movement = 1
				child.get_child(2).offset.y += 0.375 * vertical_direction
				%Line3.position.y += vertical_movement * vertical_direction
			if %Line3.position.y >= 300 and vertical_direction == 1:
				vertical_movement = 0
		#else:
			#match child:
				#var player_node when player_node.is_in_group("Yellow"):
					#position_adder = 0.8
				#var player_node when player_node.is_in_group("Green"):
					#position_adder = 0.7
				#var player_node when player_node.is_in_group("Red"):
					#position_adder = 1
				#var player_node when player_node.is_in_group("Blue"):
					#position_adder = 0.5
			#child.position.x += position_adder
		match child:
			var player_node when player_node.is_in_group("Yellow"):
				child.add_to_group("Line One")
				child.position.y = 15 * sin(0.15 * abs(x) * 1.1)
			var player_node when player_node.is_in_group("Green"):
				child.add_to_group("Line Two")
				child.position.y = 15 * sin(0.15 * abs(x) * 1.25) + 60
			var player_node when player_node.is_in_group("Red"):
				child.add_to_group("Line Three")
				child.position.y = 15 * sin(0.15 * abs(position.x) * 1.5) + 140
			var player_node when player_node.is_in_group("Blue"):
				child.add_to_group("Line Four")
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

func area_collisions(area: Area2D) -> void: 
	var area_parent = area.get_parent()
	if wave_count == 0: 
		area_parent.default_color = Color("FFF")
		cancelled = true
	if area.get_overlapping_areas():
		if area_parent is Line2D:
			for node in get_tree().get_nodes_in_group(area_parent.get_groups()[0]): 
				if node is CharacterBody2D: 
					if not node.is_in_group("player"): 
						started_cancelling = true
					else: 
						started_cancelling = false
					if started_cancelling == true: 
						if Input.is_action_just_pressed("Interference"):
							flash_white(area_parent) 
							await get_tree().create_timer(0.04).timeout
							fluctuate(area_parent, wave_count * 0.167)
							wave_count -= 1
					
func flash_white(line: Line2D): 
	var checker: bool = false 
	var previous_default_color: Color = line.default_color
	var timer_duration: float = 0.04
	var tween = create_tween()
	if previous_default_color == Color("FFF"): 
		return
	if checker == false: 
		tween.tween_property(line, "default_color", Color("FFFF"), timer_duration)
		tween.tween_property(line, "width", 5, timer_duration)
		tween.tween_property(line, "default_color", previous_default_color, timer_duration)
		tween.tween_property(line, "width", 2, timer_duration)
		checker = true

func fluctuate(line: Line2D, duration: float):
	var color_tween: Tween = get_tree().create_tween()

	for i in range(100):
		color_tween.tween_property(line, "modulate", Color(1.0, 1.0, 1.0, 0.318), duration)
		color_tween.tween_property(line, "modulate", Color("FFFF"), duration)	
