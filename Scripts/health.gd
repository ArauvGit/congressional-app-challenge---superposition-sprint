extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_health_display():
	var child_node = get_child(0)
	if Global.dead: 
		return
	else: 
		while get_child_count() != Global.health:
			if get_child_count() > Global.health:
				create_tween()
				remove_child(self.get_children().back())
			elif get_child_count() < Global.health:
				add_child(child_node.duplicate())

func _on_update_health() -> void:
	update_health_display()
