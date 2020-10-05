extends Node2D

export var speed = 100
export var patrol_distance = 100

export var health = 0

var distance = 0
var forward = true

signal spawn(object, position)

var particle = preload("res://scenes/particles/Bug.tscn")

func _process(delta):
	if distance < patrol_distance and forward:
		translate(Vector2(0, -speed * delta).rotated(rotation))
		distance += speed * delta
	elif distance > 0:
		if forward:
			rotate(deg2rad(180))
		translate(Vector2(0, -speed * delta).rotated(rotation))
		distance -= speed * delta
		forward = false
	else:
		rotate(deg2rad(-180))
		forward = true

func attack(damage):
	health -= damage
	get_node("DamageTimer").start()
	modulate = Color(2, 0, 0)
	if health < 0:
		var particleObject = particle.instance()
		emit_signal("spawn", particleObject, position, rand_range(0, 360))
		queue_free()

func _on_DamageTimer_timeout():
	modulate = Color(1, 1, 1)