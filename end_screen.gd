extends Node2D

func _ready():
	$score_label.text += Globals.final_score


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
