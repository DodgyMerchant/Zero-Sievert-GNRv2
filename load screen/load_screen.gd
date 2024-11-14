extends PanelContainer

@onready var path_field: LineEdit = %Path_Field
@onready var file_dialog: FileDialog = %FileDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_load_button_pressed() -> void:
	
	if path_field.text == "":
		return
	
	# load game data from path
	Globals.Loader.load_gameData(path_field.text)


#region file dialog

func _on_select_button_pressed() -> void:
	file_dialog.file_selected.connect(_on_file_selected, CONNECT_ONE_SHOT)
	file_dialog.show()

func _on_file_selected(path: String):
	path_field.text = ProjectSettings.globalize_path(path.replace("\\", "/"))
	path_field.text_changed.emit()

#endregion