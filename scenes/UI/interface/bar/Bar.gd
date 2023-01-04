extends HBoxContainer


func set_value(subtype_, value_) -> void:
	if not has_node('TextureProgress'):
		return
	
	match subtype_:
		"current":
			$TextureProgress.value = value_
			update_count_text()
		"min":
			$TextureProgress.min_value = value_
		"max":
			$TextureProgress.max_value = value_


func update_count_text() -> void:
	$Label.text = str($TextureProgress.value)# + '/' + str(maximum_value)


func set_icon(bar_) -> void:
	var path = "res://assets/bars/"
	var name_ = bar_.to_lower()+"_icon.png"
	$TextureRect.texture = load(path+name_)


func set_texture_progress(key_) -> void:
	var path = "res://assets/bars/"
	var name_ = key_+"_bg.png"
	$TextureProgress.texture_under = load(path+name_)
	name_ = key_+"_fill.png"
	$TextureProgress.texture_progress = load(path+name_)
	
