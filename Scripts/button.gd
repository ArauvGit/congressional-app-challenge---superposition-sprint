extends Button
@export var players: Node2D


var groups: Array = ["blue","green","red","yellow"]


# Called when the node enters the scene tree for the first time.
var button_names: Array = ["yellow", "green", "red", "blue"]
func _ready() -> void:
	pass # Replace with function body.
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _pressed() -> void: 
	if Global.is_pressed:
		return
	var group_array = get_groups()
	var group = group_array[0]
	var all_inside_group: = get_tree().get_nodes_in_group(group)
	for node in all_inside_group:
		if node is CharacterBody2D:
			node.add_to_group("player")
			_choose_type()
	Global.is_pressed = true
	get_parent().queue_free()
func _choose_type():
	for node in players.get_children():
		match node:
			var x when x is CharacterBody2D and not x.is_in_group("player"):
				node.add_to_group("enemy")
	choose_script()
				
func choose_script():
	for node in players.get_children():
		if node.is_in_group("player"):
			node.set_script(load("res://Scripts/player.gd"))
		elif node.is_in_group("enemy"):
			node.set_script(load("res://Scripts/enemy.gd"))
