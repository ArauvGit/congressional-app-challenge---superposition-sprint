extends CharacterBody2D
class_name Contestant
@warning_ignore("unused_signal")
signal update_health
signal take_damage
signal decoherence_end
signal cutscene_dialogue
signal stop_tutorial_dialogue

#region variables
var distance_placement: Array = []
var placement: Array = []
var animated_sprite = get_child(2)
var jump_count: int = 0
var decoherence_multiplier: float = 1
var decoherence_reduction: float = 0.03
var checker: bool = false
var invincible: bool = false
var idle_checker: bool = false
var dash_checker: bool = false
var dash_cooldown: bool = false
var can_squish: bool = false
var speed_powerup_active: bool = false
var jump_powerup_active: bool = false
var can_break: bool = true
var damage_checker: bool = false
var has_decohered: bool = false
var JUMP_VELOCITY = 0:
	set = set_jump
var SPEED = 0:
	set = set_speed
#endregion
#region dictionaries

var Contestant_information: Dictionary = {
	"Yellow": {
		"SPEED": 220,
		"JUMP": - 370,
		"HEALTH": 5,
		"DISTANCE": 0
	},
	
	"Green": {
		"SPEED": 230,
		"JUMP": - 375,
		"HEALTH": 4,
		"DISTANCE": 0
	},
	
	"Red": {
		"SPEED": 240,
		"JUMP": - 400,
		"HEALTH": 5,
		"DISTANCE": 0
	},
	
	"Blue": {
		"SPEED": 210,
		"JUMP": - 365,
		"HEALTH": 6,
		"DISTANCE": 0
	}
}
var Powerup_information: Dictionary = {
	"SPEED_BOOST": 1.5,
	"JUMP_BOOST": 1.5,
	"RESTORATION": 1,
}
#endregion
#region important functions
func _ready():
	set_physics_process(false)
func _physics_process(delta: float) -> void:
		# Add the gravity.
	if is_on_floor(): # THIS CODE MIGHT CAUSE BUGS LATER. BE CAREFUL
		jump_count = 0
		if dash_checker == false and SPEED != 0:
			Global.state = Global.States.MOVING
			state_machine()
	elif not is_on_floor(): # as of when i made this, the enemy should not be able to wall hang/jump.
		#if adding, MODIFY THIS CODE
		match self:
			var x when x.is_in_group("player"):
				if not is_on_wall() and not damage_checker and dash_checker == false:
					Global.state = Global.States.JUMPING
					state_machine()
				if damage_checker and not dash_checker:
					Global.state = Global.States.DAMAGING
					state_machine()
			var x when x.is_in_group("enemy"):
				Global.state = Global.States.JUMPING
				state_machine()
		velocity += get_gravity() * delta
	if checker == false:
		velocity.y = -300
		for Name in Contestant_information.keys():
			if get_groups()[0] == Name:
				set_speed(Contestant_information.get(Name)["SPEED"])
		for Name in Contestant_information.keys():
			if get_groups()[0] == Name and jump_powerup_active == false:
				set_jump(Contestant_information.get(Name)["JUMP"])
		Global.state = Global.States.MOVING
		state_machine()
		checker = true
	land()
	if get_platform_velocity() != Vector2.ZERO:
		movement(0)
		Global.state = Global.States.IDLE
		state_machine()
	move_and_slide()
	if not is_instance_valid(get_tree().get_first_node_in_group("tutorial")):
		return_distance_dictionary()
	_on_detector_body_entered(tile_map())
func state_machine():
	animated_sprite.animation_state()
	match Global.state:
		Global.States.MOVING:
			speed_sprite_flip()
		Global.States.JUMPING:
			movement(SPEED)
			speed_sprite_flip()
		Global.States.DASHING:
			animated_sprite.play("dash")
			if not is_on_floor(): 
				velocity.y = -200
			speed_sprite_flip()
			set_speed(SPEED * 4)
		Global.States.WALL_HANGING:
			velocity.y = 50

