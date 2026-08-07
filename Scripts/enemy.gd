extends Contestant
class_name enemy
var horizontal_raycast = RayCast2D.new()
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
	if jump_count < 2:
		velocity.y = JUMP_VELOCITY
		Global.state = Global.States.JUMPING
		state_machine()
		jump_count += 1


func raycast_init():
	add_child(horizontal_raycast)
	horizontal_raycast.rotation_degrees = -90
	horizontal_raycast.scale *= 2
	horizontal_raycast.target_position.y = 45
	horizontal_raycast.collision_mask = 2
func raycast_detection():
	if horizontal_raycast.is_colliding():
		if horizontal_raycast.get_collider() is TileMapLayer:
			jump()
