extends CanvasLayer

var items = []

func _on_Player_collect(item):
	items.append(item)
	item.connect("used", self, "_on_item_used")
	add_child(item)
	item.position = Vector2(496 + (len(items) - 1) * 64, 16)

func _on_Player_damage(health):
	get_node("Health").texture_normal = load("res://artwork/Heart-hurt.png")
	get_node("HealthLabel").text = str(max(health, 0))
	get_node("DamageTimer").start()

func _on_Player_poisonDamage(health):
	get_node("Health").texture_normal = load("res://artwork/Heart-poisoned.png")
	get_node("HealthLabel").text = str(max(health, 0))
	get_node("DamageTimer").start()

func _on_Player_heal(health):
	get_node("Health").texture_normal = load("res://artwork/Heart-hover.png")
	get_node("HealthLabel").text = str(health)
	get_node("DamageTimer").start()

func _on_DamageTimer_timeout():
	get_node("Health").texture_normal = load("res://artwork/Heart.png")
	get_node("Strength").texture_normal = load("res://artwork/Sword.png")

func _on_item_used(item):
	var index = items.find(item)
	if not index == null:
		items.remove(index)
	for i in range(len(items)):
		print (i)
		items[i].position = Vector2(496 + (i) * 64, 16)

func _on_Player_strength(strength):
	get_node("Strength").texture_normal = load("res://artwork/Sword-hover.png")
	get_node("StrengthLabel").text = str(strength)
	get_node("AudioStreamPlayer").stream = load("res://sounds/sword.wav")
	get_node("AudioStreamPlayer").play()
	get_node("DamageTimer").start()


func _on_Health_mouse_entered():
	get_node("AudioStreamPlayer").stream = load("res://sounds/heart.wav")
	get_node("AudioStreamPlayer").play()


func _on_Strength_mouse_entered():
	get_node("AudioStreamPlayer").stream = load("res://sounds/sword.wav")
	get_node("AudioStreamPlayer").play()


func _on_TextureButton_pressed():
	get_node("Intro/TextureButton").hide()


func _on_TextureButton_Outro_pressed():
	get_node("Outro/TextureButton").hide()