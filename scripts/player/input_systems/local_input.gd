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


func get_movement() -> void:
	variables.want_jump = Input.is_action_pressed("move_jump")
	variables.want_duck = Input.is_action_pressed("move_duck")

	variables.sideward_movement += statistics.sideward_velocity * int(Input.get_action_strength("move_leftward") * 50)
	variables.sideward_movement -= statistics.sideward_velocity * int(Input.get_action_strength("move_rightward") * 50)

	variables.forward_movement += statistics.forward_velocity * int(Input.get_action_strength("move_forward") * 50)
	variables.forward_movement -= statistics.forward_velocity * int(Input.get_action_strength("move_backward") * 50)

	if Input.is_action_just_released("move_leftward") or Input.is_action_just_released("move_rightward"):
		variables.sideward_movement = 0
	else:
		variables.sideward_movement = clampf(variables.sideward_movement, -4096, 4096)

	if Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backward"):
		variables.forward_movement = 0
	else:
		variables.forward_movement = clampf(variables.forward_movement, -4096, 4096)

	if Input.is_action_just_released("move_forward") or Input.is_action_just_released("move_backward"):
		variables.verticle_movement = 0
	else:
		variables.verticle_movement = clampf(variables.verticle_movement, -4096, 4096)


func get_camera() -> void:
	pass
