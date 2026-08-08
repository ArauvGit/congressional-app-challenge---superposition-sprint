extends Contestant
class_name enemy
var raycast_right = RayCast2D.new()
var raycast_left = RayCast2D.new()
var jump_count = 0

func _init():
	super.set_physics_process(true)
	raycast_init()
	print("the enemy script has been activated")
	super.set_physics_process(true)
func _physics_process(delta: float) -> void:
	raycast_detection()
	super(delta)

func jump() -> void:
	if is_on_floor():
		jump_count = 0
	if jump_count == 0:
		velocity.y = JUMP_VELOCITY
		Global.state = Global.States.JUMPING
		state_machine()
		jump_count += 1
	elif not is_on_floor() and jump_count == 1: 
		Global.state = Global.States.JUMPING
		state_machine()
		double_jump()
	
func double_jump():
	velocity.y = JUMP_VELOCITY
	jump_count += 1
func wall_jump():
	if is_on_wall() and not is_on_floor():
		velocity.y = 50
		if not is_on_floor() and is_on_wall():
			move_local_x(10 * get_wall_normal().x)
			set_speed(SPEED * -1)
			change_direction()
			double_jump()


func raycast_init():
	add_child(raycast_right)
	raycast_right.rotation_degrees = -90
	raycast_right.scale *= 5
	raycast_right.target_position.y = 20
	raycast_right.collision_mask = 2
	add_child(raycast_left)
	raycast_left.rotation_degrees = 90
	raycast_left.scale *= 5
	raycast_left.target_position.y = 20
	raycast_left.collision_mask = 2
func raycast_detection():
	if raycast_right.is_colliding() or raycast_left.is_colliding():
		if raycast_right.get_collider() is TileMapLayer:
			jump()
	if raycast_right.is_colliding() and raycast_left.is_colliding():
		wall_jump()
