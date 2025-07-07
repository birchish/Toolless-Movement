class_name DuckedState
extends PositionState


@onready var standing_state : StandingState = get_node(^"../StandingState")


func _enter_state() -> void:
	if not player:
		await player.ready

	position_variables.position = position_variables.Positions.DUCKED
	variables.speed = statistics.ducked_max_velocity

	lower_collision.position.y = position_variables.duck_position
	#camera.position.y = position_variables.camera_duck_position


func _physics_process(_delta: float) -> void:
	if not (variables.want_duck or player.head_check.is_colliding() or player.is_on_ceiling()):
		get_state_machine().current_state = standing_state
