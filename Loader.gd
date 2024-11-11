extends Object

const UserPath = "user://%s"
const UserDataName = "user.data"

#region user data

func save_userData(content: String):
	_save_to_file(content, UserPath % "UserDataName")


func load_userData() -> String:
	return _load_from_file(UserPath % "UserDataName")
	
#endregion

func _save_to_file(content: String, path: String) -> bool:
	var file = FileAccess.open(path, FileAccess.WRITE)

	if file == null: # error
		_ERROR("Load from file")
		return false

	file.store_string(content)

	file.close()
	return true

func _load_from_file(path: String) -> String:
	var file = FileAccess.open(path, FileAccess.READ)

	if file == null: # error
		_ERROR("Load from file")
		return ""

	var content = file.get_as_text()

	file.close()
	return content

func _ERROR(errorLocation: String):
	push_warning("%s error: %s" % [errorLocation, error_string(FileAccess.get_open_error())])