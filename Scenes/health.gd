extends HBoxContainer
signal update_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health_display():
	update_health.emit()
	if get_child_count() != Global.health:
		var difference = get_child_count() - Global.health
		var child_node = get_children()[0]
		for i in range(difference):
			if difference > 0: 
				remove_child(get_children().back())


func _on_update_health() -> void:
	update_health_display()
