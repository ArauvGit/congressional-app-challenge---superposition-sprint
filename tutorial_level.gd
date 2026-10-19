extends RichTextLabel
signal input 
@onready var cutscene_triggers: Node2D = $"../../../cutscene triggers"

var panel: NinePatchRect = get_parent()
var animation_finished: bool = false
var can_change: bool = true
var text_array: Array
var text_counter = 0
#an array seems better here, but because sometimes i'm using multiline questions and in general dealing with a big dialogue box, this makes it easier.
var break_1: int = 11
var break_2: int = 24
var tutorial_dialogue: Dictionary = {
	1: "Press Space, W or Up Arrow to jump.",
	2: "You can jump twice with Space, W or Up Arrow to clear bigger obstacles - try it now.",
	3: "Cracked blocks break after you walk on them for too long. So don't wander and keep moving",
	4: "Your qubit state just decohered - making it unstable and slightly lowering its stats. 
	Every time it decoheres, your state becomes redder. Orange signifies temporary invincibility. "
	}
var tutorial_counter: int = 1
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	pass

				
func tutorial():
	can_change = true
	await animate_text(tutorial_dialogue[tutorial_counter])
	if not text.contains("decohere"):
		await input 
	else: 
		await get_tree().create_timer(0.5 * Engine.time_scale).timeout
	text_counter = 0
	if can_change:
		tutorial_counter += 1
		can_change = false
func _input(event: InputEvent) -> void:
	if text.contains(event.as_text()): 
		input.emit()

func animate_text(animated_words: String):
	var time: float = 0.003
	if Engine.time_scale != 1: 
		time *= Engine.time_scale
	text = animated_words 
	visible_characters = 0
	while text_counter != len(animated_words): 
		text_counter += 1
		visible_characters = text_counter
		await get_tree().create_timer(0.05).timeout
	if text_counter == len(animated_words): 
		animation_finished = true
	else: 
		animation_finished = false
func cutscene_dialogue() -> void:
	tutorial()
