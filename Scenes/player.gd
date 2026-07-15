extends Contestant
class_name Player

func _init() -> void:
	super._ready()

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	print("physics process is true")
	super(delta)
	print("hi")
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		Global.state = Global.States.MOVING
		super.state_machine()
