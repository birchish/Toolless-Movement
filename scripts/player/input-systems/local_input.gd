class_name LocalInputSystem
extends InputSystem


@export_group("Input")
@export var mouse_sensitivity : float = 2.0
@export var gamepad_sensitivity : float = 10.0


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relative : Vector2 = (event as InputEventMouseMotion).relative
		y_rotation += relative.x * mouse_sensitivity / 1000
		x_rotation += relative.y * mouse_sensitivity / 1000

		update_rotation()


func _process(delta: float) -> void:
	var look_direction : Vector2 = Input.get_vector(&"camera_leftward", &"camera_rightward", &"camera_upward", &"camera_downward")

	if not look_direction:
		return

	y_rotation += look_direction.x * gamepad_sensitivity * delta
	x_rotation += look_direction.y * gamepad_sensitivity * delta

	update_rotation()


func get_movement() -> void:
	variables.want_jump = Input.is_action_pressed(&"move_jump")
	variables.want_duck = Input.is_action_pressed(&"move_duck")

	variables.sideward_movement += statistics.sideward_velocity * int(Input.get_action_strength(&"move_leftward") * statistics.target_speed)
	variables.sideward_movement -= statistics.sideward_velocity * int(Input.get_action_strength(&"move_rightward") * statistics.target_speed)

	variables.forward_movement += statistics.forward_velocity * int(Input.get_action_strength(&"move_forward") * statistics.target_speed)
	variables.forward_movement -= statistics.forward_velocity * int(Input.get_action_strength(&"move_backward") * statistics.target_speed)

	if Input.is_action_just_released(&"move_leftward") or Input.is_action_just_released(&"move_rightward"):
		variables.sideward_movement = 0
	else:
		variables.sideward_movement = clampf(variables.sideward_movement, -4096, 4096)

	if Input.is_action_just_released(&"move_forward") or Input.is_action_just_released(&"move_backward"):
		variables.forward_movement = 0
	else:
		variables.forward_movement = clampf(variables.forward_movement, -4096, 4096)

	if Input.is_action_just_released(&"move_forward") or Input.is_action_just_released(&"move_backward"):
		variables.verticle_movement = 0
	else:
		variables.verticle_movement = clampf(variables.verticle_movement, -4096, 4096)


func get_camera() -> void:
	pass
