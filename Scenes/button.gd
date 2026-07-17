extends Button



var groups: Array = ["blue","green","red","yellow"]


# Called when the node enters the scene tree for the first time.
var button_names: Array = ["yellow", "green", "red", "blue"]
func _ready() -> void:
	pass # Replace with function body.
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void: 
	if Global.is_pressed:
		return
	Global.button_press.emit()
	_enemy_execution()
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
			node.add_to_group("player")
			print(node.get_groups())
	Global.is_pressed = true
func _enemy_execution():
	print("the function should hav")
	for node in get_tree().root.get_children():
		if node is CharacterBody2D and not node.is_in_group("player"):
			print("executed")
			node.add_to_group("enemy")
	
	
