extends Node2D



func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body) -> void:
	if body.has_method("player"):
		$AnimatedSprite2D.play('portal')


func _on_area_2d_body_exited(body) -> void:
	if body.has_method("player"):
		$AnimatedSprite2D.stop()
