extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in SFX.get_children(): 
		child.stop()
	SFX.get_child(6).play() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func level_1_pressed() -> void:
	var animation: AnimationPlayer = Transition.get_child(1)
	animation.play("transition")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func level_2_pressed() -> void:
	var animation: AnimationPlayer = Transition.get_child(1)
	animation.play("transition")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Level2.tscn")


func tutorial_pressed() -> void:
	var animation: AnimationPlayer = Transition.get_child(1)
	animation.play("transition")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://tutorial_level.tscn")


func intro_pressed() -> void:
	var animation: AnimationPlayer = Transition.get_child(1)
	animation.play("transition")
	await get_tree().create_timer(0.5).timeout
	for child in SFX.get_children(): 
		child.stop()
	get_tree().change_scene_to_file("res://cutscene.tscn")
