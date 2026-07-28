extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health_display():
	var child_node = get_child(0)
	for i in range(get_child_count()):
		if get_child_count() > Global.health:
			remove_child(self.get_children().back())
		elif get_child_count() < Global.health:
			add_child(child_node.duplicate())

func _on_update_health() -> void:
	update_health_display()
