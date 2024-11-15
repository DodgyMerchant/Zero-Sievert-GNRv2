extends MarginContainer

@onready var Lists: HBoxContainer = %Lists
@onready var GameDataList: Data_List = %GameData

const DATA_LIST = preload("res://data screen/DataList.tscn")

var initialized: bool = false

## list of all loaded keys
var masterKeyList: Array[String]:
	set(data):
		masterKeyList = data
		Globals.DV_MasterList_Updated.emit(masterKeyList);

func _ready() -> void:
	_create_dataList()
	Globals.GameData_Updated.connect(_on_gameData_updated)

#region master key list

func _build_masterKeyList(loadedData: Array[Gun_Name_Data]) -> Array[String]:

	var list: Array[String] = []
	for data: Gun_Name_Data in loadedData:
		for key in data.dict.keys():
			if list.has(key):
				continue

			list.append(key)
	
	list.sort()
	return list

#endregion
#region data lists

func _create_dataList() -> Data_List:
	var obj = DATA_LIST.instantiate()
	Lists.add_child(obj)
	return obj

func _remove_dataList(list: Data_List):
	Lists.remove_child(list)
	list.queue_free()

#endregion

## if the game data is updated
func _on_gameData_updated(gameData: Gun_Name_Data):

	# get all dynamic loaded game data
	var loadedGunNameData: Array[Gun_Name_Data] = [gameData]
	for list: Data_List in Lists.get_children():
		if list.gameData != null:
			loadedGunNameData.append(list.gameData)
	
	# new data needs masterlist key rebuild
	var newMaster = _build_masterKeyList(loadedGunNameData)

	var masterUpdate: bool = false

	# check if master list is different
	if masterKeyList == null || masterKeyList.size() != newMaster.size():
		masterUpdate = true
	else:
		for i in newMaster.size():
			if newMaster[i] != masterKeyList[i]:
				masterUpdate = true
	
	if masterUpdate:
		masterKeyList = newMaster

	# update game data list
	GameDataList._set_data(gameData, masterKeyList)