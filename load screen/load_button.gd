extends Button

@onready var path_field: TextEdit = %Path_Field

func _on_path_field_text_changed() -> void:
	disabled = path_field.text == ""
