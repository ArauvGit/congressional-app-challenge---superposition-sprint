extends RichTextLabel
signal input
var panel: NinePatchRect = get_parent()
var animation_finished: bool = false
var text_array: Array
var text_counter = 0
#an array seems better here, but because sometimes i'm using multiline questions and in general dealing with a big dialogue box, this makes it easier.
var break_1: int = 11
var break_2: int = 24
var tutorial_dialogue: Dictionary = {
	1:"Hello There!",
	2: "I'm oracle and I'm going to be giving you a brief background on Grover's algorithm before we begin.",
	3: "Essentially, Grover's algorithm handles problems by searching through all of the states at once through superposition and finding the correct one.",
	4: "They do that with, yours truly, the [u]Oracle[/u]!",
	5: "I'm like a checker, but I can't exactly find the correct answer. Essentially, I use a complex math function and apply that math equation to each state.",
	6: "If the function returns the wrong answer, I leave that state alone. But if the function the correct answer, I mark the state, deeming it valid.",
	7: "Then, the quantum computer uses the information I give it in order to manipulate the probabilities of each state being used as the final answer." ,
	8: "The main way that it does this is through interference, which is, in simple terms, the quantum computer decreasing the probability of the unmarked states while increasing the probability of the marked states.",
	9: "Eventually, it comes to a point where a state can reach 0%, in which it gets completely cancelled out and removed, or a state can reach (or be very close to) 100%. It is then measured and used as the final answer.", 
	10: "After I choose what state to mark, the race is a simplified demonstration of a quantum computer manipulating probabilities. You're also going to have a powerup that can cancel out, or remove states, from the race.", 
	11: "While this algorithm is much faster than a normal classical computer for various problems, it's not perfect. States often decohere, which is when they lose control and become much slower or stop working altogether.",
	12: "That's all. Do you want to review?",
	13: "Alright then, racer. Let's begin."
	
	}
var tutorial_counter: int = 1
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	tutorial()
func _physics_process(delta: float) -> void: 
	pass
			
				
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
	while text_counter != len(animated_words): 
		print(text_counter)
		animation_finished = false 
		text_counter += 1
		visible_characters += 1 
		await get_tree().create_timer(0.1).timeout
	if text_counter == len(animated_words): 
		animation_finished = true
