extends Node
class_name CardDetailEditor

@export var card:Card
@export var name_text_edit:TextEdit
@export var cost_spin_box:SpinBox
@export var desc_text_edit:TextEdit
@export var path_text_edit:TextEdit
@export var effects_grid:GridContainer
@export var save_button:Button

var current_path
var is_dirty = false

func _ready():
	_connect_signals()
	
func _process(delta):
	if save_button:
		save_button.disabled = !is_dirty
	
func _init_card():
	if !card:
		printerr("Card not found in CardDetailEditor")
		return
	card.draggable.can_be_dragged = false
	card.selectable.can_be_selected = false
	
func _connect_signals():
	name_text_edit.text_changed.connect(_on_card_property_changed)
	cost_spin_box.value_changed.connect(_on_card_property_changed)
	desc_text_edit.text_changed.connect(_on_card_property_changed)
	save_button.pressed.connect(_save_card)
		
func _update_details():
	if !name_text_edit:
		printerr("TextEdit for 'name' not found in CardDetailEditor")
		return
	if !cost_spin_box:
		printerr("SpinBox for 'cost' not found in CardDetailEditor")
		return
	if !desc_text_edit:
		printerr("TextEdit for 'desc' not found in CardDetailEditor")
		return
		return
	if !path_text_edit:
		printerr("TextEdit for 'path' not found in CardDetailEditor")
		return
	if !card:
		print("Card not set in CardDetailEditor")
		return
		
	name_text_edit.text = card.title
	cost_spin_box.value = card.cost
	desc_text_edit.text = card.desc
	path_text_edit.text = current_path
	
func _udpate_effects_list() -> void:
	for child in effects_grid.get_children():
		child.queue_free()
	for effect in card.effects:
		pass
	
func load_card(path:String) -> void:
	if !FileAccess.file_exists(path):
		printerr("File not found " + path)
		return
	current_path = path
	card.load_json(path)
	_update_details()
	
func _on_card_property_changed():
	card.title = name_text_edit.text
	card.cost = cost_spin_box.value
	card.desc = desc_text_edit.text
	is_dirty = true
	
func _save_card():
	if is_dirty:
		card.save_json(current_path)
		is_dirty = false
