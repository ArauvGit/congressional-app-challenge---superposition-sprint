extends Label


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	animate_text("This is a test!")


func _process(delta: float) -> void:
	pass
	

func animate_text(animated_words: String): 
	var text_counter = 0
	for i in range(text.length()): 
		text[text_counter] = animated_words[text_counter] 
		await get_tree().create_timer(0.1)
