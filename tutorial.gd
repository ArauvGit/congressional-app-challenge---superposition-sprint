extends RichTextLabel
signal input
@onready var pictures: Node2D = $"../../../pictures"
@onready var numbers: Node2D = $"../../../pictures/numbers"
@onready var quantum_sprites: Node2D = $"../../../pictures/quantum sprites"
var panel: NinePatchRect = get_parent()
var animation_finished: bool = false
var text_array: Array
var text_counter = 0
#an array seems better here, but because sometimes i'm using multiline questions and in general dealing with a big dialogue box, this makes it easier.
var break_1: int = 11
var break_2: int = 24
var tutorial_dialogue: Dictionary = {
	1:"Oh hey...didn't see you there.",
	2: "Watching the relay race?",
	3: "You might be wondering what this even is...",
	4: "What you're watching right now is a process similar to how a [u]classical computer[/u] processes data.",
	5: "Classical computers are most computers in the world - from PCs to the screen in your car.",
	6: "When a classical computer processes data, there is one extremely important factor: bits.",
	7: "A bit is a single unit of data that a computer uses for various tasks, like running math calculations.",
	8: "The special thing about bits - or in this example, the racers - are their states.",
	9: "Look at the relay race: notice how each racer carries either a red or yellow baton? That's because a bit has two states: 0 and 1.",
	10: "It's only ever these two numbers. The computer then reads it in sequence in order to process the data to do things like storing text or pixel data.",
	11: "Before I move on though, do you need any reexplanation?
	1: Yes    2: No",
	12: "These computers have taken us to the moon and beyond. We owe a lot of our successes to these classical computers.",
	13: "But recently, there has been a new kind of computer that takes everything we know about computers and turns it into something strange.",
	14: "It's called.....a quantum computer.",
	15: "You might have heard of Shrodinger's cat: a philosophical argument where a poisoned cat in a box is dead and alive at the same time.",
	16: "Similarly, in a quantum computer, qubits aren't just 0 or 1. They are in both at the same time, but they collapse into one or the other when the processing is over",
	17: "This state is known as superposition.",
	18: "One other notable quality of quantum computers is that depending on the number of qubits, there can be multiple states with numbers that aren't 0 and 1.",
	19: "In a classical computer, the number of bits is the same as the number of states - a linear relationship. But in a quantum computer, the amount of states is equal to 2 raised to x - an exponential relationship." ,
	20: "For example, while 2 bits in a classical computer is equal to 2 states (each either 0 or 1), 2 qubits in a quantum computer yields 4 states. In this case, the states would each be 00, 01, 10, and 11.",
	21: "Finally, superposition also relates to probability. Qubit states are represented by the square root of the chance of collapsing into 0 and 1. So for example, root 0.4 and root 0.6 could represent 40% 0 and 60% 1.",
	22: "The quantum computer manipulates these probabilities through a variety of methods - notably, algorithms - in order to find the marked - or correct - state.",
	23: "But before I move on, do you need any reexplanation?
	1: Yes    2: No",
	24: "In this game, you are going to learn about one of the most prominent quantum computer algorithms - Grover's algorithm.", 
	25: "But before I move on, do you need any reexplanation?
	1: Yes    2: No",
	}
var tutorial_counter: int = 1
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	await get_tree().create_timer(3).timeout
	tutorial()
func _physics_process(delta: float) -> void: 
	handle_pictures()

func handle_pictures(): 
	var line = tutorial_dialogue[tutorial_counter]
	match tutorial_counter:
		5: 
			if text_counter == line.find("P"):
				create_tween().tween_property(pictures.get_child(0), "modulate", Color(1, 1, 1, 1), 0.2)
				await get_tree().create_timer(float(len(text)) / 15).timeout
				create_tween().tween_property(pictures.get_child(0), "modulate", Color(1, 1, 1, 0), 0.2)
			if text_counter == line.find("screen"): 
				create_tween().tween_property(pictures.get_child(1), "modulate", Color(1, 1, 1, 1), 0.2)
				await get_tree().create_timer(float(len(text)) / 15).timeout
				create_tween().tween_property(pictures.get_child(1), "modulate", Color(1, 1, 1, 0), 0.2)
		14: 
			if text_counter == line.find("a "):
				create_tween().tween_property(pictures.get_child(2), "modulate", Color(1, 1, 1, 1), 0.4)
				create_tween().tween_property(quantum_sprites.get_child(0), "modulate", Color(1, 1, 1, 1), 0.4)
		15: 
			if text_counter == line.find("S"): 
				create_tween().tween_property(quantum_sprites.get_child(0), "position", Vector2(220, 217), 0.4)
				create_tween().tween_property(quantum_sprites.get_child(1), "modulate", Color(1, 1, 1, 1), 0.4)
				create_tween().tween_property(quantum_sprites.get_child(1), "position", Vector2(430, 217), 0.4)
		16: 
			match text_counter:
				var x when x == line.find("0"):
					create_tween().tween_property(numbers.get_child(0), "modulate", Color(1, 1, 1, 1), 0.4)
				var x when x == line.find("1"):
					create_tween().tween_property(numbers.get_child(1), "modulate", Color(1, 1, 1, 1), 0.4)
				var x when x == line.find("both"):
					create_tween().tween_property(numbers.get_child(0), "position", Vector2(245, 100), 0.2)
					create_tween().tween_property(numbers.get_child(1), "position", Vector2(245, 100), 0.2) 
				var x when x == line.find("collapse"): 
					create_tween().tween_property(numbers.get_child(0), "position", Vector2(115, 100), 0.1)
					create_tween().tween_property(numbers.get_child(1), "position", Vector2(375, 100), 0.1)
				var x when x == line.find("one"): 
					create_tween().tween_property(numbers.get_child(0), "scale", Vector2(1.2, 1.2), 0.1)
					create_tween().tween_property(numbers.get_child(0), "scale", Vector2(1, 1), 0.1)
				var x when x == line.find("other"): 
					create_tween().tween_property(numbers.get_child(1), "scale", Vector2(1.2, 1.2), 0.1)
					create_tween().tween_property(numbers.get_child(1), "scale", Vector2(1, 1), 0.1)
			
				
func tutorial():
	for i in range(tutorial_dialogue.keys().size()):
		await animate_text(tutorial_dialogue[tutorial_counter])
		if text.contains("reexplanation"):
			await input
			#tutorial_counter = tutorial_dialogue.find_key(text)
		else:
			await get_tree().create_timer(float(len(text)) / 15).timeout
			text_counter = 0
			tutorial_counter += 1
func _input(event: InputEvent) -> void:
	await condition(event)


func condition(event: InputEvent) -> void:
	if animation_finished:
		if event.is_action_pressed("1"):
			input.emit()
			if text == tutorial_dialogue[break_1]:
				tutorial_counter = 5
			elif text == tutorial_dialogue[break_2]:
				tutorial_counter = 18
			tutorial_counter = 15
		elif event.is_action_pressed("2"):
			input.emit()
			text_counter = 0

func animate_text(animated_words: String):
	text = animated_words 
	visible_characters = 0
	print(len(animated_words))
	handle_pictures()
	while text_counter != len(animated_words): 
		print(text_counter)
		animation_finished = false 
		text_counter += 1
		visible_characters += 1 
		await get_tree().create_timer(0.1).timeout
	if text_counter == len(animated_words): 
		animation_finished = true
