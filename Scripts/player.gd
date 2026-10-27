extends Contestant
class_name Player
var detector: Area2D = get_child(1)
var can_play_animation: bool = true
var camera_nudge: float = 185
var nudge_multiplier: int = 0
var color_change: ColorRect = animated_sprite.get_child(0)
var can_decohere: bool = true
var can_die: bool = true
var coyote_time_possible: bool = true
#region important functions
func _init() -> void:
	RaceSong.play()
	print()
	self.connect("take_damage", player_decohere)
	for Name in Contestant_information.keys():
		if self.get_groups()[0] == Name:
			set_health(Contestant_information.get(Name)["HEALTH"])
	super.set_physics_process(true)
	for node in get_parent().get_children():
		if node is Camera2D:
			node.position_smoothing_enabled = true
			node.reparent(self)
			node.move_local_x(position.x)
		self.move_to_front()
func _physics_process(delta: float) -> void:
	super(delta)
	movement(SPEED)
	if is_on_floor():
		jump_count = 0
	else:
		can_squish = true
	if Global.can_interact:
		player_jump()
		wall_jump()
		player_dash()
	die()
	coyote_time()
	player_camera_pos_config()
	if get_tree().get_first_node_in_group("tutorial"):
		tutorial_cutscene_show()
		tutorial_enemy_show()

	movement_freeze()
	
#endregion
#region movement contes
func player_camera_pos_config():
	var platform_nudge = camera_nudge / 5
	for node in self.get_children():
		if node is Camera2D:
			if get_platform_velocity() == Vector2.ZERO:
				node.global_position.x = self.global_position.x + camera_nudge * velocity.normalized().x
			else:
				node.global_position = self.global_position + Vector2(platform_nudge, platform_nudge) * velocity.normalized()
			node.position.y = -25
func movement_freeze():
	if get_platform_velocity() != Vector2.ZERO:
		match animated_sprite:
			var x when x.flip_h:
				camera_nudge = -300
			var x when not x.flip_h:
				camera_nudge = 300 
		if Input.is_action_just_pressed("jump"):
			velocity.y == get_platform_velocity().y / 2
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
func coyote_time(): 
	print(coyote_time_possible)
	if is_on_floor(): 
		coyote_time_possible = true 
	elif not is_on_floor(): 
		if jump_count == 0:
			coyote_time_possible = true 
			await get_tree().create_timer(2).timeout
			coyote_time_possible = false
		else: 
			coyote_time_possible = false
		return coyote_time_possible


func player_jump() -> void:
	speed_sprite_flip()
	if jump_count == 1:
		return
	if coyote_time_possible:
		self.scale.x = 1
		jump_count = 0
	if Input.is_action_just_pressed("jump") and jump_count == 0:
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
			move_local_x(10 * round(get_wall_normal().x))
			set_speed(SPEED * -1)
			double_jump()
	elif is_on_floor() and is_on_wall(): 
		if Input.is_action_just_pressed("jump"):
			create_tween().tween_property(self, "position", Vector2(position.x + 25 * get_wall_normal().x, position.y), 0.1)
			set_speed(SPEED * -1)
#endregion
#region health
func health_powerup():
	set_health(Global.health + Powerup_information["RESTORATION"])
	decoherence_multiplier = 1
func set_health(new_health: int) -> int:
	if Global.health != new_health:
		Global.health = new_health
	health_damage_checker()
	update_health.emit()
	return Global.health

func return_speed():
	for Name in Contestant_information.keys():
		if get_groups()[0] == Name:
			var speed_val = Contestant_information.get(Name)["SPEED"]
			return speed_val

func player_decohere():
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
			set_health(Global.health - 1)
			velocity.y = -500
			if is_on_wall():
				move_local_x(10 * round(get_wall_normal().x))
				for i in range(10):
					move_local_y(-1)
					await get_tree().process_frame
				player_jump()
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
func invincibility(): 
	create_tween().tween_property(color_change, "color", Color(0.99, 0.495, 0.0, 0.5), 0.1)
	can_decohere = false
	await get_tree().create_timer(3).timeout 
	create_tween().tween_property(color_change, "color", Color(1, 0, 0, (1.2 - decoherence_multiplier) * 1.15), 0.1)
	can_decohere = true


func tutorial_cutscene_show(): 
	var triggers_function = func(): 
		for node in get_parent().get_parent().get_children(): 
			if node.name == "triggers": 
				return node 
	var triggers = triggers_function.call()
	var slomo = func(): 
		for node in get_parent().get_parent().get_children(): 
			if node.name == "background_transparent": 
				create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(node, "modulate", Color(1, 1, 1, 1), 0.2)
		create_tween().tween_property(get_parent().get_parent().get_child(0).get_child(0), "modulate", Color(1, 1, 1, 1), 0.2)
		create_tween().set_trans(Tween.TRANS_EXPO).tween_property(Engine, "time_scale", 0.05, 0.2)
		create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(get_child(3), "zoom", Vector2(1.75, 1.75), 0.3 / Engine.time_scale)
	var undo_slomo = func(): 
		for node in self.get_children(): 
			if node is Camera2D:
				node.position_smoothing_speed = 2
				create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(node, "zoom", Vector2(1, 1), 0.2)
		create_tween().tween_property(get_parent().get_parent().get_child(0).get_child(0), "modulate", Color(1, 1, 1, 0), 0.2)
		for node in get_parent().get_parent().get_children():
			if node.name == "background_transparent":
				create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(node, "modulate", Color(1, 1, 1, 0), 0.2)
		create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(Engine, "time_scale", 1, 0.5)
	var dialogue = func(): 
		for node in get_parent().get_parent().get_child(0).get_children(): 
			node.get_child(0).show()
	for node in triggers.get_children(): 
		if node.has_overlapping_bodies():
			if node.get_overlapping_bodies().any(func(element): return element.is_in_group("player")):
				if node.name.contains("cutscene"): 
					slomo.call()  
					dialogue.call()
					cutscene_dialogue.emit()
					node.queue_free()
				await stop_tutorial_dialogue 
				undo_slomo.call()

									
					


				
func tutorial_enemy_show(): 
	var trigger_parent = func(): 
		for child in get_parent().get_parent().get_children(): 
			if child.name == "triggers": 
				return child
	var trigger_function = func(): 
		for child in trigger_parent.call().get_children(): 
			if child.name.contains("enemy"): 
				return child #I can't believe this worked
	var trigger = trigger_function.call() 
	
	var placement_parent = func(): 
		for child in get_parent().get_parent().get_children(): 
			if child.name == "placement container": 
				return child
	var placement_function = func(): 
		return placement_parent.call().get_child(0) 
	var placement = placement_function.call() 
	if trigger.has_overlapping_bodies():
		for body in trigger.get_overlapping_bodies(): 	                                    
			if body.is_in_group("enemy"): 
				body.movement(0)
			elif body == self: 
				for node in get_parent().get_children(): 
					if node.visible == false: 
						node.enemy_jump()
						node.show()
				placement.show()
			await get_tree().create_timer(2).timeout 
			if body.is_in_group("enemy"): 
				body.hide()
				return
				

func interference_powerup():
	for child in get_parent().get_parent().get_children():
		if child is CanvasLayer and child.name.contains("Interference"):
			if Global.interference_works == true:
				child.show()
				Global.interference_works = false


func die():
	if Global.health <= 0:
		Global.dead = true
		for child in get_parent().get_parent().get_children():
			if child is CanvasLayer and child.name.contains("Decoherence"):
				child.show()
				if can_play_animation == true:
					child.get_child(2).play("RESET")
					can_play_animation = false
#endregion		
