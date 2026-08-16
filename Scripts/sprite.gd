extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func animation_state():
	match Global.state:
		Global.States.IDLE:
			play('default')
		Global.States.MOVING_RIGHT:
			play("run")
		Global.States.MOVING_LEFT:
			play("run")
		Global.States.WALL_HANGING_RIGHT:
			play("wall_hang")
		Global.States.WALL_HANGING_LEFT:
			play("wall_hang")
