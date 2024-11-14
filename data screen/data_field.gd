extends Container
class_name Data_Field

var data_key: String:
	set(keyText):
		data_key = keyText
		line_edit.placeholder_text = keyText

@onready var line_edit: LineEdit = %LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_text(text):
	line_edit.text = text