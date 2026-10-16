extends RichTextLabel
signal input

var panel: TextureButton = get_parent()
var animation_finished: bool = false
var text_array: Array
var text_counter = 0
#an array seems better here, but because sometimes i'm using multiline questions and in general dealing with a big dialogue box, this makes it easier.
var break_1: int = 11
var break_2: int = 24
var tutorial_dialogue: Dictionary = {
	1:"Oh hey...didn't see you there.",
	2: "Watching the race?",
	3: "You might be wondering what this even is...",
	4: "What you're watching right now is a classical computer processing data",
	5: "Classical computers are most computers in the world - from PCs to calculators to the screen in your car.",
	6: "When a classical computer processes data, there is one extremely important factor: bits.",
	7: "A bit is a single unit of data that a computer uses for various tasks, like running math calculations.",
	8: "The special thing about bits are their states.",
	9: "Look at the relay race: notice how each racer carries either a red or yellow baton? That's because a bit has two states: 0 and 1.",
	10: "It's only ever these two numbers. The computer then reads it in sequence in order to process the data to do things like storing text or pixel data.",
	11: "Before I move on though, do you need any reexplanation?
	1: Yes    2: No",
	12: "These computers have taken us to the moon and beyond. We owe a lot of our successes to these classical computers.",
	13: "But recently, there has been a new kind of computer that takes everything we know about computers and turns it into something strange.",
	14: "It's called.....a quantum computer.",
	15: "You might have heard of a field called quantum mechanics; Einstein was really into it back in the day.",
	16: "Quantum computing essentially uses quantum mechanics for its main principles. This goes deep into the kind of bits that quantum computers use: qubits.",
	17: "You might have heard of Shrodinger's cat: a philosophical argument where a poisoned cat in a box is dead and alive at the same time.",
	18: "Similarly, in a quantum computer, qubits aren't just 0 or 1. They are in a state both at the same time, but they collapse into one or the other when the processing is over",
	19: "This state is known as superposition.",
	20: "Superposition also relates to probability. Qubit states are represented by the chance of collapsing into 0 and 1. So for example, 0.4 and 0.6. The computer also takes the square root of these, and can even use the complex number system.",
	21: "Finally, in a classical computer, there are two possible states for every one bit. It's a linear relationship.",
	22: "But in a quantum computer, the amount of states grows exponentially; specifically, 2 raised to the number of qubits.",
	23: "For example, if there are 2 qubits, there are 4 possible states. Instead of 0 and 1, these states are 00, 01, 10, and 11.",
	24: "But before I move on, do you need any reexplanation?
	1: Yes    2: No",
	25: "Even though they seem remarkably different, quantum and classical computers both need algorithms - step-by-step instructions - to use their data to solve problems.",
	26: "One prominent example - and the one you're going to learn about - is called Grover's Algorithm.",
	}
var tutorial_counter: int = 1
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	tutorial()


	
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
	text = ""
	while text_counter != (len(animated_words)):
		animation_finished = false
		text += animated_words[text_counter]
		text_counter += 1
		await get_tree().create_timer(0.07).timeout
	if text_counter == len(animated_words):
		animation_finished = true


func _on_panel_pressed() -> void:
	text_counter = 0
	tutorial_counter += 1
