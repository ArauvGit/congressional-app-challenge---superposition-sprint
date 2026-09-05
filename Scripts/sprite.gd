extends AnimatedSprite2D
var is_dashing: bool = false

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
		Global.States.MOVING:
			if not is_dashing: 
				play("run")
		Global.States.JUMPING:
			if get_parent().is_in_group("Red"):
				print('jumping')
			match get_parent().velocity.y:
				var x when x > 0:
					play("fall_down")
				var x when x < 0:
					play("jump_up")
		Global.States.WALL_HANGING:
			play("wall_hang")
		Global.States.DASHING: 
			print("dashing")
			play("dash")
			is_dashing = true
			await animation_finished
			is_dashing = false
