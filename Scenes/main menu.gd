extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_pressed()

func get_pressed():
	for child in self.get_children():
		if child is Button:
			if child.name == "Start Game":
				if child.pressed: 
					self.hide()
