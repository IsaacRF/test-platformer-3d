extends Panel

@onready var sprite_2d = $Sprite2D

func update(heart_pieces: int = 4):
	if heart_pieces < 0: heart_pieces = 0
	if heart_pieces > 4: heart_pieces = 4
	
	#Set frame transforming heart count into correct frame number
	sprite_2d.frame = (heart_pieces - 4) * -1
