extends Control


@onready var panel = $panelLayer/panel
var finishPanel = false
var start =  false

func _ready():
	panel.hide()
	start = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start == true:
		panel.show()
		$anim.play('open_panel')
		start = false

func showChoices():
	pass
