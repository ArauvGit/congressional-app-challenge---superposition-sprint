extends TextureButton
@export var oracle: AnimatedSprite2D
@export var oracle_mover: AnimationPlayer
@export var button_container: VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	button_container_setup()
	get_parent().hide()
	Global.can_be_pressed = true
	oracle_mover.play("move")
	oracle.play("rise")
	await oracle.animation_finished
	await get_tree().create_timer(1).timeout
	button_container_show()
	get_parent().queue_free()
	oracle.play("tweak")


func button_container_setup():
	button_container.show()
	for child in button_container.get_children():
		child.modulate = Color(1.0, 1.0, 1.0, 0.0)

func button_container_show(): 
	for child in button_container.get_children():
		child.create_tween().tween_property(child, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