func calculate_placement():
	pass


func return_distance(pos1: Vector2, pos2: Vector2):
	var distance_x = pos1.x - pos2.x
	var distance_y = pos1.y - pos2.y
	var added_distance = sqrt(((distance_x) ** 2) + ((distance_y) ** 2))
	return added_distance

func return_distance_dictionary():
	var win_area = $"../../Win Area"
	var win_area_pos = win_area.global_position

	for Name in Contestant_information.keys():
		Contestant_information.get(Name)["DISTANCE"] = return_distance(
			get_tree().get_first_node_in_group(Name).global_position,
			win_area_pos
		)

	var yellow = Contestant_information.Yellow["DISTANCE"]
	var green = Contestant_information.Green["DISTANCE"]
	var red = Contestant_information.Red["DISTANCE"]
	var blue = Contestant_information.Blue["DISTANCE"]

	distance_placement = [
		yellow,
		green,
		red,
		blue
	]
	distance_placement.sort()
	Global.distance_placement = distance_placement
	#print(distance_placement.map(func(element): return str(element)))


func index_place_matching():
	for child in $"..".get_children():
		if not placement.has(child):
			placement.append(child)
			placement.set(distance_placement.find(Contestant_information.get(child.get_groups()[0])["DISTANCE"]), child)
	
	
	#print(placement.map(func(element): return element.name))

			
func land():
	if can_squish and is_on_floor():
		decoherence_end.emit()
		squash(1.3, 0.9, 0.05)
		can_squish = false
		if Global.damaged:
			Global.damaged = false
		
func change_direction():
	var _move_right = Input.is_action_just_pressed("move_right")
	var _move_left = Input.is_action_just_pressed("move_left")
	match SPEED:
		var x when x > 0:
			if is_in_group("player"):
				if Input.is_action_just_pressed("move_left"):
					set_speed(SPEED * -1)
		var x when x < 0:
			if is_in_group("player"): # implement into player script later
				if Input.is_action_just_pressed("move_right"):
					set_speed(SPEED * -1)

func freeze_frame():
	Engine.time_scale = 0
	await get_tree().create_timer(0.02, true, true, true).timeout
	Engine.time_scale = 1

func _decohere():
	has_decohered = true
	Global.damaged = true
	var color_change: ColorRect = animated_sprite.get_child(0)
	var damage_animation := func():
		color_change.modulate = Color(1.0, 1.0, 1.0, 1.0)
		await get_tree().create_timer(0.02).timeout
		color_change.modulate = Color(1.0, 0, 0, (1.1 - decoherence_multiplier) * 1.2)
		Color(0.88, 0.0, 0.0, 1.0)
	if damage_checker == false:
		SFX.get_child(3).play()
		freeze_frame()
		damage_animation.call()
		set_speed(SPEED * -1 * decoherence_multiplier)


func tile_map() -> TileMapLayer:
	var tile_map_layer = get_node($"../../course".get_path())
	return tile_map_layer
#endregion
#region setters
func set_jump(jump_change: int) -> int:
	if Global.state != Global.States.IDLE:
		JUMP_VELOCITY = jump_change
	return JUMP_VELOCITY
func set_speed(speed_change: int) -> int:
	SPEED = speed_change
	return SPEED

#endregion
#region powerups
func speed_powerup():
	set_speed(SPEED * Powerup_information["SPEED_BOOST"])
	await get_tree().create_timer(5).timeout
	speed_powerup_active = false
	set_speed(SPEED / Powerup_information["SPEED_BOOST"])
func jump_powerup():
	set_jump(JUMP_VELOCITY * Powerup_information["JUMP_BOOST"])
	jump_powerup_active = true
	await get_tree().create_timer(5).timeout
	jump_powerup_active = false
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			set_jump(JUMP_VELOCITY / Powerup_information["JUMP_BOOST"])

				
#endregion
func squash(x: float, y: float, time: float):
	create_tween().tween_property(self, "scale", Vector2(x, y), time)
	await get_tree().create_timer(time).timeout
	create_tween().tween_property(self, "scale", Vector2(1, 1), 0.05)


