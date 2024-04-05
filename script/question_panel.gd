extends Control


@onready var panel = $panel

func _ready():
	panel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("tap"):
		panel.show()
		$anim.play('open_panel')
		
