extends AnimatedSprite2D
var starting_position = Vector2(-80, 230)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void: 
	position.x += 3
	if position.x >= 700:  
		match animation: 
			var x when x == "red": 
				play("yellow")
			var x when x == "yellow": 
				play("red")
		position.x = starting_position.x
