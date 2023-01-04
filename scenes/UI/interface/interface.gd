extends Control


signal health_updated(value)
signal rupees_updated(count)
onready var bars: VBoxContainer = $HBoxContainer/Bars
onready var icon: TextureRect = $HBoxContainer/Dancer
var dancer: KinematicBody2D


func _ready() -> void:
	if dancer != null:
		set_bars()
		set_icon()
		


func set_bars() -> void:
	for bar in Global.arr.bar:
		var node = bars.get_node(bar)
		
		for subtype in Global.arr.subtype:
			var value = dancer[bar.to_lower()+"_"+subtype]
			node.set_value(subtype, value)
			node.set_icon(bar)
		
		var key = bar.to_lower()
		
		if bar == "Consumable":
			key = "mana"
			key = "mana"
		
		node.set_texture_progress(key)


func set_icon() -> void:
	var path = "res://assets/dancers/"
	var name_ = dancer.team+"_icon.png"
	var a = path+name_
	icon.texture = load(path+name_)
	icon.modulate = dancer.color


func _on_Health_health_changed(health_) -> void:
	emit_signal("health_updated", health_)


func _on_Purse_rupees_changed(count_) -> void:
	emit_signal("rupees_updated", count_)
