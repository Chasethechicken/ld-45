extends Node2D

export (Array, AudioStreamSample) var audio

signal used(item)

func _on_TextureButton_pressed():
	emit_signal("used", self)
	if len(audio) != 0:
		get_node("AudioStreamPlayer").stream = audio[rand_range(0, len(audio))]
		get_node("AudioStreamPlayer").play()
		hide()
	else:
		queue_free()

func _on_AudioStreamPlayer_finished():
	queue_free()