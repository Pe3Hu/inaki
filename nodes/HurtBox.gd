class_name HurtBox, "HurtBox.svg"
extends Area2D


func _init() -> void:
	monitorable = false
	collision_mask = 2


func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")


func _on_area_entered(hitbox: HitBox) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
