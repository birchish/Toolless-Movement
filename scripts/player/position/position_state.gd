class_name PositionState
extends StateMachineState


@onready var player : PlayerContainer = get_node(^"../..")
@onready var statistics : PlayerStatistics = player.statistics
@onready var variables : PlayerVariables = player.variables
@onready var position_variables : PositionResource = player.position_variables

var camera : Camera3D
var upper_collision : CollisionShape3D
var lower_collision : CollisionShape3D


func _ready() -> void:
	camera = player.camera
	upper_collision = player.world_collision_upper
	lower_collision = player.world_collision_lower
