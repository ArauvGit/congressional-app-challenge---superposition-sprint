extends Area2D
var groups: Array = ["Speed", "Health", "Jump"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: CharacterBody2D) -> void:
	pass
	match self:
		var x when x.is_in_group("Speed"):
			if body.has_method("speed_powerup"):
				body.speed_powerup()
				queue_free()
		var x when x.is_in_group("Health"):
			if body.has_method("health_powerup"):
				body.health_powerup()
				queue_free()
		var x when x.is_in_group("Jump"):
			if body.has_method("jump_powerup"):
				body.jump_powerup()
				queue_free()
	
	
