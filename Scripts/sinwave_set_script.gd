extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func children(): 
	for child in self.get_children(): 
		if child.name == "cutscene picture": 
			for grandchild in child.get_children(): 
				if grandchild.name == "Line Container": 
					for great_grandchild in grandchild.get_children(): #this code is interesting
						great_grandchild.set_script(load("res://Scripts/sinwave.gd"))
