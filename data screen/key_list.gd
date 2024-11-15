@tool
extends Data_List
## List spicifically made for displaying the master list keys.
## 
## fkdjsfkjhdkjfd
class_name Key_List

func _create_field(key: String, text: String) -> Data_Field:
	var obj: Data_Field = super(key, text)
	obj.line_edit.editable = false
	return obj