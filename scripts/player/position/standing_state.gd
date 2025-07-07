class_name StandingState
extends PositionState


@onready var stood_state : StoodState = get_node(^"../StoodState")
@onready var ducking_state : DuckingState = get_node(^"../DuckingState")


func _enter_state() -> void:
	if not player.is_node_ready():
		await  player.ready

	position_variables.position = position_variables.Positions.DUCKING
	variables.speed = statistics.ducked_max_velocity


func _physics_process(_delta: float) -> void:
	if variables.want_duck:
		get_state_machine().current_state = ducking_state
		return

	if player.is_on_ceiling() and variables.on_floor:
		return

	lower_collision.position.y = move_toward(lower_collision.position.y, position_variables.stood_position, position_variables.get_crouch_delta())

	if lower_collision.position.y <= position_variables.stood_position:
		get_state_machine().current_state = stood_state
