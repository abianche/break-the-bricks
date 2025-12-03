extends Node2D

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@export var speed := 400
@export var padding_limit := 20
var left_limit : float
var right_limit : float
var target_x: float
var prev_mouse_x: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	left_limit = 0 + sprite.get_rect().size.x / 2 + padding_limit
	right_limit = get_viewport_rect().size.x - sprite.get_rect().size.x / 2 - padding_limit

	target_x = position.x
	prev_mouse_x = get_global_mouse_position().x
	
	var tex: Texture2D = load("res://sprites/cursor.png")
	# hotspot = where the “click point” is inside the image
	var hotspot := Vector2(0, 0) 
	Input.set_custom_mouse_cursor(tex, Input.CURSOR_ARROW, hotspot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pressed_left = Input.is_action_pressed("move_left")
	var pressed_right = Input.is_action_pressed("move_right")

	# 1) KEYBOARD → adjust target_x
	var kb_dir := 0
	if pressed_left and not pressed_right:
		kb_dir = -1
	elif pressed_right and not pressed_left:
		kb_dir = 1

	if kb_dir != 0:
		target_x += kb_dir * speed * delta

	# 2) MOUSE → update target_x only when mouse actually moves
	var mouse_x := get_global_mouse_position().x
	var mouse_moved : float = abs(mouse_x - prev_mouse_x) > 2.0  # small threshold

	if mouse_moved and not (pressed_left or pressed_right):
		target_x = mouse_x

	prev_mouse_x = mouse_x

	# 3) Clamp target_x
	target_x = clamp(target_x, left_limit, right_limit)

	# 4) Move paddle toward target_x
	position.x = move_toward(position.x, target_x, speed * delta)
	
