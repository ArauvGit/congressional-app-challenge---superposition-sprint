extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SFX.get_child(7).play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_select_pressed() -> void:
	var animation = Transition.get_child(1)
	animation.play("transition")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/level_assign.tscn")
