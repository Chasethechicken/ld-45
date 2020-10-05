extends AnimatedSprite

export var minimum = 0.5
export var maximum = 1.3

func _ready():
	frame = rand_range(0, frames.get_frame_count("default"))
	speed_scale = rand_range(minimum, maximum)