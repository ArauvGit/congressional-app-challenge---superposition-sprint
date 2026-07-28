extends Contestant
class_name Player
func _init() -> void:
	super.set_physics_process(true)
	print("the player script has been activated")
	for node in get_parent().get_children():
		if node is Camera2D: 
			node.reparent(self)
		self.move_to_front()
	match self: 
		var x when x.is_in_group("yellow"):
			set_health(Contestant_information.Yellow["HEALTH"])
		var x when x.is_in_group("green"):
			set_health(Contestant_information.Green["HEALTH"])
		var x when x.is_in_group("red"):
			set_health(Contestant_information.Red["HEALTH"])
		var x when x.is_in_group("blue"):
			set_health(Contestant_information.Blue["HEALTH"])
func _physics_process(delta: float) -> void:
	super(delta)
	jump()
	sprint()
func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		Global.state = Global.States.JUMPING
		state_machine()
func sprint() -> void:
	if Input.is_action_pressed("ui_left"):
		Global.state = Global.States.SPRINTING
		state_machine()	

func set_health(new_health: int) -> int:
	if Global.health != new_health:
		Global.health = new_health
	if new_health < Global.health:
		SPEED *= 0.8
	update_health.emit()
	return Global.health


		
