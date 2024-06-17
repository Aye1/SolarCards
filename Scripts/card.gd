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
var effects = []
var is_selected = false

const scale_up_vector = Vector2(1.1,1.1)
const base_scale = Vector2.ONE
const card_width = 250 * 0.6 #TODO: find dynamic way to compute that
const card_height = 350 * 0.6

func _ready():
	name_label = $CardBackground/NameLabel
	desc_label = $CardBackground/DescRichTextLabel
	cost_label = $CardBackground/CostLabel
	highlight_sprite = $HighlightSprite
	_init_texts()
	$DragArea2D.selected.connect(_on_draggable_selected)
	
func _process(delta):
	highlight_sprite.set_visible(is_selected)
	
func _init_texts():
	name_label.text = title
	desc_label.text = desc
	cost_label.text = str(cost)

func _on_mouse_on():
	scale = scale_up_vector
	
func _on_mouse_off():
	scale = base_scale
	
func _on_draggable_selected():
	selected.emit()
	
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

