extends TextureButton
@export var yellow: Node2D
@export var green: Node2D
@export var red: Node2D
@export var blue: Node2D
@export var background_transparent: ColorRect
@export var win_area: Area2D
#var player = return_player()
#var player_distance: float = return_player().return_distance(return_player().global_position, win_area.global_position) 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	Engine.time_scale = 1
	Global.can_interact = true
	Global.interference_activated = false


func _on_destructive_pressed() -> void:
	if Global.interference_activated:
		for item in Global.distance_placement: 
			var item_index = Global.distance_placement.find(item)
			if item_index == 2 or item_index == 3: 
				match item: 
					var x when x == get_yellow_distance(): 
						Global.distance_placement.erase(item)
						yellow.queue_free() 
					var x when x == get_green_distance(): 
						Global.distance_placement.erase(item)
						green.queue_free() 
					var x when x == get_red_distance(): 
						Global.distance_placement.erase(item)
						red.queue_free() 
					var x when x == get_blue_distance(): 
						Global.distance_placement.erase(item)
						blue.queue_free() 	 
	reset()


func _on_constructive_pressed() -> void:
	var player = return_player()
	var player_distance: float = return_player().return_distance(return_player().global_position, win_area.global_position) 
	if Global.interference_activated:
		if player_distance == Global.distance_placement[0]: 
			Global.distance_placement.erase(1) 
			player.set_speed(player.SPEED * 2)
			player.set_jump(player.JUMP_VELOCITY * 1.5)
			await get_tree().create_timer(5).timeout 
			player.set_speed(player.SPEED * 0.5)
			player.set_jump(player.JUMP_VELOCITY * 0.6667)
	reset()
