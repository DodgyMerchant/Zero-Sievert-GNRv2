extends VBoxContainer

@onready var path_field: TextEdit = %Path_Field

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_load_button_pressed() -> void:
	
	if path_field.text == "":
		return
	
	# load game data from path
	Globals.LoadRequest.emit(Globals.LOAD_TYPE.GameDat_Json, path_field.text)
