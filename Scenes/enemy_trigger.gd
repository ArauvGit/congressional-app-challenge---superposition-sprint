extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"): 
		match self.get_groups()[0]:
			"Jump Trigger": 
				if body.has_method("enemy_jump"): 
					body.enemy_jump()
			"Dash Trigger": 
				if body.has_method("enemy_dash"):
					body.enemy_dash()
			"Change Direction Trigger": 
				if body.has_method("set_speed"): 
					body.set_speed(body.velocity.x * -1)
