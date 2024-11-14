extends Resource
class_name Gun_Name_Data

@export var name: String
@export var dict: Dictionary


func _init(_name: String, _dict: Dictionary):

	name = _name
	dict = _dict

	pass


func save_to_file():
	pass
