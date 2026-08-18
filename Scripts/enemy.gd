extends Contestant
class_name enemy
var raycast_right = RayCast2D.new()
var raycast_left = RayCast2D.new()
var raycast_under = RayCast2D.new()
var jump_checker: bool = false

func _init():
	self.connect("take_damage", decohere)
	super.set_physics_process(true)
	raycast_init()
	print("the enemy script has been activated")
	super.set_physics_process(true)
func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_count = 0
	raycast_detection()
	super(delta)
	change_direction()

func jump() -> void:
	Global.state = Global.States.JUMPING
	state_machine()
	if is_on_floor():
		jump_count = 0
	if jump_count == 2:
		return
	if jump_count == 0:
		velocity.y = JUMP_VELOCITY
		state_machine()
		jump_count += 1
	elif not is_on_floor() and jump_count == 1: 
		Global.state = Global.States.JUMPING
		state_machine()
		jump_checker = true 
		await get_tree().create_timer(0.5).timeout
		jump_checker = false
	elif not is_on_floor() and jump_checker == false:
		double_jump()
		
	
func double_jump():
	velocity.y = JUMP_VELOCITY
func wall_jump():
	if is_on_wall() and not is_on_floor():
		move_local_x(10 * get_wall_normal().x)
		set_speed(SPEED * -1)
		double_jump()

func get_contestant_jump():
	for key in Contestant_information.keys():
		if get_groups()[0] == key:
			var Jump = Contestant_information.get(key)["JUMP"]
			return Jump

func raycast_multiplier(multiplier: float) -> float:
	var formula = multiplier * -0.014
	print(formula)
	return formula

func raycast_init():
	var scale_formula: float = raycast_multiplier(get_contestant_jump())
	var target_pos_y: int = 20
	var col_mask: int = 2
	var raycast_attributes := \
	func(raycast: RayCast2D, rotate_degrees: int, raycast_scale: float, \
	target_position_y: int, raycast_col_mask: int):
		raycast.rotation_degrees = rotate_degrees
		raycast.scale *= raycast_scale
		raycast.target_position.y = target_position_y
		raycast.collision_mask = raycast_col_mask
	add_child(raycast_right)
	raycast_attributes.call(raycast_right, -90, scale_formula, target_pos_y, col_mask)
	add_child(raycast_left)
	raycast_attributes.call(raycast_left, 90, scale_formula, target_pos_y, col_mask)
	add_child(raycast_under)
	raycast_attributes.call(raycast_under, 0, scale_formula, target_pos_y, col_mask)
func raycast_detection():
	if raycast_right.is_colliding():
		if raycast_right.get_collider() is TileMapLayer:
			if SPEED < 0:
				set_speed(SPEED * -1)
			change_direction()
			jump()
	elif raycast_left.is_colliding():
		if raycast_left.get_collider() is TileMapLayer:
			if SPEED > 0:
				set_speed(SPEED * -1)
			change_direction()
			jump()
	if raycast_right.is_colliding() and raycast_left.is_colliding():
		wall_jump()
func decohere():
	print(get_contestant_jump() * -0.002)
	if damage_checker == false:
		if is_on_floor():
			velocity.y = -300
			set_speed(SPEED * -0.9)
		elif is_on_wall():
			move_local_x(10 * get_wall_normal().x)
			double_jump()
		damage_checker = true
		await get_tree().create_timer(1).timeout
		damage_checker = false # create dedicated invincibility function later with damage flash
#endregion		
