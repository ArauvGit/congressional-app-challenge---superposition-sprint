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
	if is_on_floor():
		jump_count = 0
	player_jump()
	wall_jump()

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
		jump_count += 1
	elif Input.is_action_just_pressed("jump") and jump_count == 1:
		double_jump()
func double_jump() -> void:
	velocity.y = JUMP_VELOCITY
	jump_count += 1
func player_dash():
	if Input.is_action_just_pressed("dash") and dash_checker == false and dash_cooldown == false:
		dash()
func wall_jump():
	if is_on_wall_only():
		wall_hang()
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
