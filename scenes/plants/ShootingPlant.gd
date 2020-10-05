extends Node2D

onready var animatedSprite = get_node("Shooter")

var projectile = preload("res://scenes/plants/Projectile.tscn")

func _on_Timer_timeout():
	get_node("AudioStreamPlayer2D").stream = load("res://sounds/pop.wav")
	get_node("AudioStreamPlayer2D").play()
	animatedSprite.frame = 0
	var projectileObject = projectile.instance()
	add_child(projectileObject)