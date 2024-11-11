extends Control

@onready var load_screen: VBoxContainer = %Load_Screen
@onready var data: Control = %Data

func _ready() -> void:
	setup()
	
	manage_startup()


func setup():
	Globals.LoadRequest.connect(_on_loadRequest)


#region startup
func manage_startup():
	
	# load user data
	
	# show relevant screen
	if (false):
		# loading user data path
		_hide(load_screen)
		_show(data)
	else:
		# no path
		_hide(data)
		_show(load_screen)

#endregion
#region Show/Hide

func _set_vidible(target: CanvasItem, boolean: bool):
	target.visible = boolean
func _hide(target: CanvasItem):
	_set_vidible(target, false)
func _show(target: CanvasItem):
	_set_vidible(target, true)

#endregion
#region loading

func _on_loadRequest(loadType: Globals.LOAD_TYPE, path: String):
	
	prints("Path: ", path)
	pass


#endregion
