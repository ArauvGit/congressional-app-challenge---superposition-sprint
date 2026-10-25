extends TextureButton
@export var placement_container: Control
@export var players: Node2D
@export var yellow: Node2D
@export var green: Node2D
@export var red: Node2D
@export var blue: Node2D
@export var background_transparent: ColorRect
@export var line_container: Node2D
@export var win_area: Area2D
var can_modulate: bool = false
var separation_amount: int = 13
#var player = return_player()
#var player_distance: float = return_player().return_distance(return_player().global_position, win_area.global_position) 


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:
	modulate_buff()

func _process(delta: float) -> void:
	if Global.interference_activated:
		for child in SFX.get_children():
			child.volume_db = -80
	else:
		for child in SFX.get_children():
			child.volume_db = 0

func get_yellow_distance():
	if yellow:
		return yellow.return_distance(yellow.global_position, win_area.global_position)
func get_green_distance():
	if green:
		return green.return_distance(green.global_position, win_area.global_position)
func get_red_distance():
	if red:
		return red.return_distance(red.global_position, win_area.global_position)
func get_blue_distance():
	if blue:
		return blue.return_distance(blue.global_position, win_area.global_position)


func return_player():
	if get_tree().get_nodes_in_group("player"):
		return get_tree().get_first_node_in_group("player")
func reset():
	background_transparent.hide()
	get_parent().hide()
	Global.interference_wave_activated = true
	line_container.get_parent().show()
	for child in line_container.get_children():
		child.show()
		child.create_lines()
	await get_tree().create_timer(3.5 * Engine.time_scale).timeout
	Engine.time_scale = 1
	Global.can_interact = true
	Global.interference_activated = false


func _on_destructive_pressed() -> void:
	var player_distance: float = return_player().return_distance(return_player().global_position, win_area.global_position)
	var filtered_placement = Global.distance_placement.filter(func(element): return not element == player_distance)
	if Global.interference_activated:
		for i in range(2):
			for item in filtered_placement:
				var item_index = filtered_placement.find(item)
				if item_index == 1 or item_index == 2:
					match item:
						var x when x == get_yellow_distance():
							print("deleted " + str(yellow.name))
							Global.distance_placement.erase(item)
							line_container.get_child(item_index - 2).default_color = Color(1.0, 0.767, 0.0, 1.0)
							yellow.queue_free()
						var x when x == get_green_distance():
							print("deleted " + str(green.name))
							Global.distance_placement.erase(item)
							line_container.get_child(item_index - 2).default_color = Color(0.0, 0.78, 0.364, 1.0)
							green.queue_free()
						var x when x == get_red_distance():
							print("deleted " + str(red.name))
							Global.distance_placement.erase(item)
							line_container.get_child(item_index - 2).default_color = Color(1.0, 0.32, 0.365, 1.0)
							red.queue_free()
						var x when x == get_blue_distance():
							print("deleted " + str(blue.name))
							Global.distance_placement.erase(item)
							line_container.get_child(item_index - 2).default_color = Color(0.0, 0.717, 0.973, 1.0)
							blue.queue_free()
		placement_container.get_child(2).queue_free()
		placement_container.get_child(3).queue_free()
		reset()

func on_button_hover():
	create_tween().tween_property(self, "custom_minimum_size", Vector2(225, 225), 0.1 * Engine.time_scale)
	create_tween().tween_property(get_child(0), "custom_minimum_size", Vector2(225, 225), 0.1 * Engine.time_scale)
func on_hover_exit():
	create_tween().tween_property(self, "custom_minimum_size", Vector2(200, 200), 0.1 * Engine.time_scale)
	create_tween().tween_property(get_child(0), "custom_minimum_size", Vector2(200, 200), 0.1 * Engine.time_scale)
func _on_constructive_pressed() -> void:
	var player = return_player()
	var player_distance: float = return_player().return_distance(return_player().global_position, win_area.global_position)
	if Global.interference_activated:
		var filtered_placement = Global.distance_placement.filter(func(element): return not element == player_distance)
		for item in filtered_placement:
			var item_index = filtered_placement.find(item)
			if item_index == 0:
				match item:
					var x when x == get_yellow_distance():
						print("deleted " + str(yellow.name))
						Global.distance_placement.erase(item)
						yellow.queue_free()
					var x when x == get_green_distance():
						print("deleted " + str(green.name))
						Global.distance_placement.erase(item)
						green.queue_free()
					var x when x == get_red_distance():
						print("deleted " + str(red.name))
						Global.distance_placement.erase(item)
						red.queue_free()
					var x when x == get_blue_distance():
						print("deleted " + str(blue.name))
						Global.distance_placement.erase(item)
						blue.queue_free()
		#elif player_distance != Global.distance_placement[0]:
			#for item in Global.distance_placement:
				#var item_index = Global.distance_placement.find(item)
				#if item_index == 0:
					#match item:
						#var x when x == get_yellow_distance():
							#print("deleted " + str(yellow.name))
							#Global.distance_placement.erase(item)
							#yellow.queue_free()
						#var x when x == get_green_distance():
							#print("deleted " + str(green.name))
							#Global.distance_placement.erase(item)
							#green.queue_free()
						#var x when x == get_red_distance():
							#print("deleted " + str(red.name))
							#Global.distance_placement.erase(item)
							#red.queue_free()
						#var x when x == get_blue_distance():
							#print("deleted " + str(blue.name))
							#Global.distance_placement.erase(item)
							#blue.queue_free()
		placement_container.get_child(-1).queue_free()
		player.set_speed(player.SPEED / player.decoherence_multiplier * 1.2)
		player.set_jump(player.JUMP_VELOCITY * 1.15)
		can_modulate = true
		reset()
func modulate_buff():
	var player = get_tree().get_first_node_in_group("player")
	if can_modulate:
		create_tween().tween_property(player, "modulate", Color(0.98, 0.81, 0.343, 0.875), 1)
		create_tween().tween_property(player, "modulate", create_tween().tween_property(player, "modulate", Color(0.98, 0.81, 0.343, 0.875), 1), 1)
