extends AnimatedSprite2D
var is_dashing: bool = false
var is_on_wall: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func animation_state():
	match Global.state:
		Global.States.IDLE:
			is_on_wall = false
			play("default")
		Global.States.MOVING:
			is_on_wall = false
			if not is_dashing:
				play("run")
		Global.States.JUMPING:
			is_on_wall = false
			if not is_dashing:
				match get_parent().velocity.y:
					var x when x < 0:
						play("jump_up")
					var x when x > 0:
						play("fall_down")
		Global.States.WALL_HANGING:
			is_on_wall = true
			if not is_dashing:
				play("wall_hang")
		Global.States.DASHING:
			if not is_on_wall:
				play("dash")
				is_dashing = true
				await animation_finished
				is_dashing = false
			else:
				Global.state = Global.States.WALL_HANGING
		Global.States.DAMAGING:
			play("malfunction")
