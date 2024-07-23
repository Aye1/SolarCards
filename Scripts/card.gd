extends Node2D
class_name Card

var card_model:CardResource : set = _set_card_model
var name_label
var desc_label
var cost_label
var highlight_sprite
var draggable:DraggableComponent
var selectable:SelectableComponent

const scale_up_vector = Vector2(1.1,1.1)
const base_scale = Vector2.ONE
const card_width = 250 * 0.6 #TODO: find dynamic way to compute that
const card_height = 350 * 0.6

func _ready():
	name_label = $CardBackground/NameLabel
	desc_label = $CardBackground/DescRichTextLabel
	cost_label = $CardBackground/CostLabel
	draggable = $DraggableComponent
	selectable = $SelectableComponent
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

