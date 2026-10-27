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
	2: "You can jump twice to clear bigger obstacles",
	3: "Cracked blocks break shortly after being touched. [jump to continue]",
	4: "Your qubit state just decohered - making it unstable and slightly lowering its stats.
	Every time it decoheres, your state becomes redder. Orange signifies temporary invincibility. [jump to continue]",
	5: "You found a powerup! This is a health powerup to heal, but there is also a speed buff and a jump buff. [jump to continue]",
	6: "When you're near two walls, you can wall hang and jump. Your character automatically hangs onto walls, and you can jump to scale them.",
	7: "For long obstacles or a quick shortcut, click shift to dash. You can dash both in the air and on the ground.",
	8: "You just found a moving platform - simply jump on them and your character stops in place. You can jump to exit when needed.",
	9: "This is the interference powerup. Interference is what a quantum computer uses to manipulate probabilities and get the correct answer.
	As you race, the computer is already doing interference. However, it can also practically eliminate or promote probabilities when necessary  
	Contestants are going to be simulated. Get a feel for the powerup and then dash to move on.",
	10: "Touch the winning area to beat the level, then move on to the big races!"
	
	}
var tutorial_counter: int = 1
# Called when the node enters the scene tree for the first time.


func tutorial():
	can_change = true
	await animate_text(tutorial_dialogue[tutorial_counter])
	await input 
	text_counter = 0
	if can_change:
		tutorial_counter += 1
		can_change = false

func _input(event: InputEvent) -> void:
	var is_in_text = func(element): return text.contains(element)
	if InputMap.get_actions().any(is_in_text):
		var action = InputMap.get_actions().filter(is_in_text)[0]
		if InputMap.action_has_event(action, event):
			input.emit()

func animate_text(animated_words: String):
	text = animated_words 
	visible_characters = 0
	while text_counter != len(animated_words): 
		text_counter += 1
		visible_characters = text_counter
		await get_tree().create_timer(0.07 * Engine.time_scale).timeout
	if text_counter == len(animated_words): 
		animation_finished = true
	else: 
		animation_finished = false          
func cutscene_dialogue() -> void:
	tutorial()


func _on_superposition_pressed() -> void:
	input.emit()
