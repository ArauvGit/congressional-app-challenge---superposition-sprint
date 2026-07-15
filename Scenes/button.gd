extends Button
<<<<<<< HEAD

var groups: Array = ["blue", "green", "red", "yellow"]


# Called when the node enters the scene tree for the first time.
=======
var button_names: Array = ["yellow", "green", "red", "blue"]
>>>>>>> a5c849d0860896e1b15f3aadffaf10107aa0bbd7
func _ready() -> void:
	pass # Replace with function body.
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
<<<<<<< HEAD
	if self.get_groups()


	
=======
	button_press.emit()
	var group_array = get_groups()
	#code logic:
		#1. get the group that the button is in
		#2 get every other nodes in that group
		#3 get the node that is the player
		#4 run the command on that player 
	var group = group_array[0]
	var all_inside_group: = get_tree().get_nodes_in_group(group)
	for node in all_inside_group:
		if node is CharacterBody2D:
			node.set_script(load("res://Scenes/player.gd"))	
			
			
			
>>>>>>> a5c849d0860896e1b15f3aadffaf10107aa0bbd7
