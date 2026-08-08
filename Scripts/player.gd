extends Contestant
class_name Player
var jump_count: int = 0
#region important functions
func _init() -> void:
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			set_health(Contestant_information.get(Name)["HEALTH"])
	super.set_physics_process(true)
	print("the player script has been activated")
	for node in get_parent().get_children():
		if node is Camera2D: 
			node.reparent(self)
			node.move_local_x(position.x)
		self.move_to_front()
func _physics_process(delta: float) -> void:
	super(delta)
	if is_on_floor() and get_child(1).flip_h == false:
		Global.state = Global.States.MOVING_RIGHT
	elif is_on_floor() and get_child(1).flip_h == true:
		Global.state = Global.States.MOVING_LEFT
	change_direction()
	jump()
	wall_jump()
	sprint()
#endregion
#region movement 
# func change_direction():
# 	if SPEED > 0:
# 		Global.state = Global.States.MOVING_RIGHT
# 	elif SPEED < 0:
# 		Global.state = Global.States.MOVING_LEFT
# 	match Global.state:
# 		Global.States.MOVING_RIGHT:
# 			animated_sprite.flip_h = false
# 			if Input.is_action_just_pressed("move_left"):
# 				Global.state = Global.States.MOVING_LEFT
# 				state_machine()
# 		Global.States.MOVING_LEFT:
# 			animated_sprite.flip_h = true
# 			if Input.is_action_just_pressed("move_right"):
# 				Global.state = Global.States.MOVING_RIGHT
# 				state_machine()
func jump() -> void:
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed("jump") and jump_count == 0:
			velocity.y = JUMP_VELOCITY
			match animated_sprite:
				var x when x.flip_h == true:
					Global.state = Global.States.JUMPING_LEFT
				var x when x.flip_h == false:
					Global.state = Global.States.JUMPING_RIGHT
			state_machine()
			jump_count += 1
	elif Input.is_action_just_pressed("jump") and jump_count == 1:
		double_jump()
func double_jump() -> void:
	if Input.is_action_pressed("move_right"):
		Global.state = Global.States.JUMPING_RIGHT
		state_machine()
	elif Input.is_action_pressed("move_left"):
		Global.state = Global.States.JUMPING_LEFT
		state_machine()
	velocity.y = JUMP_VELOCITY
	jump_count += 1
func sprint() -> void:
	if Input.is_action_pressed("ui_left"):
		Global.state = Global.States.SPRINTING
		state_machine()	
func wall_jump():
	if is_on_wall() and not is_on_floor():
		velocity.y = 50
		if Input.is_action_just_pressed("jump"):
			move_local_x(10 * get_wall_normal().x)
			set_speed(SPEED * -1)
			change_direction()
			double_jump()
#endregion
#region health
func set_health(new_health: int) -> int:
	update_health.emit()
	if Global.health != new_health:
		Global.health = new_health
	if new_health < Global.health:
		SPEED *= 0.8
	update_health.emit()
	return Global.health
func health_powerup():
	set_health(Global.health + Powerup_information["RESTORATION"])
#endregion		
