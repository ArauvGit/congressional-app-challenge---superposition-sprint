extends Contestant
class_name Player
func _init() -> void:
	super.set_physics_process(true)
	print("the player script has been activated")
	for node in get_parent().get_children():
		if node is Camera2D: 
			node.reparent(self)
		self.move_to_front()
 
func _physics_process(delta: float) -> void:
	super(delta)
	#jump()
	#sprint()
#func jump() -> void:
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		Global.state = Global.States.JUMPING
#		state_machine()
#func sprint() -> void:
#	if Input.is_action_pressed("ui_left"):
#		Global.state = Global.States.SPRINTING
#		state_machine()	



		
