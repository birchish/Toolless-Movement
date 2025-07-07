class_name PositionResource
extends Resource

## The positions the player can be in.
enum Positions {
	STANDING,
	STOOD,
	DUCKING,
	DUCKED
}

@export var duck_time : float = 1.0:
	set(value):
		crouch_delta = absf((stood_position - duck_position) / value)
		duck_time = value

@export var stood_position : float = 1.0:
	set(value):
		crouch_delta = absf((value - duck_position) / duck_time)
		stood_position = value

@export var duck_position : float = 2.0:
	set(value):
		crouch_delta = absf((stood_position - value) / duck_time)
		duck_position = value


var crouch_delta : float = absf((stood_position - duck_position) / duck_time)

var position : Positions = Positions.STOOD ## The current position the player is in.


func get_crouch_delta() -> float:
	# HACK doing the engine tick division here just in case the tick rate is changed at runtime.
	return crouch_delta / Engine.physics_ticks_per_second
