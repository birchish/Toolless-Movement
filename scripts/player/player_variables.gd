class_name PlayerVariables
extends Object


var velocity					: Vector3 = Vector3.ZERO	## The velocity of the player.
var speed						: float = 4096

var can_jump					: bool = false				## If the player is allowed to jump.
var want_jump					: bool = false				## The player wants to jump.

var can_duck					: bool = false
var want_duck					: bool = false				## The player wants to duck.

var on_floor					: bool = false				## If the player is on the floor.
var was_on_floor				: bool = false				## If the player was on floor.

var forward_movement			: float = 0.0				## The forward and backward input value used to calculate the velocity.
var sideward_movement 			: float = 0.0				## The sideward input value used to calculate the velocity.
var verticle_movement			: float = 0.0				## The vecticle input value used to calculate the velocity.
