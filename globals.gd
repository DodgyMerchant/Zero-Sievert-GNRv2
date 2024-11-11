extends Node

## types of loadable files
enum LOAD_TYPE {GameDat_Json, GNR_Text}

## Loading stuff
@warning_ignore("unused_signal")
signal LoadRequest(loadType: LOAD_TYPE, path: String)
