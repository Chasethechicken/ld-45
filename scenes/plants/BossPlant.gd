extends Node2D

export var health = 5

signal spawn(object, position, rotation)

var particle = preload("res://scenes/particles/BossPlant.tscn")

func attack(damage):
	health -= damage
	get_node("DamageTimer").start()
	modulate = Color(1.5, 0, 0)
	if health < 0:
		var particleObject = particle.instance()
		emit_signal("spawn", particleObject, position, rotation)
		queue_free()

func _on_DamageTimer_timeout():
	modulate = Color(1, 1, 1)