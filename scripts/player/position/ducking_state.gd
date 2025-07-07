class_name DuckingState
extends PositionState


@onready var standing_state : StandingState = get_node(^"../StandingState")
@onready var ducked_state : DuckedState = get_node(^"../DuckedState")


func _enter_state() -> void:
	if not player.is_node_ready():
		await  player.ready

	position_variables.position = position_variables.Positions.DUCKING
	variables.speed = statistics.ducked_max_velocity


func _physics_process(_delta: float) -> void:
	if not variables.want_duck and not player.head_check.is_colliding():
		get_state_machine().current_state = standing_state
		return

	if player.is_on_ceiling():
		return

	var delta : float = position_variables.get_crouch_delta()

	lower_collision.position.y = move_toward(lower_collision.position.y, position_variables.duck_position, delta)

	# Prevents lifting off from the ground while ducking. Also gives the height boost from crouch jumping.
	if variables.on_floor:
		player.move_and_collide(Vector3(0, -delta, 0))
	else:
		# Halfed delta so the lift off from crouch jumping is more natural feeling.
		player.move_and_collide(Vector3(0, delta / 2, 0))

	if is_equal_approx(lower_collision.position.y, position_variables.duck_position):
		get_state_machine().current_state = ducked_state
