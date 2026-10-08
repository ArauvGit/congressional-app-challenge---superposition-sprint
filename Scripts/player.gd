extends Contestant
class_name Player
var detector: Area2D = get_child(1)
var can_play_animation: bool = true
var camera_nudge: int = 185
var nudge_multiplier: int = 0

#region important functions
func _init() -> void:
	$"../../health container/Control/healthbar".show()
	RaceSong.play()
	self.connect("take_damage", player_decohere)
	for Name in Contestant_information.keys():
		if self.get_groups()[0] == Name:
			set_health(Contestant_information.get(Name)["HEALTH"])
	super.set_physics_process(true)
	print("the player script has been activated")
	print(self.get_groups())
	for node in get_parent().get_children():
		if node is Camera2D:
			node.position_smoothing_enabled = true
			node.reparent(self)
			node.move_local_x(position.x)
		self.move_to_front()
func _physics_process(delta: float) -> void:
	self_modulate = Color("a23466ff")
	super(delta)
	if is_on_floor():
		jump_count = 0
	else:
		can_squish = true
	player_jump()
	wall_jump()
	player_dash()
	die()
	player_camera_pos_config()
	movement_freeze()
#endregion
#region movement 
func player_camera_pos_config():
	for node in self.get_children():
		if node is Camera2D:
			if get_platform_velocity() == Vector2.ZERO:
				node.global_position.x = self.global_position.x + camera_nudge * velocity.normalized().x
			else: 
				node.global_position.x = self.global_position.x
func movement_freeze():
	if get_platform_velocity() != Vector2.ZERO:
		match animated_sprite:
			var x when x.flip_h:
				camera_nudge = -300
			var x when not x.flip_h:
				camera_nudge = 300
		
	else:
		movement(SPEED)
		camera_nudge = 185
func get_dict_health():
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			return Contestant_information.get(Name)["HEALTH"]
func health_damage_checker():
	if Global.health < get_dict_health():
		Global.damaged = true
	else:
		Global.damaged = false
func player_jump() -> void:
	speed_sprite_flip()
	if jump_count == 1:
		return
	if is_on_floor():
		self.scale.x = 1
		jump_count = 0
	if Input.is_action_just_pressed("jump") and jump_count == 0:
		SFX.get_child(0).pitch_scale = randf_range(0.5, 1.5)
		SFX.get_child(0).play()
		jump()
		jump_count += 1
		if is_on_floor():
			squash(1.2, 0.7, 0.05)
		else:
			squash(1.1, 1.1, 0.05)
	elif Input.is_action_just_pressed("jump") and jump_count == 1:
		SFX.get_child(0).play()
		double_jump()
func double_jump() -> void:
	if is_in_group("player"): 
		SFX.get_child(0).play()
	velocity.y = JUMP_VELOCITY
	jump_count += 1
func player_dash():
	if Input.is_action_just_pressed("dash") and dash_checker == false and dash_cooldown == false:
		SFX.get_child(1).pitch_scale = randf_range(0.8, 1.3)
		SFX.get_child(1).play()
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
	health_damage_checker()
	update_health.emit()
	return Global.health


func player_decohere():
	var damage_animation := func():
		var tween = create_tween()
		tween.tween_property(animated_sprite, "modulate", Color(0.576, 0.139, 0.22, 1.0), 0.05)
		await get_tree().create_timer(0.05).timeout
		for i in range(5):
			tween.tween_property(animated_sprite, "modulate", Color("ffffff38"), 0.4)
			tween.tween_property(animated_sprite, "modulate", Color("ffffffff"), 0.4)
	if damage_checker == false:
		SFX.get_child(3).play()
		damage_animation.call()
		set_health(Global.health - 1)
		set_speed(SPEED * -1 * decoherence_multiplier)
		velocity.y = -500
		if is_on_wall():
			move_local_x(10 * get_wall_normal().x)
			for i in range(10):
				move_local_y(-1)
				await get_tree().process_frame
			player_jump()
			state_machine()
		elif not is_on_floor():
			Global.damaged = true
			Global.state = Global.States.DAMAGING
			state_machine() 
	
		damage_checker = true
		await get_tree().create_timer(1).timeout
		match self:
			var x when not x.is_on_floor() and not dash_checker:
				Global.state = Global.States.JUMPING
				state_machine()
			var x when x.is_on_floor() and dash_checker == false:
				Global.state = Global.States.MOVING
				state_machine()
			var x when x.is_on_wall():
				Global.state = Global.States.WALL_HANGING
				state_machine()
			var x when dash_checker == true:
				Global.state = Global.States.DASHING
				state_machine()
		damage_checker = false # create dedicated invincibility function later with damage flash
func interference_powerup():
	for child in get_parent().get_parent().get_children():
		if child is CanvasLayer and child.name.contains("Interference"):
			if Global.interference_works == true:
				child.show()
				Global.interference_works = false
func die():
	if Global.health <= 0:
		for child in get_parent().get_parent().get_children():
			if child is CanvasLayer and child.name.contains("Decoherence"):
				child.show()
				if can_play_animation == true:
					child.get_child(2).play("RESET")
					can_play_animation = false
#endregion		
