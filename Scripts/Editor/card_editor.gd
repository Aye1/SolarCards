extends Node
class_name CardEditor

@export var path_text_edit:TextEdit
@export var file_tree:Tree
var path:String = "res://Cards"


# Called when the node enters the scene tree for the first time.
func _ready():
	_populate_item_list()
	
func _populate_item_list():
	if !file_tree:
		printerr("Tree not found in CardEditor")
		return
	file_tree.clear()
	var root = file_tree.create_item()
	root.set_text(0, path)
	_load(path, root)

func _load(folder:String, tree_item:TreeItem) -> void:
	if !file_tree:
		printerr("Tree not found in CardEditor")
		return
		
	var dir = DirAccess.open(folder)
	if dir != null:
		dir.list_dir_begin()
		var curr = dir.get_next()
		while curr != "":
			if dir.current_is_dir():
				var new_tree_item = _add_tree_item(curr, tree_item)	
				_load(folder + "/" + curr, new_tree_item)
			else:
				_add_tree_item(curr, tree_item)
			curr = dir.get_next()
		dir.list_dir_end()
	
func _add_tree_item(folder:String, current_tree_item:TreeItem) -> TreeItem:
	var new_item = current_tree_item.create_child()
	new_item.set_text(0, folder)
	return new_item
				

func _on_button_pressed():
	_populate_item_list()
