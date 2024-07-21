extends Node
class_name CardDetailEditor

@export var card:Card


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _init_card():
	if !card:
		printerr("Card not found in CardDetailEditor")
		return
	card.draggable.can_be_dragged = false
	card.selectable.can_be_selected = false
	
func load_card(path:String) -> void:
	if !FileAccess.file_exists(path):
		printerr("File not found " + path)
		return
	card.load_json(path)
