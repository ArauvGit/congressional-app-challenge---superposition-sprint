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
	1: "Welcome to the tutorial! This is the oracle. It acts like a checker - it doesn't know the right answer, but it can check to see if a state is valid with a math equation. At the start of every race, you play as the oracle. But you don't use a fancy math equation - in this game, you find the state with the best stats and race as it! Try it now!"
	}
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	create_tween().tween_property(get_parent(), "modulate", Color(1, 1, 1, 1), 0.5)
	await get_tree().create_timer(0.5).timeout
	await animate_text(tutorial_dialogue[1])
	await get_tree().create_timer(2).timeout
	create_tween().tween_property(get_parent(), "modulate", Color(1, 1, 1, 0), 0.5)
	await get_tree().create_timer(0.5).timeout
	get_parent().get_parent().queue_free()

func animate_text(animated_words: String):
	text = animated_words 
	visible_characters = 0
	while text_counter != len(animated_words): 
		text_counter += 1
		visible_characters = text_counter
		await get_tree().create_timer(0.05 * Engine.time_scale).timeout
	if text_counter == len(animated_words): 
		animation_finished = true
	else: 
		animation_finished = false          
# Called when the node enters the scene tree for the first time.
