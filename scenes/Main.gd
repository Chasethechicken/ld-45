extends Node2D

func _on_DeathDelay_timeout():
	get_tree().reload_current_scene()

func drop(item, position):
	get_node("Items").add_child(item)
	item.position = position

func spawn(object, position, rotation):
	get_node("Mobs").add_child(object)
	object.position = position
	object.rotation_degrees = rotation

func _on_Area2D_area_entered(area):
	get_node("UI-canvas/Outro/TextureButton").show()