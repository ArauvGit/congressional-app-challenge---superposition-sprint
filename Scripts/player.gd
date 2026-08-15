extends Contestant
class_name Player
var jump_count: int = 0
var detector: Area2D = get_child(1)
var damage_checker: bool = false
#region important functions
func _init() -> void:
	self.connect("take_damage", decohere)
	print(detector)
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
	if is_on_floor() and get_child(2).flip_h == false:
		Global.state = Global.States.MOVING_RIGHT
	elif is_on_floor() and get_child(2).flip_h == true:
		Global.state = Global.States.MOVING_LEFT
	change_direction()
	jump()
	wall_jump()
	player_dash()
	sprint()

#endregion
#region movement 
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
	pass
	#var x: String
	#match Input.is_action_pressed(x):
	#	"move_left":
	#		Global.state = Global.States.SPRINTING_LEFT
	#	"move_right":
	#		Global.state = Global.States.SPRINTING_RIGHT
	# if Input.is_action_pressed("move_left"):
	# 	Global.state = Global.States.SPRINTING_LEFT
	# 	state_machine()
	# elif Input.is_action_pressed("move_right"):
	# 	Global.state = Global.States.SPRINTING_RIGHT
	# 	state_machine()
func player_dash():
	if Input.is_action_just_pressed("dash") and dash_checker == false and dash_cooldown == false:
		match Global.state:
			Global.States.MOVING_RIGHT:
				# Global.state = Global.States.DASHING_RIGHT
				# state_machine()
				for Name in Contestant_information.keys():
					if get_groups()[0] == Name:
						set_speed(Contestant_information.get(Name)["SPEED"] * 5)
				dash_checker = true
				await get_tree().create_timer(0.3).timeout
				for Name in Contestant_information.keys():
					if get_groups()[0] == Name:
						set_speed(Contestant_information.get(Name)["SPEED"])
				dash_checker = false
			Global.States.MOVING_LEFT:
				for Name in Contestant_information.keys():
					if get_groups()[0] == Name:
						set_speed(Contestant_information.get(Name)["SPEED"] * -5)
				# Global.state = Global.States.DASHING_LEFT
				# state_machine()
				dash_checker = true
				await get_tree().create_timer(0.3).timeout
				dash_checker = false
				for Name in Contestant_information.keys():
					if get_groups()[0] == Name:
						set_speed(Contestant_information.get(Name)["SPEED"] * -1)
				Global.state = Global.States.MOVING_LEFT
				state_machine()
		dash_cooldown = true
		await get_tree().create_timer(3).timeout
		dash_cooldown = false
func wall_jump():
	if is_on_wall_only():
		match Global.state:
			Global.States.MOVING_RIGHT:
				if not is_on_floor():
					animated_sprite.flip_h = true
			Global.States.MOVING_LEFT:
				if not is_on_floor():
					animated_sprite.flip_h = false
		velocity.y = 50
		if Input.is_action_just_pressed("jump"):
			move_local_x(10 * get_wall_normal().x)
			set_speed(SPEED * -1)
			double_jump()
#endregion
#region health
func health_powerup():
	set_health(Global.health + Powerup_information["RESTORATION"])
func set_health(new_health: int) -> int:
	if Global.health != new_health:
		Global.health = new_health
	update_health.emit()
	return Global.health
func decohere():
	if damage_checker == false:
		set_health(Global.health - 1)
		set_speed(SPEED * -0.9)
		if is_on_floor():
			velocity.y = -500
		elif is_on_wall():
			move_local_x(10 * get_wall_normal().x)
			double_jump()
		damage_checker = true
		await get_tree().create_timer(1).timeout
		damage_checker = false # create dedicated invincibility function later with damage flash
#endregion		
