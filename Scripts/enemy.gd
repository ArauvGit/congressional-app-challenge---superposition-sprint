extends Contestant
class_name enemy

func _init():
	super.set_physics_process(true)
	print("the enemy script has been activated")
<<<<<<< HEAD
	super.set_physics_process(true)
func _physics_process(delta: float) -> void:
	super(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
=======
func _physics_process(delta: float) -> void:
	super(delta)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		print(self.get_groups())
>>>>>>> 5225b71f3754dfd430d38c48a9c4fe5b4e8a65ac
		Global.state = Global.States.MOVING
		super.state_machine()
