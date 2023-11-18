extends Node2D

var boxes = []
var list_of_streets = []
var rand_num = 0
var current_street = ''
var street_2_box = []
var current_box = ''
var vis = false

func _ready():
	for box in $map.get_children():
		for street in box.get_children():
			for item in street.get_children():
				if "sprite" in item.name:
					item.visible = false
	boxes = Globals.boxes_used
	
	for box in boxes:
		for streets in get_node("map/" + str(box)).get_children():
			if streets.name not in list_of_streets:
				list_of_streets.append(streets.name)
				street_2_box.append(str(box))
	
	randomize_street()

func randomize_street():
	if len(list_of_streets) - 1 >= 0:
		rand_num = randi() % len(list_of_streets)-1
		current_street = list_of_streets[rand_num]
		current_box = street_2_box[rand_num]
		adjust_text(current_street)
		adjust_camera(current_box)
		adjust_highlight(current_street,current_box)
	else:
		#Globals.finish_round($CanvasLayer/score_label.text)
		get_tree().change_scene_to_file("res://menu.tscn")
		pass

func adjust_text(street):
	vis = false
	$CanvasLayer/street_label.visible = false
	street = street.replace('_',' ')
	$CanvasLayer/street_label.text = street

func adjust_camera(box):
	for camera in get_children():
		if camera.name == box + '_camera':
			get_node(box + '_camera').make_current()


func adjust_highlight(street,box):
	var highlight
	if vis == false:
		highlight = true
	else:
		highlight = false
	for boxes in $map.get_children():
			if boxes.name == box:
				for streets in get_node("map/" + box).get_children():
					if streets.name == street:
						get_node("map/" + box + "/" + street + "/" + street + "_sprite").visible = highlight
	
	



func _on_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

func _unhandled_input(event):
	if vis == false:
		if Input.is_action_just_pressed("space") or Input.is_action_just_pressed("space"):
			$CanvasLayer/street_label.visible = true
			vis = true
	else:
		if Input.is_action_just_pressed("space") or Input.is_action_just_pressed("space"):
			adjust_highlight(current_street,current_box)
			list_of_streets.erase(current_street)
			street_2_box.erase(current_box)
			randomize_street()
		
