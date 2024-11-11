extends Node

@warning_ignore("unused_signal")
## Loading stuff
signal LoadRequest(loadType: LOAD_TYPE, path: String)

@warning_ignore("unused_signal")
## signals that the game data was updated.
signal GameData_Updated(gameData: Dictionary)

## types of loadable files
enum LOAD_TYPE {
	## expect a path to the games exe
	GameDat_Json,
	GNR_Text}
const GAMEDAT_Path = "ZS_vanilla/gamedata/weapon.json"
