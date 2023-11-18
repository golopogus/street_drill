extends Node2D

var boxes = []


func _on_button_41000_pressed():
	if 41000 in boxes:
		boxes.erase(41000)
	else:
		boxes.append(41000)


func _on_button_41008_pressed():
	if 41008 in boxes:
		boxes.erase(41008)
	else:
		boxes.append(41008)
		
func _on_button_41011_pressed():
	if 41011 in boxes:
		boxes.erase(41011)
	else:
		boxes.append(41011)
		
func _on_button_41012_pressed():
	if 41012 in boxes:
		boxes.erase(41012)
	else:
		boxes.append(41012)

func _on_button_41014_pressed():
	if 41014 in boxes:
		boxes.erase(41014)
	else:
		boxes.append(41014)

func _on_button_41041_pressed():
	if 41041 in boxes:
		boxes.erase(41041)
	else:
		boxes.append(41041)

func _on_button_41091_pressed():
	if 41091 in boxes:
		boxes.erase(41091)
	else:
		boxes.append(41091)

func _on_button_41092_pressed():
	if 41092 in boxes:
		boxes.erase(41092)
	else:
		boxes.append(41092)

func _on_button_41093_pressed():
	if 41093 in boxes:
		boxes.erase(41093)
	else:
		boxes.append(41093)

func _on_button_41094_pressed():
	if 41094 in boxes:
		boxes.erase(41094)
	else:
		boxes.append(41094)

func _on_button_41095_pressed():
	if 41095 in boxes:
		boxes.erase(41095)
	else:
		boxes.append(41095)
		
func _on_button_41096_pressed():
	if 41097 in boxes:
		boxes.erase(41096)
	else:
		boxes.append(41096)
			
func _on_button_41097_pressed():
	if 41097 in boxes:
		boxes.erase(41097)
	else:
		boxes.append(41097)

func _on_button_41098_pressed():
	if 41098 in boxes:
		boxes.erase(41098)
	else:
		boxes.append(41098)

func _on_button_41099_pressed():
	if 41099 in boxes:
		boxes.erase(41099)
	else:
		boxes.append(41099)


func _on_button_pressed():
	Globals.handle_start(boxes)
	get_tree().change_scene_to_file("res://find_it.tscn")


func _on_button_2_pressed():
	Globals.handle_start(boxes)
	get_tree().change_scene_to_file("res://street_drill.tscn")





















