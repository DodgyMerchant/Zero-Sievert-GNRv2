extends Object

const UserPath = "user://%s"
const UserDataName = "user.data"
const EXEName = "ZERO Sievert.exe"
const GAMEDAT_Path = "ZS_vanilla/gamedata/weapon.json"

#region gamedata

func load_gameData(path: String) -> Gun_Name_Data:
	path = path.erase(path.find(EXEName), EXEName.length())
	#add paths
	path = path.path_join(Globals.Loader.GAMEDAT_Path)

	# load data to json to dict
	# and emit it

	var data = Globals.Loader._load_from_file(path)
	if data != "":
		data = JSON.parse_string(data)
		if data != null:
			return Gun_Name_Data.new("GameData", gamedata_to_dict(data))
	return null


#endregion
#region user data

func save_userData(content: String):
	_save_to_file(content, UserPath % "UserDataName")

func load_userData() -> String:
	return _load_from_file(UserPath % "UserDataName")
	
#endregion
#region general
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

#endregion
#region data processing

## given raw game data will return the gun name at index.
func gamedata_get_entry(rawData: Variant, key: String) -> String:
	return rawData.data[key].basic.name

## given raw game data will set the gun name at key index. returns if successful.
func gamedata_set_entry(rawData: Variant, key: String, newData: String) -> bool:

	if !rawData.data.has(key):
		return false
	
	rawData.data[key].basic.name = newData

	return true

## converts raw game data to a dictionary.
func gamedata_to_dict(rawData: Variant) -> Dictionary:

	var dict: Dictionary = {}

	for i in rawData.data.keys():
		dict[i] = gamedata_get_entry(rawData, i)
	
	return dict

## given raw game data and a dictionary containing gun data names and display names, will apply the display names to corresponding entries in the game data.
func dict_applyTo_gamedata(rawData: Variant, dict: Dictionary) -> Array[String]:

	## list of items that exist in the dictionary but not the game data.
	var notFoundList: Array[String] = []

	for i in dict.keys():
		if !gamedata_set_entry(rawData, i, dict[i]):
			notFoundList.append(i)
	
	return notFoundList

#endregion

func _ERROR(errorLocation: String):
	push_warning("%s error: %s" % [errorLocation, error_string(FileAccess.get_open_error())])
