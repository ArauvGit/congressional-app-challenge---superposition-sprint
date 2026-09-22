extends Area2D
var groups: Array = ["Health", "Speed", "Jump"]
@onready var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: CharacterBody2D) -> void:
	pass
	if self.get_groups():
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
			var x when x.is_in_group("Interference"):
				if body.has_method("interference_powerup"):
					if body.is_in_group("player"):
						body.interference_powerup()
						queue_free()
	else: 
		random()
func weighted_choice(biggest: int, middle: int, smallest: int):
	var random_num = randi_range(1, 100) 
	if random_num <= smallest: 
		return 2 
	elif random_num <= smallest + middle: 
		return 1 
	else: 
		return 0
func choose_sprite(): 
	match self.get_groups()[0]:
		"Speed": 
			sprite.texture = load("res://Assets/Sprites/powerups/robot jump beta.png") 
		"Health": 
			sprite.texture = load("res://Assets/Sprites/powerups/jump_powerup.png")
		"Jump": 
			sprite.texture = load("res://Assets/Sprites/powerups/jump_powerup.png")
		

		
func random():
	if Global.damaged == false: 
		self.add_to_group(groups[randi_range(1, 2)]) 
	elif Global.damaged == true: 
		self.add_to_group(groups[weighted_choice(70, 15, 15)])
		
