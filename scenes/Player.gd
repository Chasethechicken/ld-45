extends KinematicBody2D

var movespeed = 150
export var chargespeed = 250

var move_directions = []
var was_moving = false

export var health = 0
export var strength = 0

var weapons = []

signal collect(item)
signal poisonDamage(health)
signal damage(health)
signal heal(health)
signal strength(strength)
signal drop(item)
signal die()

var berry = preload("res://scenes/items/Berry.tscn")
var stick = preload("res://scenes/items/Stick.tscn")
var stick_ground = preload("res://scenes/items/Stick-ground.tscn")
var spear = preload("res://scenes/items/Spear.tscn")
var spear_ground = preload("res://scenes/items/Spear-ground.tscn")

var hurt_sounds = []
var step_sounds_left = []
var step_sounds_right = []

func _ready():
	for i in range(1, 5):
		hurt_sounds.append(load("res://sounds/hurt" + str(i) + ".wav"))
	for i in range(1, 4):
		step_sounds_left.append(load("res://sounds/step" + str(i) + ".wav"))
	for i in range(5, 8):
		step_sounds_right.append(load("res://sounds/step" + str(i) + ".wav"))

func _process(delta):
	var moving = false
	
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_just_pressed("ui_left"):
			move_directions.append(270)
		move_and_slide(Vector2(-chargespeed, 0))
		moving = true
	if Input.is_action_pressed("ui_right"):
		if Input.is_action_just_pressed("ui_right"):
			move_directions.append(90)
		move_and_slide(Vector2(chargespeed, 0))
		moving = true
	if Input.is_action_pressed("ui_up"):
		if Input.is_action_just_pressed("ui_up"):
			move_directions.append(0)
		move_and_slide(Vector2(0, -chargespeed))
		moving = true
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("ui_down"):
			move_directions.append(180)
		move_and_slide(Vector2(0, chargespeed))
		moving = true
	
	if Input.is_action_just_released("ui_left"):
		if move_directions.find(270) != -1:
			move_directions.remove(move_directions.find_last(270))
	if Input.is_action_just_released("ui_right"):
		if move_directions.find(90) != -1:
			move_directions.remove(move_directions.find_last(90))
	if Input.is_action_just_released("ui_up"):
		if move_directions.find(0) != -1:
			move_directions.remove(move_directions.find_last(0))
	if Input.is_action_just_released("ui_down"):
		if move_directions.find(180) != -1:
			move_directions.remove(move_directions.find_last(180))
	
	if moving:
		if not was_moving:
			was_moving = true
			get_node("CollisionShape2D/PlayerSprite/Arms").frame = 0
			get_node("CollisionShape2D/PlayerSprite/Arms").speed_scale = 4
			get_node("CollisionShape2D/PlayerSprite/FootLeft").frame = 0
			get_node("CollisionShape2D/PlayerSprite/FootRight").frame = 0
			get_node("CollisionShape2D/PlayerSprite/FootLeft").play()
			get_node("CollisionShape2D/PlayerSprite/FootRight").play()
	else:
		if was_moving:
			was_moving = false
			get_node("CollisionShape2D/PlayerSprite/Arms").speed_scale = 0.7
			get_node("CollisionShape2D/PlayerSprite/FootLeft").frame = 0
			get_node("CollisionShape2D/PlayerSprite/FootRight").frame = 0
			get_node("CollisionShape2D/PlayerSprite/FootLeft").stop()
			get_node("CollisionShape2D/PlayerSprite/FootRight").stop()
	
	if len(move_directions) != 0:
		get_node("CollisionShape2D").rotation = deg2rad(move_directions[-1])
	
	if Input.is_action_pressed("ui_attack"):
		if get_node("AttackTimer").is_stopped():
			for area in get_node("CollisionShape2D/AttackArea2D").get_overlapping_areas():
				if area.is_in_group("attackable"):
					area.get_parent().attack(strength)
					get_node("AttackTimer").start()
					break

func _on_Area2D_area_entered(area):
	if area.is_in_group("poisonous"):
		soundDamage()
		health -= 1
		emit_signal("poisonDamage", health)
		if health < 0:
			emit_signal("die")
	
	if area.is_in_group("prickling"):
		soundDamage()
		health -= 1
		emit_signal("damage", health)
		if health < 0:
			emit_signal("die")
	
	if area.is_in_group("healing"):
		if area.get_parent().harvest():
			var berryObject = berry.instance()
			berryObject.connect("used", self, "_on_Berry_eaten")
			emit_signal("collect", berryObject)
	
	if area.is_in_group("projectile"):
		soundDamage()
		health -= 1
		emit_signal("damage", health)
		if health < 0:
			emit_signal("die")
	
	if area.is_in_group("bug"):
		soundDamage()
		health -= 1
		emit_signal("damage", health)
		if health < 0:
			emit_signal("die")
	
	if area.is_in_group("bossplant"):
		soundDamage()
		health -= 1
		emit_signal("damage", health)
		if health < 0:
			emit_signal("die")
	
	if area.is_in_group("stick"):
		if get_node("PickupTimer").is_stopped():
			weapons.append(1)
			if strength < maxArr(weapons):
				strength = maxArr(weapons)
				emit_signal("strength", strength)
			var stickObject = stick.instance()
			stickObject.connect("used", self, "_on_Stick_dropped")
			emit_signal("collect", stickObject)
			area.get_parent().queue_free()
	
	if area.is_in_group("spear"):
		if get_node("PickupTimer").is_stopped():
			weapons.append(2)
			if strength < maxArr(weapons):
				strength = maxArr(weapons)
				emit_signal("strength", strength)
			var spearObject = spear.instance()
			spearObject.connect("used", self, "_on_Spear_dropped")
			emit_signal("collect", spearObject)
			area.get_parent().queue_free()

func _on_Berry_eaten(item):
	health += 1
	emit_signal("heal", health)

func _on_Stick_dropped(item):
	if weapons.find(1) != -1:
		weapons.remove(weapons.find(1))
	if strength > maxArr(weapons):
		strength = maxArr(weapons)
		emit_signal("strength", strength)
	var stick_groundObject = stick_ground.instance()
	emit_signal("drop", stick_groundObject, self.position)
	get_node("PickupTimer").start()

func _on_Spear_dropped(item):
	if weapons.find(2) != -1:
		weapons.remove(weapons.find(2))
	if strength > maxArr(weapons):
		strength = maxArr(weapons)
		emit_signal("strength", strength)
	var spear_groundObject = spear_ground.instance()
	emit_signal("drop", spear_groundObject, self.position)
	get_node("PickupTimer").start()

func minArr(arr):
	var minimum = arr[0]
	for i in arr:
		if i < minimum:
			minimum = i
	return minimum

func maxArr(arr):
	var maximum = 0
	for i in arr:
		if i > maximum:
			maximum = i
	return maximum

func soundDamage():
	print ("hurt")
	get_node("HurtPlayer").stream = hurt_sounds[rand_range(0, len(hurt_sounds))]
	get_node("HurtPlayer").play()

func _on_FootLeft_frame_changed():
	if get_node("CollisionShape2D/PlayerSprite/FootLeft").frame == 1:
		get_node("WalkPlayerLeft").stream = step_sounds_left[rand_range(0, len(step_sounds_left))]
		get_node("WalkPlayerLeft").play()


func _on_FootRight_frame_changed():
	if get_node("CollisionShape2D/PlayerSprite/FootLeft").frame == 2:
		get_node("WalkPlayerRight").stream = step_sounds_right[rand_range(0, len(step_sounds_right))]
		get_node("WalkPlayerRight").play()
