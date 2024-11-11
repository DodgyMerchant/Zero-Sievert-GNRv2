extends Control

const EXEName = "ZERO Sievert.exe"

var Loader = preload("res://Loader.gd").new()
var GameData: Dictionary = {}:
	set(data):
		GameData = data
		Globals.GameData_Updated.emit(GameData)

@onready var load_screen: VBoxContainer = %Load_Screen
@onready var data: Control = %Data_Screen

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
		_hide(data)
		_show(load_screen)
	else:
		# loading user data path
		_hide(load_screen)
		_show(data)

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
	
	prints('Path:"%s"' % path)
	var loadedData: Dictionary

	match loadType:
		Globals.LOAD_TYPE.GameDat_Json:
			
			#remove exe name
			path = path.erase(path.find(EXEName), EXEName.length())
			#add paths
			path = path.path_join(Globals.GAMEDAT_Path)

			# load data to json to dict
			loadedData = gamedata_to_dict(JSON.parse_string(Loader._load_from_file(path)))

			prints(loadedData, loadedData)
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

func _on_gameData_updated():
	determine_screen()