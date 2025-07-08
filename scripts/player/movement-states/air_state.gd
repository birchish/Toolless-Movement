class_name AirMovementState
extends MovementState


@onready var ground_state : GroundMovementState = get_node(^"../GroundMovementState")


func _enter_state() -> void:
	pass


func _physics_process(_delta: float) -> void:
	move()

	if variables.on_floor:
		get_state_machine().current_state = ground_state


func move() -> void:
	var forward : Vector3 = Vector3.FORWARD
	var sideward : Vector3 = Vector3.LEFT

	# Rotates for movement.
	forward = MathUntilites.normalize_vector(forward.rotated(Vector3.UP, player.camera.rotation.y))
	forward.y = 0

	sideward = MathUntilites.normalize_vector(sideward.rotated(Vector3.UP, player.camera.rotation.y))
	sideward.y = 0

	#forward = forward.rotated(Vector3.UP, player.camera.rotation.y).normalized()
	#sideward = sideward.rotated(Vector3.UP, player.camera.rotation.y).normalized()

	# Imparts gravity onto the player.
	variables.velocity.y -= statistics.gravity_velocity / Engine.physics_ticks_per_second

	var move_forward : float = variables.forward_movement
	var move_sideward : float = variables.sideward_movement

	# Determine the horizontal parts of movement.
	var wish_velocity : Vector3 = sideward * move_sideward + forward * move_forward

	# Zero out the verticle part of movement.
	wish_velocity.y = 0

	var wish_direction : Vector3 = wish_velocity
	var wish_speed : float = MathUntilites.normalize_vector_float(wish_direction)
	wish_direction = MathUntilites.normalize_vector(wish_direction)

	# Clamp to game defined max speed.
	if (wish_speed != 0.0) and (wish_speed > variables.speed):
		wish_velocity *= variables.speed / wish_speed
		wish_speed = variables.speed

	accelerate(wish_direction, wish_speed, statistics.acceleration_air)



func accelerate(wish_direction : Vector3, wish_speed : float, acceleration : float) -> void:
	# See how much the direction is changing.
	var current_speed : float = variables.velocity.dot(wish_direction)

	# Reduce wish_speed by the amount of veer from current_speed.

	var add_speed : float = wish_speed - current_speed

	if wish_speed > statistics.max_velocity:
		wish_speed = statistics.max_velocity

	# If add_speed is nothing return.
	if add_speed <= 0:
		return

	var acceleration_speed : float = acceleration * wish_speed / Engine.physics_ticks_per_second

	if acceleration_speed > add_speed:
		acceleration_speed = add_speed

	# Adjust velocity.
	variables.velocity += acceleration_speed * wish_direction.normalized()
