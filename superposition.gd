extends TextureButton
@export var oracle: AnimatedSprite2D
@export var oracle_mover: AnimationPlayer
@export var button_container: VBoxContainer 
@export var healthbar: HBoxContainer
@export var players: Node2D
@export var background_transparent: ColorRect 
@export var camera: Camera2D
@export var countdown: Control
@export var superposition_container: Node2D
@export var root_node: Node2D
var can_increase: bool = true
var can_decrease: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RaceSong.play(0)
	RaceSong.stop()
	players.hide()
	healthbar.hide()
	if root_node.get_groups()[0] == "tutorial":
		for child in root_node.get_children(): 
			if child.name == "placement container": 
				child.hide()
	oracle.show()
	superposition_container.show()
	background_transparent.show()
	camera.position_smoothing_enabled = false


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
