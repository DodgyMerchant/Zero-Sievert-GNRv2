@tool
extends TabContainer
class_name Data_List

var gameData: Gun_Name_Data

@export var title: String = "":
	set(newName):
		title = newName
		if panel != null && newName != "":
			panel.name = newName

@export var DATA_FIELD: PackedScene

@onready var panel: PanelContainer = %Title
@onready var field_List: VBoxContainer = %DataList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = title

	if Engine.is_editor_hint():
		pass
	else:
		Globals.DV_MasterList_Updated.connect(_on_masterList_updated)
	
#region child managemant

func _create_field_from_data(gData: Gun_Name_Data, key: String):
	return _create_field(key, gData.dict[key] if gData.dict.has(key) else "");

func _create_field(key: String, text: String) -> Data_Field:
	var obj = DATA_FIELD.instantiate()
	field_List.add_child(obj)
	obj.setup(key, text)
	return obj

func _remove_field(field: LineEdit):
	field_List.remove_child(field)
	field.queue_free()

func _clear_all_fields():
	for field in field_List.get_children():
		_remove_field(field)

func _get_field(index: int) -> LineEdit:
	return get_child(index)

func _recycle_field(obj: LineEdit):
	obj.clear()

## find the index of the field with the corresponding key and 
func _get_index_by_key(key: String, list: Array[Node] = field_List.get_children()):
	for i in range(list.size()):
		if list[i].data_key == key:
			return i
	
	return -1

## sorts list by a master key list and adds missing fields, and removes fields not in the master list.
func _sort_fields(masterList: Array[String]):
	var children: Array[Node] = field_List.get_children()

	for child in children:
		field_List.remove_child(child)
	
	var index: int
	for key in masterList:
		index = _get_index_by_key(key, children)

		if index != -1:
			# if field exisnts
			field_List.add_child(children[index])
			children.remove_at(index)
		else:
			_create_field(key, "")
	
	if !children.is_empty():
		for child in children:
			child.queue_free()


#endregion
	
## populates list with entries
func _populate_list(gData: Gun_Name_Data, masterKeyList: Array[String]):
	for i in masterKeyList.size():
		_create_field_from_data(gData, masterKeyList[i])
		
## updating list entries
func _update_list(masterKeyList: Array[String]):
	if field_List.get_child_count() != masterKeyList.size():
		_sort_fields(masterKeyList)
		pass

## updating data
func _update_data(gData: Gun_Name_Data, masterKeyList: Array[String]):
	if field_List.get_child_count() == 0:
		_populate_list(gData, masterKeyList)
		return
	pass

func _on_masterList_updated(masterList):
	_update_list(masterList);
