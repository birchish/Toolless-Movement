class_name InputSystem
extends Node


const X_ROTATION_LIMIT : float = PI / 2

var y_rotation : float = 0.0
var x_rotation : float = 0.0

@onready var player		: PlayerContainer = get_node(^"..")
@onready var variables	: PlayerVariables = player.variables
@onready var statistics	: PlayerStatistics = player.statistics
@onready var camera		: Camera3D = player.camera

func _ready() -> void:
	name = &"InputSystem"
	process_mode = ProcessMode.PROCESS_MODE_INHERIT


func get_movement() -> void:
	pass


func get_camera() -> void:
	pass


## Updates the rotation of the camera.
func update_rotation() -> void:
	x_rotation = clampf(x_rotation, -X_ROTATION_LIMIT, X_ROTATION_LIMIT)

	var trans : Transform3D = camera.transform
	trans.basis = Basis.IDENTITY
	camera.transform = trans

	camera.rotate_object_local(Vector3.DOWN, y_rotation)
	camera.rotate_object_local(Vector3.LEFT, x_rotation)
