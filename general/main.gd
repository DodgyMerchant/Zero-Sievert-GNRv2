extends Control

var LoadedData: Array[Gun_Name_Data]

@onready var load_screen: Control = %Load_Screen
@onready var data_screen: Control = %Data_Screen

func _ready() -> void:
	setup()
	manage_startup()

func setup():
	Globals.GameData_Updated.connect(_on_gameData_updated)

#region startup
func manage_startup():
	# load user data

	# show relevant screen
	determine_screen(Globals.Loader.GameData)

## determines to show the data load or data screen.
func determine_screen(gameData):
	if (gameData == null):
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

func _on_gameData_updated(gameData):
	determine_screen(gameData)

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
