extends Contestant
class_name enemy
#region variables
#region raycast variables

var raycast_parent = Node2D.new()
var raycast_right = RayCast2D.new()
var raycast_left = RayCast2D.new()
var raycast_under = RayCast2D.new()
var raycast_top = RayCast2D.new()

var platform_area = Area2D.new()
var platform_area_collision = CollisionShape2D.new() 
var platform_waiting: bool = false

var length = get_contestant_jump() / -60
var height = multiplier(get_contestant_jump(), -0.1) / 25
#endregion
#region jump variables
var enemy_jump_count: int = 0
var jump_checker: bool = false
var can_jump: bool = true
var jump_toggle_time: int = 3
var timer_duration: float = jump_cooldown_formula(get_contestant_jump())
var color_change: ColorRect = animated_sprite.get_child(0)
var can_decohere: bool = true
#endregion
#endregion
#region important functions
func _init():
	self.connect("take_damage", decohere)
	super.set_physics_process(true)
	raycast_init()
	area_init(platform_area, platform_area_collision)
	print("the enemy script has been activated")
	super.set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not platform_waiting:  
		movement(SPEED)
	else: 
		movement(0)
		Global.state = Global.States.IDLE
		state_machine()
	if is_on_floor():
		self.enemy_jump_count = 0
		self.can_jump = true
	if self.enemy_jump_count != 2:
		self.can_jump = true
	raycast_detection()
	area_calculations(platform_area, platform_area_collision)
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
	Global.state = Global.States.JUMPING
	state_machine()
	if enemy_jump_count == 2:
		can_jump = false
		return
	if can_jump == false:
		return
	if is_on_floor() and enemy_jump_count == 0 and jump_checker == false:
		squash(1.2, 0.7, 0.05)
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			Global.state = Global.States.JUMPING
			state_machine()
		jump_checker = true
		await get_tree().create_timer(timer_duration).timeout
		jump_checker = false
		enemy_jump_count += 1
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
func jump_cooldown_formula(jump_cooldown: float) -> float:
	var timer = jump_cooldown / -650
	return timer
#endregion
#endregion
#region raycast specific functions
func multiplier(multiplier1: float, multiplier2: float) -> float:
	var formula = multiplier1 * multiplier2
	return formula

func raycast_init():
	var scale_formula: float = multiplier(get_contestant_jump(), -0.014)
	var default_target_pos_y: int = 20
	var _under_target_pos_y: int = 16 # raycast_under_right handles tilemap stuff so this is better
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
	
	add_child(raycast_top)
	raycast_attributes.call(raycast_top, 180, scale_formula, default_target_pos_y, col_mask)


func area_init(area: Area2D, collision_shape: CollisionShape2D): 
	area.scale = Vector2(length, height) 
	area.set_collision_mask_value(5, true) 
	area.set_collision_mask_value(1, false)
	area.set_collision_layer_value(1, true)
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.scale = Vector2(length, height)
	area.add_child(collision_shape)
	add_child(area)

func account_margin_error(num1: float, num2: float, num3: float): 
	return num1 == num2 - num3 or num1 == num2 + num3 

func area_calculations(area: Area2D, collision_shape: CollisionShape2D): 
	if platform_waiting:
		Global.state = Global.States.IDLE
		state_machine()
	if area.has_overlapping_bodies(): 
		var platform = area.get_overlapping_bodies()[0]
		if platform.position.normalized().x == self.velocity.normalized().x:  
			if account_margin_error(platform.global_position.x, self.SPEED, platform.get_child(0).texture.get_size().x * 2.5):
				platform_waiting = false
				self.enemy_jump()
			else: 
				platform_waiting = true  
	else: 
		platform_waiting = false


func raycast_detection():
	if self.raycast_right.is_colliding() and not self.raycast_left.is_colliding():
		if self.raycast_top.is_colliding():
			return
		else:
			enemy_jump()
	
	elif self.raycast_left.is_colliding()  and not self.raycast_right.is_colliding():
		if self.raycast_top.is_colliding():
			return
		else:
			enemy_jump()
			
	#if self.raycast_top_left.is_colliding() and self.raycast_top_right.is_colliding(): 
		#if self.raycast_top.is_colliding():
			#return
		#if raycast_top_right.get_collider() is TileMapLayer and raycast_top_left.get_collider() is TileMapLayer:
			#wall_jump()
	
	if self.raycast_right.is_colliding() and self.raycast_left.is_colliding():
		if self.raycast_top.is_colliding():
			return
		if raycast_right.get_collider() is TileMapLayer and raycast_left.get_collider() is TileMapLayer:
			wall_jump()

	if self.raycast_under.is_colliding():
		damage_detection(tile_map(), raycast_under)
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
	if can_decohere:
		var damage_animation := func():
			color_change.color = Color(1.0, 1.0, 1.0, 1.0)
			await get_tree().create_timer(0.02).timeout
			color_change.color = Color(1.0, 0, 0, (1.2 - decoherence_multiplier) * 1.15)
			Color(0.88, 0.0, 0.0, 1.0)
		if damage_checker == false:
			SFX.get_child(3).play()
			freeze_frame()
			damage_animation.call()
			decoherence_multiplier -= decoherence_reduction
			set_speed(SPEED * decoherence_multiplier)
			velocity.y = -500
			if is_on_wall():
				move_local_x(10 * round(get_wall_normal().x))
				for i in range(10):
					move_local_y(-1)
					await get_tree().process_frame
				enemy_jump()
				state_machine()
			elif not is_on_floor():
				Global.state = Global.States.DAMAGING
				state_machine()
			damage_checker = true
			await get_tree().create_timer(1).timeout
			await decoherence_end
			damage_checker = false # create dedicated invincibility function later with damage flash
			invincibility()
			match self:
				var x when x.is_on_floor() and dash_checker == false:
					Global.state = Global.States.MOVING
					state_machine()
				var x when x.is_on_wall():
					Global.state = Global.States.WALL_HANGING
					state_machine()
				var x when Global.state == Global.States.DASHING: 
					state_machine()
					dash() 
func health_powerup(): 
	decoherence_multiplier = 1
func invincibility(): 
	create_tween().tween_property(color_change, "color", Color(0.99, 0.495, 0.0, 0.5), 0.1)
	can_decohere = false
	await get_tree().create_timer(3).timeout 
	create_tween().tween_property(color_change, "color", Color(1, 0, 0, (1.2 - decoherence_multiplier) * 1.15), 0.1)
	can_decohere = true
#endregion		
