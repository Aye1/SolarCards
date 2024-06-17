extends Node
class_name CardDeck

var count_label

var deck_name
var type
var cards = []
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	count_label = $CountLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	count_label.text = str(cards.size())
	
func load_from_json(path):
	var content = FileAccess.get_file_as_string(path)
	if content != null:
		var content_dict = JSON.parse_string(content)
		deck_name = content_dict["name"]
		type = content_dict["type"]
		var folder = _get_cards_folder()
		for card_path in content_dict["cards"]:
			_add_card("res://Cards/" + folder + "/" + card_path)
	
func _add_card(card):
	#if !cards.has(card):
		cards.append(card)
		
func _get_cards_folder():
	match(type):
		"actions":
			return "Actions"
		"location":
			return "LocationElements"
		_:
			return ""

func draw_card():
	if !cards.is_empty():
		var index = rng.randi_range(0, cards.size()-1)
		var next_card = cards.pop_at(index)
		return next_card
		
	

