extends Node2D

export var movespeed = 200

export var health = 0

func _process(delta):
	position.y -= delta * movespeed

func _on_Timer_timeout():
	queue_free()

func attack(damage):
	health -= damage
	if health < 0:
		queue_free()