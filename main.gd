extends Control

const EXEName = "ZERO Sievert.exe"

var Loader = preload("res://Loader.gd").new()
var _gameData: Dictionary = {}
var GameData: Dictionary:
	get:
		return _gameData
	set(data):
		_gameData = data
		Globals.GameData_Updated.emit(_gameData)

@onready var load_screen: VBoxContainer = %Load_Screen
@onready var data_screen: Control = %Data_Screen

func _ready() -> void:
	setup()

	manage_startup()

func setup():
	Globals.LoadRequest.connect(_on_loadRequest)
	Globals.GameData_Updated.connect(_on_gameData_updated)

#region startup
func manage_startup():
	# load user data

	# show relevant screen
	determine_screen()

## determines to show the data load or data screen.
func determine_screen():
	if (GameData.is_empty()):
		# no path
		_hide(data_screen)
		_show(load_screen)
	else:
		# loading user data path
		_hide(load_screen)
		_show(data_screen)

#endregion
#region Show/Hide

func _set_vidible(target: CanvasItem, boolean: bool):
	target.visible = boolean
func _hide(target: CanvasItem):
	_set_vidible(target, false)
func _show(target: CanvasItem):
	_set_vidible(target, true)

#endregion
#region saving loading

func _on_loadRequest(loadType: Globals.LOAD_TYPE, path: String):

	match loadType:
		Globals.LOAD_TYPE.GameDat_Json:
			
			#remove exe name
			path = path.erase(path.find(EXEName), EXEName.length())
			#add paths
			path = path.path_join(Globals.GAMEDAT_Path)

			# load data to json to dict
			GameData = gamedata_to_dict(JSON.parse_string(Loader._load_from_file(path)))

			prints("GameData", GameData)
		Globals.LOAD_TYPE.GNR_Text:
			pass

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

func _on_gameData_updated(gameData):
	determine_screen()

#endregion

## determines if all items from dict1 exist in dict2. Returns a list of keys missing from dict 2. 
func _dict_overlap(dict1: Dictionary, dict2: Dictionary) -> Array[String]:

	if dict2.has_all(dict1.keys()):
		return []
	
	var list: Array[String] = []

	for i in dict1.keys():
		if dict2.has(i):
			continue
		
		list.append(i)

	return list