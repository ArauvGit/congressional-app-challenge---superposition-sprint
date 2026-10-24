extends CanvasLayer
@export var animation_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	Global.is_pressed = false


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_assign.tscn")
