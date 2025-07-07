class_name GroundMovementState
extends MovementState


@onready var air_state : AirMovementState = get_node(^"../AirMovementState")


func _enter_state() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if variables.on_floor:
		move()
	else:
		get_state_machine().current_state = air_state

	if not variables.can_jump or not variables.want_jump:
		return

	if not statistics.can_jump_while_crouched and variables.position == variables.Positions.DUCKED:
		return

	perform_jump()



func move() -> void:
	var forward : Vector3 = Vector3.FORWARD
	var sideward : Vector3 = Vector3.LEFT

	# Rotates for movement.
	forward = forward.rotated(Vector3.UP, player.camera.rotation.y).normalized()
	sideward = sideward.rotated(Vector3.UP, player.camera.rotation.y).normalized()

	# Imparts gravity onto the player.
	variables.velocity.y -= statistics.gravity_velocity / Engine.physics_ticks_per_second

	var move_forward : float = variables.forward_movement
	var move_sideward : float = variables.sideward_movement

	# Determine the horizontal parts of movement.
	var wish_velocity : Vector3 = sideward * move_sideward + forward * move_forward

	# Zero out the verticle part of movement.
	wish_velocity.y = 0

	friction()

	var wish_direction : Vector3 = wish_velocity.normalized()
	var wish_speed : float = wish_direction.length()

	# Clamp to game defined max speed.
	if wish_speed != 0.0 and (wish_speed > variables.speed):
		wish_velocity *= variables.speed / wish_speed
		wish_speed = variables.speed

	# HACK kind of a strange way to do this.
	variables.velocity.y = 0
	accelerate(wish_direction, wish_speed, statistics.acceleration_ground)
	variables.velocity.y = 0


func friction() -> void:
	# Get current speed.
	var speed : float = variables.velocity.length()

	# If too slow, return.
	if speed <= 0: # TODO why not less <=?
		return

	# TODO comment what this does. This should be move further down to where the value is actually set.
	var drop_amount : float = 0

	# Applys ground friction.
	var friction_value : float = statistics.ground_friction

	# Remove some speed, but if we have kess than the bleed threshold, bleed the threshold amount.
	var control : float = statistics.stopping_velocity if speed < statistics.stopping_velocity else speed

	drop_amount += control * friction_value / Engine.physics_ticks_per_second

	var new_speed : float = speed - drop_amount
	if new_speed < 0:
		new_speed = 0

	if new_speed != speed:
		# Normalize new_speed so the multiplication does not increase the speed too much.
		new_speed /= speed
		variables.velocity *= new_speed


func accelerate(wish_direction : Vector3, wish_speed : float, acceleration : float) -> void:
	# See how much the direction is changing.
	var current_speed : float = variables.velocity.dot(wish_direction)

	# Reduce wish_speed by the amount of veer from current_speed.
	var add_speed : float = wish_speed - current_speed

	# If no speed is going to be added return.
	if add_speed <= 0:
		return

	var acceleration_speed : float = acceleration * wish_speed / Engine.physics_ticks_per_second

	if acceleration_speed > add_speed:
		acceleration_speed = add_speed

	# TODO why is this the way it is? range(3)? Magic numbers!
	for index : int in range(3): # TODO Desse - Make it 2... make it 4...
		# Adjust velocity.
		variables.velocity += acceleration_speed * wish_direction


func perform_jump() -> void:
	if not (variables.can_jump) or variables.velocity.y > 15:
		return

	var floor_ground_factor : float = 1.0
	var floor_multiplier : float


	# Trying to emulate that crouch jumping is slightly higher than jump crouching but not completely accurate. The reasion why you jump higher mid crouch is because the game forgets to apply gravity for the first frame. This attempts to recreate it by removing one frame of gravity to make up for it.
	if player.position_variables.position == player.position_variables.Positions.DUCKING:
		floor_multiplier = sqrt(2 * statistics.gravity_velocity * statistics.jump_velocity) + (statistics.gravity_velocity / Engine.physics_ticks_per_second)

		if	player.position_variables.position != player.position_variables.Positions.DUCKED:
			player.move_and_collide(Vector3(0, 2 - player.world_collision_upper.position.y - player.world_collision_lower.position.y, 0))

	else:
		floor_multiplier = sqrt(2 * statistics.gravity_velocity * statistics.jump_velocity)


	var jump_velocity : float = floor_ground_factor * floor_multiplier + max(0, variables.velocity.y)

	variables.velocity.y = max(jump_velocity, jump_velocity + variables.velocity.y)

	variables.on_floor = false
	get_state_machine().current_state = air_state
