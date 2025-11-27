extends Node2D

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@export var speed := 400
@export var padding_limit := 20
var left_limit : float
var right_limit : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_limit = 0 + padding_limit
	right_limit = get_viewport_rect().size.x - (collision_shape.position.x * 2) - padding_limit


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pressed_left = Input.is_action_pressed("move_left")
	var pressed_right = Input.is_action_pressed("move_right")
	
	var direction := 0
	
	if(pressed_left && !pressed_right):
		direction = -1
	elif(!pressed_left && pressed_right):
		direction = 1
	
	position.x += direction * speed * delta
	position.x = clamp(position.x, left_limit, right_limit)
	
