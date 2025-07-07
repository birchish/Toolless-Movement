class_name PlayerSpawnpoint
extends Marker3D


@onready var resource_player : Resource = preload(PlayerManager.PATH_TO_PLAYER_FILE)


func _init() -> void:
	# HACK not very efficient but it works.
	rotation.x = 0
	rotation.z = 0


func _ready() -> void:
	var player : PlayerContainer = resource_player.instantiate()
	PlayerManager.add_child(player)

	player.transform = transform
