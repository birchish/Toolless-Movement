@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton( &"SceneManager", &"res://addons/gd-dev-tools/src/scene_manager/SceneManager.tscn" )
	add_autoload_singleton( &"GUIManager", &"res://addons/gd-dev-tools/src/gui_manager/GUIManager.gd" )


func _exit_tree() -> void:
	remove_autoload_singleton( &"SceneManager" )
	remove_autoload_singleton( &"GUIManager" )
