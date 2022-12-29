extends Area2D
class_name Card2D

## How far above the board the card sits to show its order in the stack.
var rest_height := 0.0
var is_enabled := false
var pas
var exam

export var card_art: Texture
export var card_name: String
export var rules_text: String

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _texture_rect: TextureRect = $CardBorder/VBoxContainer/CardArt
onready var _name_label: Label = $CardBorder/VBoxContainer/TextPanel/VBoxContainer/Label
onready var _rules_box: RichTextLabel = $CardBorder/VBoxContainer/TextPanel/VBoxContainer/RichTextLabel


func _ready() -> void:
	_texture_rect.texture = card_art
	_name_label.text = card_name
	_rules_box.bbcode_text = rules_text
	connect("mouse_entered", self, "hover", [true])
	connect("mouse_exited", self, "hover", [false])

func hover(is_hovering: bool) -> void:
	if is_hovering:
		for card in get_tree().get_nodes_in_group("Hovering"):
			card.remove_from_group("Hovering")
			card.hover(false)
		add_to_group("Hovering")
		_animation_player.play("Swell")
	else:
		_animation_player.play_backwards("Swell")

func save_base_height() -> void:
	rest_height = position.y

func reset_height() -> void:
	position.y = rest_height

func set_vars(data: Dictionary) -> void:
	pass
