extends Node2D
class_name Card

signal selected

var title:String = "TMP_Investigate"
var desc:String = "TMP_Draw 2 cards"
var cost:int
var type:String
var name_label
var desc_label
var cost_label
var highlight_sprite
var draggable
var effects = []
var is_selected = false
var is_dragged = false

const scale_up_vector = Vector2(1.1,1.1)
const base_scale = Vector2.ONE
const card_width = 250 * 0.6 #TODO: find dynamic way to compute that
const card_height = 350 * 0.6

func _ready():
	name_label = $CardBackground/NameLabel
	desc_label = $CardBackground/DescRichTextLabel
	cost_label = $CardBackground/CostLabel
	highlight_sprite = $HighlightSprite
	draggable = $DragArea2D
	_init_texts()
	_connect_signals()
	
func _process(delta):
	highlight_sprite.set_visible(is_selected)

	_handle_hovered()
	
func _init_texts():
	name_label.text = title
	desc_label.text = desc
	cost_label.text = str(cost)
	
func _connect_signals():
	draggable.selected.connect(_on_draggable_selected)
	draggable.drag_started.connect(_on_drag.bind(true))
	draggable.drag_stopped.connect(_on_drag.bind(false))

func _on_draggable_selected():
	selected.emit()
	
func _on_drag(dragged):
	is_dragged = dragged
	
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
				
func is_hovered() -> bool:
	return draggable.is_current_hover

