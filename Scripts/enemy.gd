extends Contestant
class_name enemy

func _init():
	set_health(1)
	super.set_physics_process(true)
	print("the enemy script has been activated")
	super.set_physics_process(true)
func _physics_process(delta: float) -> void:
	super(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		print(self.get_groups())
		Global.state = Global.States.MOVING
		super.state_machine()
