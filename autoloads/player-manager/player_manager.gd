extends Node


const PATH_TO_PLAYER_FILE : String = "uid://b6lojh83q1a42"

var player : PlayerContainer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed(&"pause"):
			if get_tree().paused:
				get_tree().paused = false
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				get_tree().paused = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event.is_action_pressed(&"quit"):
			get_tree().quit(0)
