extends Node

@warning_ignore("unused_signal")
## updating loaded data
signal LoadedData_Change(LoadedData: Gun_Name_Data)

@warning_ignore("unused_signal")
## signals that the game data was updated.
signal GameData_Updated(gameData: Gun_Name_Data)

#region data view

@warning_ignore("unused_signal")
## signals that the master list in the data view was updated.
signal DV_MasterList_Updated(masterList: Array[String])

@warning_ignore("unused_signal")
signal DV_listScroll_Updated(origin: Control, value: int)


#endregion

var Loader = preload("res://general/Loader.gd").new()
