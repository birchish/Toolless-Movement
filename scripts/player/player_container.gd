class_name PlayerContainer
extends CharacterBody3D

@export var camera : Camera3D
@export var world_collision_upper : CollisionShape3D
@export var world_collision_lower : CollisionShape3D


@export_enum("local", "demo", "network") var input_type : int = 0						## 0 = local, 1 = demo, 2 = network.
@export var statistics : PlayerStatistics							## The stats used for movement.
@export var position_variables : PositionResource					##

var variables : PlayerVariables = PlayerVariables.new()	## The numbered for movement.
var input_controller : InputSystem									## The input script being used.

@onready var head_check : ShapeCast3D = get_node(^"WorldCollisionLowerBody/ShapeCast3D")
@onready var movement_state_machine : StateMachine = get_node(^"MovementStateMachine")
@onready var position_state_machine : StateMachine = get_node(^"PositionStateMachine")



func _enter_tree() -> void:
	pass
	#PlayerManager.player = self


func _ready() -> void:
	# Sets up which input the [PlayerContainer] will use.
	match input_type:
		0:
			input_controller = LocalInputSystem.new()
		1:
			input_controller = DemoInputSystem.new()
		2:
			input_controller = NetworkInputSystem.new()
		_:
			Logger.error("Input controller selection outside of range. Defaulting to local: " + str(input_type))
			input_controller = LocalInputSystem.new()

	add_child(input_controller)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	variables.speed = statistics.stood_max_velocity


func _physics_process(_delta: float) -> void:
	# Checks if the player inputs should be checked.
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		input_controller.get_movement()
		input_controller.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		input_controller.process_mode = Node.PROCESS_MODE_DISABLED

	variables.was_on_floor = variables.on_floor

	velocity = variables.velocity
	move_and_slide_own()
	variables.velocity = velocity

	if variables.on_floor:
		variables.can_jump = true
	else:
		variables.can_jump = false

	clamp_velocity()


## Perform a move-and-slide along the set velocity vector. If the body collides with another, it will slide along the other body rather than stop immediately. The method returns whether or not it collided with anything.
func move_and_slide_own() -> bool:
	var collided : bool = false

	# Reset previously detected floor
	variables.on_floor  = false


	# Check floor
	# TODO: What exactly is this doing?
	# NOTE: It seems to affect the air-strafing speed of the player.
	var check_motion : Vector3 = velocity / Engine.physics_ticks_per_second # velocity * (1/60.0) at 60 tickers per second.
	check_motion.y  -= statistics.gravity_velocity / (Engine.physics_ticks_per_second * 6) # statistics.gravity_velocity * (1/360.0) at 60 tickers per second.

	var test_collision : KinematicCollision3D = move_and_collide(check_motion, true)

	if test_collision:
		var test_normal : Vector3 = test_collision.get_normal()

		# Checks if the angle of the slop that the player is too steep to be considered on the floor.
		if test_normal.angle_to(up_direction) < statistics.max_slop_angle:
			variables.on_floor = true

	# Loop performing the move
	var motion : Vector3 = velocity / Engine.physics_ticks_per_second

	# TODO: What does this do?
	for step : int in max_slides:
		var collision : KinematicCollision3D = move_and_collide(motion)

		if not collision:
			# No collision, so move has finished
			break # TESTING: Why not continue instead?
			# NOTE: This makes the player much faster.

		# Calculate velocity to slide along the surface
		var normal : Vector3 = collision.get_normal()

		motion = collision.get_remainder().slide(normal)
		velocity = velocity.slide(normal)

		# Collision has occurred
		collided = true

	return collided


## Checks if velocity exceeds the the limit. If it is, then clamp it.
func clamp_velocity() -> void:
	if absf(variables.velocity.length()) > statistics.max_velocity:
		variables.velocity = variables.velocity.normalized() * statistics.max_velocity


func _exit_tree() -> void:
	PlayerManager.player = null
