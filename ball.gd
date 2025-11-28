extends Area2D

var velocity := Vector2(0.0, 400.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func _on_area_entered(area: Area2D) -> void:
	var root = area.get_parent()
	if root.name == "Paddle":
		velocity.y *= -1


func _on_body_entered(body: Node2D) -> void:
	velocity.y *= -1
