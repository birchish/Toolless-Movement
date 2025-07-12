class_name GameSettings
extends Object
## Interacts with the settings of the game.
##
##

var open : bool = false
var config : ConfigFile

## Opens
func open_file(path : String = "user://settings/setting.ini") -> Error:
	config = ConfigFile.new()

	var error : Error = config.load(path)
	if error == ERR_FILE_NOT_FOUND:
		create_file(path)
		error = config.load(path)

	if error != OK:
		return error

	return OK


## Saves an settings to the specified file.
func write_file(settings : Array[Array], path : String = "user://settings/setting.ini") -> Error:
	for item : Array in settings:
		config.set_value(item[0], item[1], item[2])

	var error : Error = config.save(path)
	if error != OK:
		return error

	return OK


func get_setting(section : String, key : String, default : Variant) -> Variant:
	if not config:
		Logger.error("Config never opened! A logic error is likely.")
		return null

	if not config.has_section(section):
		write_file([[section, key, default]])
		Logger.warn("Missing config section.")
		return default

	if not config.has_section_key(section, key):
		write_file([[section, key, default]])
		Logger.warn("Missing config key.")
		return default

	return config.get_value(section, key, default)


func create_file(path : String) -> Error:
	var cfg : ConfigFile = ConfigFile.new()
	cfg.set_value("game", "name", ProjectSettings.get_setting("application/config/name", "game"))
	var error : Error = cfg.save(path)
	return error
