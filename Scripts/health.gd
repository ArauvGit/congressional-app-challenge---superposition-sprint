extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_health_display():
	var child_node = get_child(0)
	while get_child_count() != Global.health:
		if get_child_count() > Global.health:
			for i in range(2):
				self.get_children().back().modulate = Color(1.0, 1.0, 1.0, 0.365)
				await get_tree().create_timer(0.2).timeout
				self.get_children().back().modulate = Color(1.0, 1.0, 1.0, 1.0)
				await get_tree().create_timer(0.2).timeout 
			await get_tree().create_timer(0.3).timeout
			remove_child(self.get_children().back())
		elif get_child_count() < Global.health:
			add_child(child_node.duplicate())

func _on_update_health() -> void:
	update_health_display()
