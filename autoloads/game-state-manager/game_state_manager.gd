extends Node


func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_lost_focus()
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_gain_focus()
		_:
			pass


## Handles unfocusing the application.
func _lost_focus() -> void:
	Engine.max_fps = 15
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _gain_focus() -> void:
	pass
