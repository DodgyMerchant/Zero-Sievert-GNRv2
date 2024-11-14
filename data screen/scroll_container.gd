extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	get_v_scroll_bar().scrolling.connect(_on_scroll)
	Globals.DV_listScroll_Updated.connect(_on_scroll_updated)

	pass # Replace with function body.

func _on_scroll():
	Globals.DV_listScroll_Updated.emit(self, scroll_vertical)

func _on_scroll_updated(origin: Control, value: int):
	if origin != self:
		scroll_vertical = value

