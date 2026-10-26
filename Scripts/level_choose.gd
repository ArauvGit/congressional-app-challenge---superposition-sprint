extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func level_1_pressed() -> void:
	var animation: AnimationPlayer = Transition.get_child(0)
	animation.play("transition")
	await animation.animation_finished
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func level_2_pressed() -> void:
	var animation: AnimationPlayer = Transition.get_child(0)
	animation.play()
	await animation.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Level2.tscn")


func tutorial_pressed() -> void:
	var animation: AnimationPlayer = Transition.get_child(0)
	animation.play()
	await animation.animation_finished
	get_tree().change_scene_to_file("res://tutorial_level.tscn")
