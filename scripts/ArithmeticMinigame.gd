extends Control

@onready var operation: Label = $Operation
@onready var answer: LineEdit = $Answer
@onready var submit_button: Button = $SubmitButton

var result: int

signal minigameFinished

func _ready() -> void:
	generate()
	submit_button.pressed.connect(verify)
	answer.grab_focus()

func generate():
	var a = randi() % 10 + 1
	var b = randi() % 10 + 1
	var operator = ["+", "-"].pick_random()
	match operator:
		"+":
			result = a + b
		"-":
			result = a - b
	operation.text = "The Answer to " + str(a) + " " + operator + " " + str(b)

func verify() -> void:
	var ans = answer.text.strip_edges()
	if !ans.is_valid_int():
		return
	if int(ans) == result:
		emit_signal("minigameFinished")
