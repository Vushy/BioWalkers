extends Node2D


var finishPanel = false
var start =  false

func _ready():
	start = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start == true:
		$anim.play('start')
		start = false
