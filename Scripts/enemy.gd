extends Contestant
class_name enemy

func _init():
	print("the enemy script has been activated")
	super.set_physics_process(true)
func _physics_process(delta: float) -> void:
	super(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		Global.state = Global.States.MOVING
		super.state_machine()
