@tool
extends Object
class_name Logger
## Used to consistently print things to console with color and push warnings and errors.


## Prints to console the time and a message.
static func info( message : String ) -> void:
	print_rich( Time.get_datetime_string_from_system( false, true ) + " - " + get_location_prefix() + " - " +  message )


## Prints to console the time and a message.
static func warn( message : String ) -> void:
	print_rich( Time.get_datetime_string_from_system( false, true ) + " - " + get_location_prefix() + " - [color=YELLOW]" +  message +  "[/color]")


## Prints to console the time and a message.
static func error( message : String ) -> void:
	print_rich( Time.get_datetime_string_from_system( false, true ) + " - " + get_location_prefix() + " - [color=RED]" +  message +  "[/color]")


## Used to print standardized message on a beginning load.
static func loading_begin( loaded_item : String ) -> void:
	print_rich( Time.get_datetime_string_from_system( false, true ) + " - " + get_location_prefix() + " - [color=PURPLE]Began loading[/color] : " + loaded_item )


## Used to print standardized message on a successful load.
static func loading_success( loaded_item : String ) -> void:
	print_rich( Time.get_datetime_string_from_system( false, true ) + " - " + get_location_prefix() + " - [color=GREEN]Loaded[/color] : " + loaded_item )


## Used to print standardized message on a fail to load.
static func loading_failed( loaded_item : String ) -> void:
	print_rich( Time.get_datetime_string_from_system( false, true ) + " - " + get_location_prefix() + " - [color=RED]Failed load[/color] : " + loaded_item )


## Prints the system info.
static func system_info() -> void:
	info("Main : {name}, {os} {arch} {version}".format(
		{
			"name" : ProjectSettings.get_setting("application/config/name"),
			"os" : OS.get_distribution_name(),
			"arch" : Engine.get_architecture_name(),
			"version" : OS.get_version()
		} ) )

	info("Misc : Debug Build {debug}, Sandboxed {sandboxed}".format(
		{
			"debug" : OS.is_debug_build(),
			"sandboxed" : OS.is_sandboxed()
		} ) )

	info("CPU : {cpu}, Cores {cores}".format(
		{
			"cpu" : OS.get_processor_name(),
			"cores" : OS.get_processor_count()
		} ) )

	var ram_info : Dictionary = OS.get_memory_info()
	info("Memory : Physical {physical}, Free {free}, Available {available}, Stack {stack}".format( ram_info ) )


static func get_location_prefix( ) -> String:
	var call_layer : Dictionary = get_stack().back()
	var line : String = str(call_layer.get( "line", -1 ))
	var call_file_path : String = call_layer.get( "source", "" )
	var location : String = call_file_path.trim_prefix( "res://" )
	location = location.left(location.find("/"))

	match location:
		"addons":
			return "[color=orange]<" + call_file_path.get_file().get_basename() + ":" + line  + ">[/color]"
		"scripts":
			return "[color=red]{" + call_file_path.get_file().get_basename() + ":" + line  + "}[/color]"
		"scenes":
			return "[color=cyan]{" + call_file_path.get_file().get_basename() + ":" + line + "}[/color]"
		_:
			return "[color=green](" + call_file_path.get_file().get_basename() + ":" + line + ")[/color]"
