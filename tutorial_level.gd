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
	1: "Press Space, W or Up Arrow Key to jump.",
	2: "You can jump twice by clicking Space, W, or the Up Arrow Key in the air to clear bigger obstacles.",
	3: "Your qubit state just decohered - making it unstable and slightly lowering its stats. 
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
	text = animated_words 
	visible_characters = 0
	print(len(animated_words))
	while text_counter != len(animated_words): 
		print(text_counter)
		animation_finished = false 
		text_counter += 1
		visible_characters = text_counter
		await get_tree().create_timer(0.2).timeout
	if text_counter == len(animated_words): 
		animation_finished = true
		return


func cutscene_dialogue() -> void:
	tutorial()
