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

	var loadedData: Dictionary

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

## data processing
func gamedata_to_dict(rawData: Variant) -> Dictionary:
	
	rawData = rawData.data

	var data: Dictionary = {}

	for i in rawData.keys():
		data[i] = rawData[i].basic.name
	
	return data

func _on_gameData_updated(gameData):
	determine_screen()