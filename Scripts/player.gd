extends Contestant
class_name Player
var jump_count: int = 0


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
	jump()
	sprint()
func jump() -> void:
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		velocity.y = JUMP_VELOCITY
		Global.state = Global.States.JUMPING
		state_machine()
		jump_count += 1
		print(jump_count)
func sprint() -> void:
	if Input.is_action_pressed("ui_left"):
		Global.state = Global.States.SPRINTING
		state_machine()	

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
		
