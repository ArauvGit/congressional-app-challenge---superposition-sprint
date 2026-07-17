extends Contestant
class_name Player

func _init() -> void:
	_physics_process(true)
	
func _ready() -> void:
	print(self.get_groups())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	print("helloooo")
	super(delta)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		print(self.get_groups())
		Global.state = Global.States.MOVING
		super.state_machine()
