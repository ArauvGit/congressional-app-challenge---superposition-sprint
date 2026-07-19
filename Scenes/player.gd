extends Contestant
class_name Player

func _init() -> void:
	super.set_physics_process(true)
	print("the player script has been activated")

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	super(delta)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		print(self.get_groups())
		Global.state = Global.States.MOVING
		super.state_machine()
