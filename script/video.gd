extends Node2D

@onready var transition = $CanvasLayer/transistion


# Called when the node enters the scene tree for the first time.
func _ready():
	transition.play("fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("tap"):
		get_tree().change_scene_to_file("res://scene/world.tscn")
		global.videoFinished = true
		print("clicked")


func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://scene/world.tscn")
	global.videoFinished = true
