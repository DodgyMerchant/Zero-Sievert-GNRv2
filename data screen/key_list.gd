@tool
extends Data_List
## List spicifically made for displaying the master list keys.
## 
## fkdjsfkjhdkjfd
class_name Key_List

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		Globals.DV_MasterList_Updated.connect(_on_masterList_updated)

func _on_masterList_updated(masterList):
	super(masterList)
	pass