func movement(move_speed):
	velocity.x = move_speed
	return velocity.x

func jump():
	#speed_sprite_flip()
	velocity.y = JUMP_VELOCITY
	jump_count += 1

func wall_hang():
	if is_on_floor(): 
		return
	if is_on_wall_only():
		decoherence_end.emit()
		Global.state = Global.States.WALL_HANGING
		state_machine()
		if Input.is_action_just_pressed("dash"):
			set_speed(SPEED * -1)
			dash()

func dash():
	if not is_on_wall():
		decoherence_end.emit()
		animated_sprite.play("dash")
		Global.state = Global.States.DASHING
		self.state_machine()
		self.dash_checker = true
		await get_tree().create_timer(0.32).timeout
		set_speed(SPEED * 0.25)
		match self:
			var x when x.is_on_floor_only():
				damage_checker = false
				Global.state = Global.States.MOVING
				state_machine()
			var x when x.is_on_wall_only():
				Global.state = Global.States.WALL_HANGING
				state_machine()
			var x when not x.is_on_floor() and damage_checker == false or not x.is_on_wall():
				Global.state = Global.States.JUMPING
				state_machine()
		self.dash_checker = false
		self.dash_cooldown = true 
		await get_tree().create_timer(0.5).timeout
		self.dash_cooldown = false
func _on_detector_body_entered(body: TileMapLayer) -> void:
	var deal_damage := func(cell: Vector2):
		var cell_data = body.get_cell_tile_data(cell)
		if is_instance_valid(cell_data):
			if cell_data.get_custom_data("Damageable"):
				take_damage.emit()
	var break_tile := func(cell: Vector2):
		var cell_data = body.get_cell_tile_data(cell)
		if is_instance_valid(cell_data):
			if cell_data.get_custom_data("Breakable") and can_break:
				can_break = false
				if not SFX.get_child(2).is_playing():
					SFX.get_child(2).pitch_scale = randf_range(0.5, 1.5)
					SFX.get_child(2).play()
				body.set_cell(cell, 0, Vector2(8, 4), 0)
				await get_tree().create_timer(0.4).timeout
				body.erase_cell(cell)
				await get_tree().create_timer(1.5).timeout
				if not SFX.get_child(2).is_playing():
					SFX.get_child(2).pitch_scale = randf_range(0.5, 1.5)
					SFX.get_child(2).play()
				body.set_cell(cell, 0, Vector2(8, 6), 0)
				await get_tree().create_timer(0.4).timeout
				body.set_cell(cell, 0, Vector2(9, 5), 0)
			else:
				can_break = true
	if is_on_wall_only():
		var cell = body.local_to_map(body.to_local(self.global_position - Vector2(32, 0) * get_wall_normal()))
		deal_damage.call(cell)
		break_tile.call(cell)
	elif is_on_floor_only():
		var cell = body.local_to_map(body.to_local(self.global_position + Vector2(0, 32)))
		deal_damage.call(cell)
		break_tile.call(cell)
	elif is_on_ceiling():
		var cell = body.local_to_map(body.to_local(self.global_position - Vector2(0, 32)))
		deal_damage.call(cell)

func speed_sprite_flip():
	match SPEED:
		var x when x > 0:
			animated_sprite.flip_h = false
			change_direction()
		var x when x < 0:
			animated_sprite.flip_h = true
			change_direction()

func set_player():
	self.add_to_group("player")
	Global.player_testers[self.get_index() - 1] = true

func input() -> void:
	stop_tutorial_dialogue.emit()

func _on_win_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		var win_scene = preload("res://win.tscn")
		var win_instantiated = win_scene.instantiate()
		get_parent().get_parent().add_child(win_instantiated)
		get_tree().change_scene_to_node(win_instantiated)
