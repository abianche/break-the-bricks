extends Area2D

var velocity := Vector2(0.0, 600.0)
var start_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	
	
func reset_ball():
	global_position = start_position
	velocity = Vector2(0.0, 600.0)
	

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()

	if parent.name == "Paddle":
		# Flip vertical velocity
		velocity.y *= -1

		# 1. Get the horizontal offset of the ball from the paddle center
		var offset = (global_position.x - parent.global_position.x)

		# 2. Normalize it to [-1, 1]
		# Assuming your paddle sprite is centered and width is paddle_width
		var half_width = parent.get_node("Sprite2D").get_rect().size.x / 2.0
		var normalized = clamp(offset / half_width, -1.0, 1.0)

		# 3. Apply to X velocity (adjust strength)
		var bounce_strength = 200.0
		velocity.x = normalized * bounce_strength
		
	elif area.is_in_group("bricks"):
		var hit_from_above := velocity.y > 0
		var half_brick_h = 8.0 / 2.0
		var ball_r = 8.0
		var epsilon := 0.1
		
		velocity.y *= -1
		if velocity.y < 0: 
			# after flip: moving up → we must have hit from above
			global_position.y = area.global_position.y - half_brick_h - ball_r - epsilon
		else:
			# after flip: moving down → we must have hit from below
			global_position.y = area.global_position.y + half_brick_h + ball_r + epsilon
		area.queue_free()


func _on_body_entered(body: Node2D) -> void:
	match body.name:
		"LeftWall":
			velocity.x = abs(velocity.x)
		"RightWall":
			velocity.x = -abs(velocity.x)
		"TopWall":
			velocity.y = abs(velocity.y)


func _on_killzone_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		reset_ball()
