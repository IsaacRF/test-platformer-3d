extends CanvasLayer

@export var player : Player
@onready var _score_label = $Score
@onready var _hearts_container = $HeartsContainer
const HEART_UI = preload("res://UI/HeartUI.tscn")

func _ready():
	player.score_updated.connect(_on_score_updated)
	player.life_updated.connect(_on_life_updated)
	_on_max_life_updated(player.max_life)
	_on_life_updated(player.life)

func _on_score_updated(score: int):
	_score_label.text = str(score)
	
func _on_max_life_updated(life: int):
	for i in range(life):
		_hearts_container.add_child(HEART_UI.instantiate())
	
func _on_life_updated(life: float):
	var hearts = _hearts_container.get_children()
	var whole_hearts: int = int(life)
	var quarter_hearts: int = round((life - whole_hearts) * 4)
	
	for i in range(player.max_life):
		if i < whole_hearts:
			hearts[i].update(4)
		elif i == whole_hearts && quarter_hearts > 0:
			hearts[i].update(quarter_hearts)
		else:
			hearts[i].update(0)
