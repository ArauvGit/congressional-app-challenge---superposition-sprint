extends Contestant
class_name Player
var detector: Area2D = get_child(1)

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
	player_jump()
	wall_jump()
	player_dash()
	sprint()

#endregion
#region movement 
func player_jump() -> void:
	speed_sprite_flip()
	if jump_count == 1:
		return
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed("jump") and jump_count == 0:
		jump()
	elif Input.is_action_just_pressed("jump") and jump_count == 1:
		double_jump()
func double_jump() -> void:
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
			Global.States.MOVING:
				Global.state = Global.States.DASHING
				state_machine()
				dash_checker = true
				await get_tree().create_timer(0.3).timeout
				for Name in Contestant_information.keys():
					if get_groups()[0] == Name:
						set_speed(Contestant_information.get(Name)["SPEED"]) #accomodate for decoherence later
						Global.state = Global.States.MOVING
						state_machine()
				dash_checker = false
		dash_cooldown = true
		await get_tree().create_timer(3).timeout
		dash_cooldown = false
func wall_jump():
	wall_hang()
	if is_on_wall_only():
		if Input.is_action_just_pressed("jump"):
			Global.state = Global.States.JUMPING
			state_machine()
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
	var damage_animation := func():
		animated_sprite.set("shader", damage_shader)
		animated_sprite.set("shader_parameter/flash_color", Color(1, 1, 1))
		animated_sprite.set("shader_parameter/flash_value", 1.0)
		await get_tree().create_timer(2).timeout
		var tween = create_tween()
		for i in range(5):
			tween.tween_property(animated_sprite, "modulate", Color("ffffff38"), 0.4)
			tween.tween_property(animated_sprite, "modulate", Color("ffffffff"), 0.4)
	if damage_checker == false:
		damage_animation.call()
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
