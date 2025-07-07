class_name StoodState
extends PositionState


@onready var ducking_state : DuckingState = get_node(^"../DuckingState")


func _enter_state() -> void:
	if not player:
		await player.ready

	position_variables.position = position_variables.Positions.STOOD
	variables.speed = statistics.stood_max_velocity
	lower_collision.position.y = position_variables.stood_position
	#camera.position.y = position_variables.camera_stood_position


# Called every physics frame when this state is active.
func _physics_process(_delta: float) -> void:
	if variables.want_duck:
		get_state_machine().current_state = ducking_state
