extends Control
@onready var runePics : Array
@onready var label = %Label
@onready var message = $CricketMessage
@onready var animation = $AnimationPlayer
@onready var end_screen = $EndScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_won.connect(_on_game_won)
	GameManager.game_lost.connect(_on_game_lost)
	GameManager.rune_collected.connect(_on_rune_collected)
	GameManager.runes_shuffled.connect(set_runes)
	#GameManager.rune_collected.connect(_on_spell_collected)
	#set_runes()

func get_label():
	return label

func set_runes():
	runePics = []
	var i = 0
	for N in $RunePics.get_children():
		N.visible = false
		N.texture = load("res://images/%s.png" % GameManager.runeSequence[i])
		runePics.append(N)
		i = i + 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_rune_collected(runeNum):
	runePics[runeNum].visible = true
	
func _on_game_won():
	#label.text = "You Win! You Beat Cricket! Be proud."
	#label.visible = true
	pass

func _on_game_lost():
	label.text = "You have been devoured by Cricket."
	label.visible = true

func tutorial_message(text):
	print("playing message")
	message.text = text
	animation.play("Fadein")

func show_cricket_message():
	message.show()

func hide_cricket_message():
	message.hide()
