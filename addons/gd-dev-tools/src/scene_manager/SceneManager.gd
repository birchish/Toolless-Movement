extends CanvasLayer


### Emited when SceneManager changes CurrentScene.
signal SceneChanged(new_scene : String, old_scene : String)
### Emited when SceneManager starts to load a scene.
signal SceneChanging(new_scene : String, old_scene : String)
signal SceneFailLoad( element_path : String  )

## The path of the scene currently being loaded into.
var target_scene_path : String

## Progress of the scene being loaded.
var _progress : Array[float]

## Tells the code that things are fading.
var _fading : bool = false

## Temp timer created while elements are being loaded.
var _load_timer : Timer

@onready var animation : AnimationPlayer = get_node( "AnimationPlayer" )
@onready var progress_bar : ProgressBar = get_node( "Control/ProgressBar" )
@onready var scene_label : Label = get_node( "Control/SceneLabel" )


func _ready() -> void:
	hide()


## Changes the current scene to specificed path.
func change_to_scene( target : String, override_name : String = "", fade : bool = true ) -> Error:
	target_scene_path = target

	if override_name.is_empty():
		scene_label.text = target
	else:
		scene_label.text = override_name

	if not FileAccess.file_exists( target_scene_path ):
		Logger.error( error_string( ERR_FILE_NOT_FOUND ) )
		return ERR_FILE_NOT_FOUND

	var error_loading : Error = ResourceLoader.load_threaded_request( target_scene_path )
	if error_loading:
		Logger.error( error_string( error_loading ) )
		return error_loading

	if fade:
		_fading = true
		animation.play( &"FadeOut" )

	_add_timer()
	Logger.loading_begin( target )
	SceneChanging.emit( target, self.name )

	return OK


## Checks the status of the loading, if it is loaded then changes scene.
func _act_load_status() -> ResourceLoader.ThreadLoadStatus:

	var loading_status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status( target_scene_path, _progress )

	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = _progress[ 0 ]
			return ResourceLoader.THREAD_LOAD_IN_PROGRESS

		# Scene is loaded.
		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = 100.0
				# Fading Stuff
			if _fading:
				if not animation.is_playing():
					_fading = false
					animation.play( &"FadeIn" )
				else:
					return ResourceLoader.THREAD_LOAD_IN_PROGRESS

			_load_scene()
			target_scene_path = ""
			return ResourceLoader.THREAD_LOAD_LOADED

		# Scene failed to load.
		ResourceLoader.THREAD_LOAD_FAILED:
			Logger.error( error_string( ResourceLoader.THREAD_LOAD_FAILED ) )
			SceneFailLoad.emit( target_scene_path, get_tree().current_scene )
			return ResourceLoader.THREAD_LOAD_FAILED

	return ResourceLoader.THREAD_LOAD_INVALID_RESOURCE


## Loads the next scene.
func _load_scene() -> void:
	SceneChanged.emit( target_scene_path, get_tree().current_scene  )
	get_tree().change_scene_to_packed( ResourceLoader.load_threaded_get( target_scene_path ) )
	#TODO add error checking for this. You never know.
	Logger.loading_success( target_scene_path )
	Logger.info( "Changed Scene to: " + target_scene_path )



## Adds the timer if it should.
func _add_timer() -> void:
	if ( _load_timer ):
		return

	Logger.info( "Creating resource tick rate timer." )
	_load_timer = Timer.new()

	add_child( _load_timer )
	_load_timer.connect( "timeout", _on_timer_timeout )
	_load_timer.autostart = true
	_load_timer.start( 0.1 )


## Removes the timer if it should.
func _remove_timer() -> void:
	if ( not target_scene_path.is_empty() ):
		return

	Logger.info( "Removing resource tick rate timer." )
	_load_timer.queue_free()
	_load_timer = null


## Called when the timer times out.
func _on_timer_timeout() -> void:
	if ( not target_scene_path.is_empty() ):
		_act_load_status()

	_remove_timer()
