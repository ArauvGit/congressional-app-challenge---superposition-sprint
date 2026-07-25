extends Contestant
class_name enemy

func _init():
	super.set_physics_process(true)
	print("the enemy script has been activated")
	super.set_physics_process(true)
func _physics_process(delta: float) -> void:
	super(delta)
