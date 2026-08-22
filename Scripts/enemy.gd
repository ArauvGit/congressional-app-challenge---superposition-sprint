extends Contestant
class_name enemy
#region variables
#region raycast variables
var raycast_parent = Node2D.new()
var raycast_right = RayCast2D.new()
var raycast_left = RayCast2D.new()
var raycast_under_right = RayCast2D.new()
var raycast_under_left = RayCast2D.new()
var raycast_under = RayCast2D.new()
var raycast_top = RayCast2D.new()
#endregion
#region jump variables
var enemy_jump_count: int = 0
var jump_checker: bool = false
var can_jump: bool = true
var jump_toggle_time: int = 3
#endregion
#endregion
#region important functions
func _init():
	self.connect("take_damage", decohere)
	super.set_physics_process(true)
	raycast_init()
	print("the enemy script has been activated")
	super.set_physics_process(true)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		enemy_jump_count = 0
	raycast_detection()
	super(delta)
	change_direction()
	raycast_speed_modification()
#endregion
#region jump
func get_contestant_jump():
	for key in Contestant_information.keys():
		if get_groups()[0] == key:
			var Jump = Contestant_information.get(key)["JUMP"]
			return Jump

func enemy_jump():
	Global.state = Global.States.JUMPING
	state_machine()
	if enemy_jump_count == 2:
		return
	if is_on_floor() and enemy_jump_count == 0 and jump_checker == false:
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			Global.state = Global.States.JUMPING
			state_machine()
		enemy_jump_count += 1
		jump_checker = true
		await get_tree().create_timer(jump_cooldown_formula(get_contestant_jump())).timeout
		jump_checker = false
	if not is_on_floor() and jump_checker == false:
		double_jump()
		enemy_jump_count = 2
	
func double_jump():
	Global.state = Global.States.JUMPING
	state_machine()
	velocity.y = JUMP_VELOCITY

func wall_jump():
	if is_on_wall_only():
		set_speed(SPEED * -1)
		move_local_x(10 * get_wall_normal().x)
		double_jump()
	else:
		return

func jump_cooldown_formula(jump: float) -> float:
	var timer = jump / -650
	return timer
#endregion
#region raycast specific functions
func raycast_multiplier(multiplier: float) -> float:
	var formula = multiplier * -0.014
	print(formula)
	return formula

func raycast_init():
	var scale_formula: float = raycast_multiplier(get_contestant_jump())
	var default_target_pos_y: int = 20
	var under_target_pos_y: int = 16 # raycast_under_right handles tilemap stuff so this is better
	var col_mask: int = 2

	var raycast_attributes := \
	func(raycast: RayCast2D, rotate_degrees: int, raycast_scale: float, target_position_y: int, raycast_col_mask: int):
		raycast.rotation_degrees = rotate_degrees
		raycast.scale *= raycast_scale
		raycast.target_position.y = target_position_y
		raycast.collision_mask = raycast_col_mask
	
	add_child(raycast_right)
	raycast_attributes.call(raycast_right, -90, scale_formula, default_target_pos_y, col_mask)
	
	add_child(raycast_left)
	raycast_attributes.call(raycast_left, 90, scale_formula, default_target_pos_y, col_mask)
	
	add_child(raycast_under_right)
	raycast_attributes.call(raycast_under_right, 0, scale_formula / 1.4, default_target_pos_y, col_mask)
	raycast_under_right.target_position.x = under_target_pos_y # Vector2(16, 20). Makes downward facing right raycast

	add_child(raycast_under_left)
	raycast_attributes.call(raycast_under_left, 0, scale_formula / 1.4, default_target_pos_y, col_mask)
	raycast_under_left.target_position.x = - under_target_pos_y # Vector2(-16, 20) Makes downward facing left raycast

	add_child(raycast_under)
	raycast_attributes.call(raycast_under, 0, scale_formula / 1.25, default_target_pos_y, col_mask)

	add_child(raycast_top)
	raycast_attributes.call(raycast_top, 180, scale_formula, default_target_pos_y, col_mask)

func raycast_speed_modification(): # fix later; could be the key to jump paradox
	match self.SPEED:
		var x when x > 0:
			raycast_left.target_position.y = 10
		var x when x < 0:
			raycast_right.target_position.y = 10
func raycast_detection():
	if self.raycast_right.is_colliding() and not self.raycast_left.is_colliding():
		if self.raycast_top.is_colliding():
			return
		elif raycast_right.get_collider() is TileMapLayer:
			if SPEED < 0:
				set_speed(SPEED * -1)
				speed_sprite_flip()
			enemy_jump()
	elif self.raycast_left.is_colliding() and not self.raycast_right.is_colliding():
		if self.raycast_top.is_colliding():
			return
		elif raycast_left.get_collider() is TileMapLayer:
			if SPEED > 0:
				set_speed(SPEED * -1)
				speed_sprite_flip()
			enemy_jump()
	elif self.raycast_right.is_colliding() and self.raycast_left.is_colliding():
		if self.raycast_top.is_colliding():
			return
		elif raycast_right.get_collider() and raycast_left.get_collider() is TileMapLayer:
			wall_jump()

	if self.raycast_under_right.is_colliding(): # not an elif because it is independent from raycast_right/left
		damage_detection(tile_map(), raycast_under_right)
	elif self.raycast_under_left.is_colliding():
		damage_detection(tile_map(), raycast_under_right)
#endregion
#region damage
func damage_detection(tileMap: TileMapLayer, diagonal_raycast: RayCast2D):
	if diagonal_raycast.get_collider() is TileMapLayer:
		var cell = tileMap.local_to_map(tileMap.to_local(diagonal_raycast.get_collision_point() + diagonal_raycast.get_collision_point().normalized()))
		var cell_data = tileMap.get_cell_tile_data(cell)
		if cell_data:
			if cell_data.get_custom_data("Damageable"):
				enemy_jump()
func decohere():
	print("decohere")
	if damage_checker == false:
		if is_on_floor():
			velocity.y = -300
			set_speed(SPEED * -0.9)
		elif is_on_wall():
			move_local_x(10 * get_wall_normal().x)
		damage_checker = true
		await get_tree().create_timer(1).timeout
		damage_checker = false # create dedicated invincibility function later with damage flash
#endregion		
