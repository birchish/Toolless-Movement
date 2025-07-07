class_name PlayerStatistics
extends Resource
## A resource that defines the values for how the player can move.


@export_group("Velocity")
@export var forward_velocity			: float = 20.0		##
@export var sideward_velocity			: float = 20.0		##
@export var backward_velocity			: float = 10.0		##
@export var ground_friction				: float = 20.0		##
@export var stopping_velocity			: float = 50.0		## The speed the player stops moving.
@export var jump_velocity				: float = 20.0		## The velocity imparted on to the player when jumping.
@export var gravity_velocity			: float = 9.8		## Gravity.

@export_subgroup("Acceleration")
@export var acceleration_ground			: float = 5			## The acceleration of the player on ground.
@export var acceleration_air			: float = 1			## The acceleration of the player in air.

@export_subgroup("Caps")
@export var max_velocity				: float = 4096		## The max velocity the player can go.
@export var stood_max_velocity			: float = 16		## The max velocity the player can go while stood.
@export var ducked_max_velocity			: float = 8		## The max velocity the player can go while ducked.

@export_group("Misc")
@export var can_jump_while_crouched		: bool = true		## If the player is allowed to crouch while jumping.
@export var step_size					: float = 8			## The maximum size of a step the player can walk over without having to jump.
@export var max_slop_angle				: float = PI/4		## The maximum angle of slop the player can walk up.
