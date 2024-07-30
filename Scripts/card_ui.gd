### Does not work as is, do not use
### Plan was to transform Cards to UI elements
### To have simple layout management
### But drag and drop doesn't work with UI currently

extends Control
class_name CardUI

var card_model:CardResource : set = _set_card_model
@export var name_label:Label
@export var desc_label:RichTextLabel
@export var cost_label:Label
@export var highlight_sprite:TextureRect
@export var draggable:DraggableComponent
@export var drop_component:DropComponent
@export var selectable:SelectableComponent

const scale_up_vector = Vector2(1.1,1.1)
const base_scale = Vector2.ONE
const card_width = 250 * 0.6 #TODO: find dynamic way to compute that
const card_height = 350 * 0.6

func _ready():
	_update_ui()
	
func _update_ui():
	if is_node_ready() and card_model:
		name_label.text = card_model.title
		desc_label.text = card_model.desc
		cost_label.text = str(card_model.cost)
	
func _handle_hovered():
	if is_hovered():
		scale = scale_up_vector
	else:
		scale = base_scale
	
func is_hovered() -> bool:
	return draggable.is_current_hover
	
func _set_card_model(new_value):
	card_model = new_value
	_update_ui()

