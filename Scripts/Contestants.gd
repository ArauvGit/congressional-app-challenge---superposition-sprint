extends CharacterBody2D
class_name Contestant
signal update_health
signal take_damage
#region variables
var animated_sprite = get_child(2)
var jump_count: int = 0
var checker: bool = false
var dash_checker: bool = false
var dash_cooldown: bool = false
var jump_powerup_active: bool = false
var damage_checker: bool = false
var damage_shader: Shader = load("res://Scripts/damage_flash.gdshader")
var JUMP_VELOCITY = 0:
	set = set_jump
var SPEED = 0:
	set = set_speed
#endregion
#region dictionaries
var Contestant_information: Dictionary = {
	"Yellow": {
		"SPEED": 180,
		"JUMP": - 350,
		"STAMINA": 5,
		"HEALTH": 5,
	},
	
	"Green": {
		"SPEED": 185,
		"JUMP": - 375,
		"STAMINA": 4,
		"HEALTH": 4,
	},
	
	"Red": {
		"SPEED": 195,
		"JUMP": - 400,
		"STAMINA": 6,
		"HEALTH": 4,
	},
	
	"Blue": {
		"SPEED": 190,
		"JUMP": - 325,
		"STAMINA": 8,
		"HEALTH": 6
	}
}
var Powerup_information: Dictionary = {
	"SPEED_BOOST": 1.25,
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
		if SPEED == 0: 
			Global.state = Global.States.IDLE
			state_machine()
		if Global.state != Global.States.DASHING and SPEED != 0:
			Global.state = Global.States.MOVING
			state_machine()
	elif not is_on_floor(): #as of when i made this, the enemy should not be able to wall hang/jump. 
		#if adding, MODIFY THIS CODE
		match self:
			var x when x.is_in_group("player"):
				if not is_on_wall(): 
					Global.state = Global.States.JUMPING
					state_machine()
			var x when x.is_in_group("enemy"):
				Global.state = Global.States.JUMPING
				state_machine()
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("move_right") and checker == false:
		for Name in Contestant_information.keys():
			if get_groups()[0] == Name:
				set_speed(Contestant_information.get(Name)["SPEED"])
		for Name in Contestant_information.keys():
			if get_groups()[0] == Name and jump_powerup_active == false:
				set_jump(Contestant_information.get(Name)["JUMP"])
		Global.state = Global.States.MOVING
		state_machine()
		checker = true
	velocity.x = SPEED
	move_and_slide()
	_on_detector_body_entered(tile_map())
func state_machine():
	animated_sprite.animation_state()
	match Global.state:
		Global.States.IDLE:
			set_speed(0)
			set_jump(0)
		#region moving
		Global.States.MOVING:
			speed_sprite_flip()
		#endregion
		#region jumping
		Global.States.JUMPING:
			speed_sprite_flip()
			match velocity.y:
				var x when x > 0:
					animated_sprite.play("fall_down")
				var x when x < 0:
					animated_sprite.play("jump_up")
		#endregion
		#region dashing
		Global.States.DASHING:
			for Name in Contestant_information.keys():
				if get_groups()[0] == Name:
					speed_sprite_flip()
					match SPEED:
						var x when x > 0:
							set_speed(Contestant_information.get(Name)["SPEED"] * 4)
						var x when x < 0:
							set_speed(Contestant_information.get(Name)["SPEED"] * -4)
		#endregion
		#region wall hanging
		Global.States.WALL_HANGING:
			velocity.y = 50
		#endregion
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
func _decohere():
	print('decohere!')
	set_jump(JUMP_VELOCITY * 0.1)
	set_speed(SPEED * 0.1)
func tile_map() -> TileMapLayer:
	var tile_map_layer = get_node($"../../TileMapLayer".get_path())
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
	await get_tree().create_timer(1).timeout
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			set_speed(Contestant_information.get(Name)["SPEED"])
func jump_powerup():
	set_jump(JUMP_VELOCITY * Powerup_information["JUMP_BOOST"])
	jump_powerup_active = true
	await get_tree().create_timer(3).timeout
	jump_powerup_active = false
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			set_jump(JUMP_VELOCITY / Powerup_information["JUMP_BOOST"])
#endregion
func jump():
	#speed_sprite_flip()
	velocity.y = JUMP_VELOCITY
	jump_count += 1
func wall_hang():
	if is_on_wall_only():
		Global.state = Global.States.WALL_HANGING
		state_machine()
func _on_detector_body_entered(body: TileMapLayer) -> void:
	var deal_damage := func(cell: Vector2):
		var cell_data = body.get_cell_tile_data(cell)
		if is_instance_valid(cell_data):
			if cell_data.get_custom_data("Damageable"):
				take_damage.emit()
	if is_on_wall():
		var cell = body.local_to_map(body.to_local(self.global_position - Vector2(32, 0) * get_wall_normal()))
		deal_damage.call(cell)
	elif is_on_floor_only():
		var cell = body.local_to_map(body.to_local(self.global_position + Vector2(0, 32)))
		deal_damage.call(cell)
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
