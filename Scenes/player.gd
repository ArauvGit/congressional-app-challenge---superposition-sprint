extends Contestant
class_name Player

func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	super(delta)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_right"):
		Global.state = Global.States.MOVING
		super.state_machine()
