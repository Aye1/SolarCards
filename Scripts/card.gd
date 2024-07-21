extends Node2D
class_name Card

var title:String = "TMP_Investigate"
var desc:String = "TMP_Draw 2 cards"
var cost:int
var type:String
var name_label
var desc_label
var cost_label
var highlight_sprite
var draggable:DraggableComponent
var selectable:SelectableComponent
var effects = []

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
	_init_texts()
	_connect_signals()
	
func _init_texts():
	name_label.text = title
	desc_label.text = desc
	cost_label.text = str(cost)
	
func _connect_signals():
	pass
	
func _handle_hovered():
	if is_hovered():
		scale = scale_up_vector
	else:
		scale = base_scale
	
func load_json(path):
	var content = FileAccess.get_file_as_string(path)
	if content != null:
		var content_dict = JSON.parse_string(content)
		if content_dict != null:
			type = content_dict["type"]
			title = content_dict["title"]
			desc = content_dict["description"]
			cost = content_dict["cost"]
			for effect in content_dict["effects"]:
				effects.append(CardEffect.new(effect))
	_init_texts()
				
func is_hovered() -> bool:
	return draggable.is_current_hover

