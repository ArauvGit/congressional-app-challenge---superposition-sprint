extends Line2D 
class_name Sinwave
@export var line_container: Node2D
@export var bg: ColorRect
var wave_speed_multiplier: int = 3
var y: float = 0
var x: float = 0
var line_tween_time: float = 1.2
var wave_count: int = 3

func _ready() -> void:
	self.hide()

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func set_y(new_value: float):
	if y != new_value:
		y = new_value
	return y
func create_lines(): 
	if Global.interference_wave_activated:
		while x != 641:
			self.add_point(Vector2(x, y))
			x += 1
			set_y(15 * sin(0.15 * x)) 
			if x >= 641:
				animate_lines()


func animate_lines(): 
	create_tween().set_trans(Tween.TRANS_EXPO).tween_property(self, "position", Vector2(position.x, 180), line_tween_time * Engine.time_scale) 
	await get_tree().create_timer((line_tween_time - 0.4) * Engine.time_scale).timeout
	bg.color = Color(1.0, 1.0, 1.0, 1.0) 
	self.hide()
	create_tween().tween_property(bg, "color", Color(0, 0, 0, 0), 4 * Engine.time_scale)
