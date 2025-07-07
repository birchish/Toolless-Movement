extends Node
## Manages GUI in games.


signal ElementLoaded( element : CanvasLayer, element_path : String )
signal ElementRemoved( element_name : String )
signal ElementBeginLoad( element_name : String, element_path : String  )
signal ElementFailLoad( element_name : String, element_path : String  )
signal CurrentElementChanged( element : CanvasLayer )

## The current element being focused on. Change it through set_current_element()
var current_element : CanvasLayer

## The paths of the current elements being loaded.
var _loading_paths : Array[String]

## Temp timer created while elements are being loaded.
var _load_timer : Timer


## Addes a new element to GUIManager.
func add_element( path : String ) -> void:
	# Prevents the requested element from being loaded more than once at a tine.
	if ( _loading_paths.find( path ) != -1 ):
		Logger.info("HUD element already loading : " + path )
		return

	_loading_paths.append( path )

	var error_loading : Error = ResourceLoader.load_threaded_request( path )
	if error_loading:
		Logger.warn( error_string( error_loading ) )
		return

	_add_timer()
	Logger.loading_begin( path )
	ElementBeginLoad.emit( name )


## Gets an interface.
func get_element( element_name : String ) -> CanvasLayer:
	return ( find_child( element_name, false ) as CanvasLayer )


## Removes an element from the GUIManagers children.
func remove_element( title : String ) -> void:
	var element : CanvasLayer = ( find_child( title ) as CanvasLayer )
	if ( element is CanvasLayer ):
		ElementRemoved.emit( element.name )
		Logger.info( "Removing HUD element : " + element.name )
		element.queue_free()


## Sets the current visable HUD element.
func set_current_element( element : CanvasLayer ) -> bool:
	if ( not element ):
		return false

	# Disables interfaces.
	for child : Node in get_children():
		if ( child is CanvasLayer):
			child.hide()
			element.process_mode = PROCESS_MODE_DISABLED

	# Enables the current interface.
	element.process_mode = PROCESS_MODE_ALWAYS
	element.show()
	current_element = element
	Logger.info( "Changed the current visible element : " + element.name )
	CurrentElementChanged.emit( element )
	return true


## Checks if item should be acted and does if it should.
func _act_item_load( item_path : String ) -> void:
	match ( ResourceLoader.load_threaded_get_status( item_path ) ):
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_loading_paths.erase( item_path )
			Logger.loading_failed( item_path )
			ElementFailLoad.emit( item_path )
			return

		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			return

		ResourceLoader.THREAD_LOAD_FAILED:
			_loading_paths.erase( item_path )
			Logger.loading_failed( item_path )
			ElementFailLoad.emit( item_path )
			return

		ResourceLoader.THREAD_LOAD_LOADED:
			_load_element(item_path)
			return


## Called to finish loading an item.
func _load_element( item_path : String ) -> void:
	var new_element : CanvasLayer = ResourceLoader.load_threaded_get( item_path ).instantiate()
	add_child( new_element )

	new_element.hide()
	new_element.process_mode = PROCESS_MODE_DISABLED

	# Removes the old path that is no longer needed.
	_loading_paths.erase( item_path )

	# Announces the loading.
	Logger.loading_success( item_path )
	ElementLoaded.emit( new_element, item_path )


## Adds the timer if it should.
func _add_timer() -> void:
	if ( not _load_timer ):
		Logger.info( "Creating resource tick rate timer." )
		_load_timer = Timer.new()

		add_child( _load_timer )
		_load_timer.connect( "timeout", _on_timer_timeout )
		_load_timer.autostart = true
		_load_timer.start( 0.1 )


## Removes the timer if it should.
func _remove_timer() -> void:
	if _loading_paths.is_empty():
		Logger.info( "Removing resource tick rate timer." )
		_load_timer.queue_free()
		_load_timer = null


## Called when the timer times out.
func _on_timer_timeout() -> void:
	for item_path : String in _loading_paths:
		_act_item_load( item_path )

	_remove_timer()
