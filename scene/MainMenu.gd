extends Node2D

@onready var transition = $CanvasLayer/transition
@onready var start = $CanvasLayer/start

# Called when the node enters the scene tree for the first time.
func _ready():
	start.play("title_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	transition.play("fade_out")
	


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://scene/world.tscn")
