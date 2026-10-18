extends RichTextLabel
signal input 
#@onready var cutscene_triggers: Node2D = $"../../../cutscene triggers"
#
#var panel: TextureButton = get_parent()
#var animation_finished: bool = false
#var text_array: Array
#var text_counter = 0
##an array seems better here, but because sometimes i'm using multiline questions and in general dealing with a big dialogue box, this makes it easier.
#var break_1: int = 11
#var break_2: int = 24
#var tutorial_dialogue: Dictionary = {
	#1: "Press Space, W or Up Arrow Key to jump."
	#}
#var tutorial_counter: int = 1
## Called when the node enters the scene tree for the first time.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _ready() -> void:
	##await get_tree().create_timer(3).timeout
	#tutorial_counter = 16
	#tutorial()
#
				#
#func tutorial():
	#for i in range(tutorial_dialogue.keys().size()):
		#await animate_text(tutorial_dialogue[tutorial_counter])
		#await input
		#text_counter = 0
		#tutorial_counter += 1
#func _input(event: InputEvent) -> void:
	#input.emit()
#
#func animate_text(animated_words: String):
	#text = animated_words 
	#visible_characters = 0
	#print(len(animated_words))
	#while text_counter != len(animated_words): 
		#print(text_counter)
		#animation_finished = false 
		#text_counter += 1
		#visible_characters += 1 
		#await get_tree().create_timer(0.1).timeout
	#if text_counter == len(animated_words): 
		#animation_finished = true
