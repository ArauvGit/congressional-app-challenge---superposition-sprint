extends Contestant
class_name enemy
var raycast = RayCast2D.new()
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
	velocity.y = JUMP_VELOCITY
	Global.state = Global.States.JUMPING
	state_machine()
	jump_count += 1
	print(jump_count)

func raycast_init():
	add_child(raycast)
	raycast.rotation_degrees = -90
	raycast.scale *= 2
	raycast.target_position.y  = 45
func raycast_detection():
	if raycast.is_colliding():
		if raycast.get_collider() is TileMapLayer:
			jump()
			
