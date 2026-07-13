extends Button
var button_names: Array = ["yellow", "green", "red", "blue"]
func _ready() -> void:
	pass # Replace with function body.
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	for group in get_groups():
		for group_name in button_names:
			if group.contains(group_name):
				pass #add the player set script later
	
func _script_tranformation():
	self.set_script()
