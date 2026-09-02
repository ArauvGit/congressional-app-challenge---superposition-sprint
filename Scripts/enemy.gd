extends Contestant
class_name enemy
#region variables
#region raycast variables
var raycast_parent = Node2D.new()
var raycast_right = RayCast2D.new()
var raycast_left = RayCast2D.new()
var raycast_under = RayCast2D.new()
var raycast_under_right = RayCast2D.new()
var raycast_under_left = RayCast2D.new()
var raycast_top = RayCast2D.new()
var raycast_top_left = RayCast2D.new()
var raycast_top_right = RayCast2D.new()
#endregion
#region jump variables
var enemy_jump_count: int = 0
var jump_checker: bool = false
var can_jump: bool = true
var jump_toggle_time: int = 3
var timer_duration: float = jump_cooldown_formula(get_contestant_jump())
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
		self.enemy_jump_count = 0
		self.can_jump = true
	if self.enemy_jump_count != 2:
		self.can_jump = true
	raycast_detection()
	super(delta)
	change_direction()
#endregion
#region movement
func enemy_dash():
	if self.dash_checker == false and self.dash_cooldown == false:
		self.dash()
#region jump
func get_contestant_jump():
	for key in Contestant_information.keys():
		if get_groups()[0] == key:
			var Jump = Contestant_information.get(key)["JUMP"]
			return Jump

func enemy_jump():
	if is_in_group("Red"):
		print(enemy_jump_count)
		print(can_jump)
	Global.state = Global.States.JUMPING
	state_machine()
	if enemy_jump_count == 2:
		can_jump = false
		return
	if can_jump == false:
		return
	if is_on_floor() and enemy_jump_count == 0 and jump_checker == false:
		enemy_jump_count += 1
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			Global.state = Global.States.JUMPING
			state_machine()
		jump_checker = true
		await get_tree().create_timer(timer_duration).timeout
		jump_checker = false
	if not is_on_floor() and jump_checker == false and can_jump:
		double_jump()
		enemy_jump_count = 2
	
func double_jump():
	velocity.y = JUMP_VELOCITY
	Global.state = Global.States.JUMPING
	enemy_jump_count += 1
	state_machine()

func wall_jump():
	#if abs(get_wall_normal().x) != 1 or abs(get_floor_normal().x) != 1: 
		#return
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
#endregion
#region raycast specific functions
func raycast_multiplier(multiplier: float) -> float:
	var formula = multiplier * -0.014
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
	
	add_child(raycast_under)
	raycast_attributes.call(raycast_under, 0, scale_formula, default_target_pos_y + 10, col_mask)

	add_child(raycast_under_right)
	raycast_attributes.call(raycast_under_right, 45, scale_formula / 1.3, 16, col_mask)

	add_child(raycast_under_left)
	raycast_attributes.call(raycast_under_left, -45, scale_formula / 1.3, 16, col_mask)
	
	add_child(raycast_top)
	raycast_attributes.call(raycast_top, 180, scale_formula, default_target_pos_y, col_mask)

	add_child(raycast_top_right)
	raycast_attributes.call(raycast_top_right, 135, scale_formula, default_target_pos_y, col_mask)

	add_child(raycast_top_left)
	raycast_attributes.call(raycast_top_left, -135, scale_formula, default_target_pos_y, col_mask)

# func raycast_speed_modification(): # fix later; could be the key to jump paradox
# 	match self.SPEED:
# 		var x when x > 0:
# 			raycast_left.target_position.y = 10
# 		var x when x < 0:
# 			raycast_right.target_position.y = 10
func raycast_detection():
	if self.raycast_right.is_colliding() or self.raycast_top_right.is_colliding() and not self.raycast_left.is_colliding():
		if self.raycast_top.is_colliding():
			return
		else:
			enemy_jump()
	
	elif self.raycast_left.is_colliding() or self.raycast_top_left.is_colliding() and not self.raycast_right.is_colliding():
		if self.raycast_top.is_colliding():
			return
		else:
			enemy_jump()
	
	elif self.raycast_right.is_colliding() and self.raycast_left.is_colliding() \
	or self.raycast_top_right.is_colliding() and self.raycast_top_left.is_colliding():
		print('hi')
		if self.raycast_top.is_colliding():
			return
		elif raycast_right.get_collider() and raycast_left.get_collider() is TileMapLayer or \
		self.raycast_top_right and self.raycast_top_left is TileMapLayer:
			wall_jump()

	if self.raycast_under_right.is_colliding(): # not an elif because it is independent from raycast_right/left
		damage_detection(tile_map(), raycast_under_right)
	elif self.raycast_under_left.is_colliding():
		damage_detection(tile_map(), raycast_under_left)
	
	if not self.raycast_under_right.is_colliding() or not self.raycast_under_left.is_colliding():
		if not is_on_floor() or abs(get_floor_normal().x) != 1:
			return
		set_speed(SPEED * -1)
	if self.raycast_under.is_colliding():
		damage_detection(tile_map(), raycast_under)
	# if self.raycast_top_right.is_colliding():
	# 	damage_detection(tile_map(), raycast_top_right)
	# elif self.raycast_top_left.is_colliding():
		damage_detection(tile_map(), raycast_top_left)
#endregion
#region damage
func damage_detection(tileMap: TileMapLayer, raycast: RayCast2D):
	if raycast.get_collider() is TileMapLayer:
		var cell = tileMap.local_to_map(tileMap.to_local(raycast.get_collision_point()))
		var cell_data = tileMap.get_cell_tile_data(cell)
		if cell_data:
			if cell_data.get_custom_data("Damageable"):
				#if is_on_wall_only():
					#wall_jump()
					#await get_tree().create_timer(0.6).timeout
					#set_speed(SPEED * -1)
				if is_on_floor() or not is_on_floor():
						if can_jump == true or enemy_jump_count < 2:
							enemy_jump()
						elif can_jump == false or enemy_jump_count >= 2:
							enemy_dash()
func decohere():
	print("decohere")
	if damage_checker == false:
		if is_on_floor():
			velocity.y = -300
			set_speed(SPEED * 0.9)
		elif is_on_wall():
			move_local_x(10 * get_wall_normal().x)
		damage_checker = true
		await get_tree().create_timer(1).timeout
		damage_checker = false # create dedicated invincibility function later with damage flash
#endregion		
