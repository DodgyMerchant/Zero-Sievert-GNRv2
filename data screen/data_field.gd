extends Container
class_name Data_Field

var data_key: String:
	set(keyText):
		data_key = keyText
		line_edit.placeholder_text = keyText

@onready var line_edit: LineEdit = %LineEdit

func setup(key: String, text: String):
	data_key = key
	line_edit.text = text