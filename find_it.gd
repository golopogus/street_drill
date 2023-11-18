extends Node2D

var camera_move = false
var mouse_loc = Vector2()
var mouse_check = Vector2()
var highlighted_street = ''
var boxes = []
var list_of_streets = []
var current_street = ''
var selected_street = ''
var rand_num
var score = 0
var add_score = 0
var move = false
var current_mouse_loc = Vector2()

#func _on_button_pressed():
	#for streets in get_node("map/41008").get_children():
	#	list_of_streets.append(streets.name)
	#randomize_street()
	#move = true
	#$CanvasLayer/Button.queue_free()
	
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
	
	randomize_street()
	move = true
	#$CanvasLayer/Button.queue_free()
			
		
func randomize_street():
	if len(list_of_streets) - 1 >= 0:
		rand_num = randi() % len(list_of_streets)-1
		current_street = list_of_streets[rand_num]
		adjust_text(current_street)
	else:
		Globals.finish_round($CanvasLayer/score_label.text)
		get_tree().change_scene_to_file("res://end_screen.tscn")
	
func adjust_text(street):
	street = street.replace('_',' ')
	$CanvasLayer/street_label.text = street
	$Timer.start()
	#dd_score = 1000
	
#func _process(delta):
	#pass


	
		
##############MAP MOVEMENT#############

func _unhandled_input(event):
	if move == true:
		###ZOOM###
		##Trackpad##
		if event is InputEventMagnifyGesture:
			$map_camera.zoom = $map_camera.zoom * event.factor
			
		##Mouse##
		var zoom_max = 3.5
		var zoom_min = .8
		if Input.is_action_just_pressed("scroll_u"):
			if $map_camera.zoom.x < 3.5:
				$map_camera.zoom *= 1.05

		if Input.is_action_just_pressed("scroll_d"):
			if $map_camera.zoom.x > .8:
				$map_camera.zoom *= .95
		
		
		###PAN###
		
		
		if Input.is_action_just_pressed("mouse_click"):
			
			mouse_loc = get_global_mouse_position() - $map.position
			mouse_check = $map_camera.position
			
		if Input.is_action_pressed("mouse_click"):
			
			camera_move = true
		else:
			camera_move = false
			
		if camera_move == true:
			var new_pos = -get_global_mouse_position() + $map_camera.position + mouse_loc
			if new_pos.x > -2768/2 + 1024/2 and new_pos.x < 2768/2 - 1024/2: 
				$map_camera.position.x = new_pos.x
			if new_pos.y > -1638/2 + 300 and new_pos.y < 1638/2 - 300:
				$map_camera.position.y = new_pos.y
		
		###SELECT STREET###
		if Input.is_action_just_released("mouse_click"):
			if mouse_check == $map_camera.position and highlighted_street != '':
				selected_street += highlighted_street
				check_answer(selected_street)
			

func check_answer(street):
	
	if street != current_street:
		add_score = -500
	if street == current_street:
		add_score = 1000*($Timer.time_left/$Timer.wait_time)
		if add_score < 100:
			add_score = 100
		#list_of_streets.erase(current_street)
		#randomize_street()
	
	if add_score < 0:
		add_score = str(int(add_score))
	else:
		add_score = '+' + str(int(add_score))
	$Sprite2D2/added.text = add_score
	$Sprite2D2.visible = true
	$Sprite2D2.position = get_global_mouse_position() + Vector2(40,0)
	$AnimationPlayer.play("score")
	$CanvasLayer/score_label.text = str(round(float($CanvasLayer/score_label.text) + float(add_score)))
	add_score = 0
	selected_street = ''
	if street == current_street:
		list_of_streets.erase(current_street)
		randomize_street()
func highlight_street(street_name,box,vis):
#	for boxes in $map.get_children():
#		if boxes.name == box:
#			for streets in get_node("map/" + box).get_children():
#				if streets.name == street_name:
#					get_node("map/" + box + "/" + street_name + "/" + street_name + "_sprite").visible = vis
	if vis == true:
		highlighted_street += street_name
		for boxes in $map.get_children():
			if boxes.name == box:
				for streets in get_node("map/" + box).get_children():
					if streets.name == street_name:
						get_node("map/" + box + "/" + street_name + "/" + street_name + "_sprite").visible = true
		
	else: 
		highlighted_street = ''
		for boxes in $map.get_children():
			if boxes.name == box:
				for streets in get_node("map/" + box).get_children():
					if streets.name == street_name:
						get_node("map/" + box + "/" + street_name + "/" + street_name + "_sprite").visible = false
		



func _on_exit_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	

	
#########STREETS##########

###Carey Park Lane###
func _on_carey_park_lane_area_mouse_entered():
	highlight_street('carey_park_lane','41000',true)
func _on_carey_park_lane_area_mouse_exited():
	highlight_street('carey_park_lane','41000',false)

###Madison Watch Way###
func _on_madison_watch_way_area_mouse_entered():
	highlight_street('madison_watch_way','41000',true)
func _on_madison_watch_way_area_mouse_exited():
	highlight_street('madison_watch_way','41000',false)

###Signal Knob Court###
func _on_signal_knob_court_area_mouse_entered():
	highlight_street('signal_knob_court','41000',true)
func _on_signal_knob_court_area_mouse_exited():
	highlight_street('signal_knob_court','41000',false)
	
###Powell Lane###
func _on_powell_lane_area_mouse_entered():
	highlight_street('powell_lane','41000',true)
func _on_powell_lane_area_mouse_exited():
	highlight_street('powell_lane','41000',false)
	
###Pinetree Terrace###
func _on_pinetree_terrace_area_mouse_entered():
	highlight_street('pinetree_terrace','41000',true)
func _on_pinetree_terrace_area_mouse_exited():
	highlight_street('pinetree_terrace','41000',false)
	
###Madison View Lane###
func _on_madison_view_lane_area_mouse_entered():
	highlight_street('madison_view_lane','41000',true)
func _on_madison_view_lane_area_mouse_exited():
	highlight_street('madison_view_lane','41000',false)
	
##Nevius Street###
func _on_nevius_street_area_mouse_entered():
	highlight_street('nevius_street','41000',true)
func _on_nevius_street_area_mouse_exited():
	highlight_street('nevius_street','41000',false)

###Marshall Drive###
func _on_marshall_drive_area_mouse_entered():
	highlight_street('marshall_drive','41000',true)
func _on_marshall_drive_area_mouse_exited():
	highlight_street('marshall_drive','41000',false)

###Steppes Court###
func _on_steppes_court_area_mouse_entered():
	highlight_street('steppes_court','41000',true)
func _on_steppes_court_area_mouse_exited():
	highlight_street('steppes_court','41000',false)

###Madison Point Court###
func _on_madison_point_court_area_mouse_entered():
	highlight_street('madison_point_court','41000',true)
func _on_madison_point_court_area_mouse_exited():
	highlight_street('madison_point_court','41000',false)

###Madison Park Drive###
func _on_madison_park_drive_area_mouse_entered():
	highlight_street('madison_park_drive','41000',true)
func _on_madison_park_drive_area_mouse_exited():
	highlight_street('madison_park_drive','41000',false)

###Madison Overlook Court###
func _on_madison_overlook_court_area_mouse_entered():
	highlight_street('madison_overlook_court','41000',true)
func _on_madison_overlook_court_area_mouse_exited():
	highlight_street('madison_overlook_court','41000',false)

###Madison Lane###
func _on_madison_lane_area_mouse_entered():
	highlight_street('madison_lane','41000',true)
func _on_madison_lane_area_mouse_exited():
	highlight_street('madison_lane','41000',false)

###Madison Crest Court###
func _on_madison_crest_court_area_mouse_entered():
	highlight_street('madison_crest_court','41000',true)
func _on_madison_crest_court_area_mouse_exited():
	highlight_street('madison_crest_court','41000',false)

###Jefferson Hill Court###
func _on_jefferson_hill_court_area_mouse_entered():
	highlight_street('jefferson_hill_court','41000',true)
func _on_jefferson_hill_court_area_mouse_exited():
	highlight_street('jefferson_hill_court','41000',false)

###Ambrose Hills Road###
func _on_ambrose_hills_road_area_mouse_entered():
	highlight_street('ambrose_hills_road','41000',true)
func _on_ambrose_hills_road_area_mouse_exited():
	highlight_street('ambrose_hills_road','41000',false)

###Beachway Drive###
func _on_beachway_drive_area_mouse_entered():
	highlight_street('beachway_drive','41000',true)
func _on_beachway_drive_area_mouse_exited():
	highlight_street('beachway_drive','41000',false)

###Blair Road###
func _on_blair_road_area_mouse_entered():
	highlight_street('blair_road','41000',true)
func _on_blair_road_area_mouse_exited():
	highlight_street('blair_road','41000',false)

###Boat Dock Drive###
func _on_boat_dock_drive_area_mouse_entered():
	highlight_street('boat_dock_drive','41000',true)
func _on_boat_dock_drive_area_mouse_exited():
	highlight_street('boat_dock_drive','41000',false)

###Duff Drive###
func _on_duff_drive_area_mouse_entered():
	highlight_street('duff_drive','41000',true)
func _on_duff_drive_area_mouse_exited():
	highlight_street('duff_drive','41000',false)

###Edgewater Drive###
func _on_edgewater_drive_area_mouse_entered():
	highlight_street('edgewater_drive','41000',true)
func _on_edgewater_drive_area_mouse_exited():
	highlight_street('edgewater_drive','41000',false)

###Glen Carlyn Drive###
func _on_glen_carlyn_drive_area_mouse_entered():
	highlight_street('glen_carlyn_drive','41000',true)
func _on_glen_carlyn_drive_area_mouse_exited():
	highlight_street('glen_carlyn_drive','41000',false)

###Gordon Street###
func _on_gordon_street_area_mouse_entered():
	highlight_street('gordon_street','41000',true)
func _on_gordon_street_area_mouse_exited():
	highlight_street('gordon_street','41000',false)

###Greentree Drive###
func _on_greentree_drive_area_mouse_entered():
	highlight_street('greentree_drive','41000',true)
func _on_greentree_drive_area_mouse_exited():
	highlight_street('greentree_drive','41000',false)

###Lake Street###
func _on_lake_street_area_mouse_entered():
	highlight_street('lake_street','41000',true)
func _on_lake_street_area_mouse_exited():
	highlight_street('lake_street','41000',false)

###Malibu Circle###
func _on_malibu_circle_area_mouse_entered():
	highlight_street('malibu_circle','41000',true)
func _on_malibu_circle_area_mouse_exited():
	highlight_street('malibu_circle','41000',false)

###Mansfield Road###
func _on_mansfield_road_area_mouse_entered():
	highlight_street('mansfield_road','41000',true)
func _on_mansfield_road_area_mouse_exited():
	highlight_street('mansfield_road','41000',false)



#############################################################
#############################################################
#############################################################

#41008#

###Tyler Street###
func _on_tyler_street_area_mouse_entered():
	highlight_street('tyler_street','41008',true)
func _on_tyler_street_area_mouse_exited():
	highlight_street('tyler_street','41008',false)


func _on_argyle_drive_area_mouse_entered():
	highlight_street('argyle_drive','41008',true)
func _on_argyle_drive_area_mouse_exited():
	highlight_street('argyle_drive','41008',false)

func _on_aura_court_area_mouse_entered():
	highlight_street('aura_court','41008',true)
func _on_aura_court_area_mouse_exited():
	highlight_street('aura_court','41008',false)

func _on_bellview_drive_area_mouse_entered():
	highlight_street('bellview_drive','41008',true)
func _on_bellview_drive_area_mouse_exited():
	highlight_street('bellview_drive','41008',false)

func _on_boston_drive_area_mouse_entered():
	highlight_street('boston_drive','41008',true)
func _on_boston_drive_area_mouse_exited():
	highlight_street('boston_drive','41008',false)

func _on_brill_court_area_mouse_entered():
	highlight_street('brill_court','41008',true)
func _on_brill_court_area_mouse_exited():
	highlight_street('brill_court','41008',false)

func _on_carlyn_court_area_mouse_entered():
	highlight_street('carlyn_court','41008',true)
func _on_carlyn_court_area_mouse_exited():
	highlight_street('carlyn_court','41008',false)

func _on_charles_street_area_mouse_entered():
	highlight_street('charles_street','41008',true)
func _on_charles_street_area_mouse_exited():
	highlight_street('charles_street','41008',false)

func _on_chicamuxen_court_area_mouse_entered():
	highlight_street('chicamuxen_court','41008',true)
func _on_chicamuxen_court_area_mouse_exited():
	highlight_street('chicamuxen_court','41008',false)

func _on_church_street_area_mouse_entered():
	highlight_street('church_street','41008',true)
func _on_church_street_area_mouse_exited():
	highlight_street('church_street','41008',false)

func _on_courtland_drive_area_mouse_entered():
	highlight_street('courtland_drive','41008',true)
func _on_courtland_drive_area_mouse_exited():
	highlight_street('courtland_drive','41008',false)

func _on_culmore_court_area_mouse_entered():
	highlight_street('culmore_court','41008',true)
func _on_culmore_court_area_mouse_exited():
	highlight_street('culmore_court','41008',false)

func _on_durbin_place_area_mouse_entered():
	highlight_street('durbin_place','41008',true)
func _on_durbin_place_area_mouse_exited():
	highlight_street('durbin_place','41008',false)

func _on_freedom_place_area_mouse_entered():
	highlight_street('freedom_place','41008',true)
func _on_freedom_place_area_mouse_exited():
	highlight_street('freedom_place','41008',false)

func _on_garland_drive_area_mouse_entered():
	highlight_street('garland_drive','41008',true)
func _on_garland_drive_area_mouse_exited():
	highlight_street('garland_drive','41008',false)

func _on_glenmore_drive_area_mouse_entered():
	highlight_street('glenmore_drive','41008',true)
func _on_glenmore_drive_area_mouse_exited():
	highlight_street('glenmore_drive','41008',false)

func _on_glen_forest_drive_area_mouse_entered():
	highlight_street('glen_forest_drive','41008',true)
func _on_glen_forest_drive_area_mouse_exited():
	highlight_street('glen_forest_drive','41008',false)

func _on_haven_place_area_mouse_entered():
	highlight_street('haven_place','41008',true)
func _on_haven_place_area_mouse_exited():
	highlight_street('haven_place','41008',false)

func _on_kaywood_drive_area_mouse_entered():
	highlight_street('kaywood_drive','41008',true)
func _on_kaywood_drive_area_mouse_exited():
	highlight_street('kaywood_drive','41008',false)

func _on_kaywood_place_area_mouse_entered():
	highlight_street('kaywood_place','41008',true)
func _on_kaywood_place_area_mouse_exited():
	highlight_street('kaywood_place','41008',false)

func _on_knollwood_drive_area_mouse_entered():
	highlight_street('knollwood_drive','41008',true)
func _on_knollwood_drive_area_mouse_exited():
	highlight_street('knollwood_drive','41008',false)

func _on_longbranch_drive_area_mouse_entered():
	highlight_street('longbranch_drive','41008',true)
func _on_longbranch_drive_area_mouse_exited():
	highlight_street('longbranch_drive','41008',false)

func _on_longwood_drive_area_mouse_entered():
	highlight_street('longwood_drive','41008',true)
func _on_longwood_drive_area_mouse_exited():
	highlight_street('longwood_drive','41008',false)

func _on_lucky_court_area_mouse_entered():
	highlight_street('lucky_court','41008',true)
func _on_lucky_court_area_mouse_exited():
	highlight_street('lucky_court','41008',false)

func _on_magnolia_avenue_area_mouse_entered():
	highlight_street('magnolia_avenue','41008',true)
func _on_magnolia_avenue_area_mouse_exited():
	highlight_street('magnolia_avenue','41008',false)

func _on_maple_court_area_mouse_entered():
	highlight_street('maple_court','41008',true)
func _on_maple_court_area_mouse_exited():
	highlight_street('maple_court','41008',false)

func _on_payne_street_area_mouse_entered():
	highlight_street('payne_street','41008',true)
func _on_payne_street_area_mouse_exited():
	highlight_street('payne_street','41008',false)

func _on_peace_valley_lane_area_mouse_entered():
	highlight_street('peace_valley_lane','41008',true)
func _on_peace_valley_lane_area_mouse_exited():
	highlight_street('peace_valley_lane','41008',false)
	
func _on_pensa_drive_area_mouse_entered():
	highlight_street('pensa_drive','41008',true)
func _on_pensa_drive_area_mouse_exited():
	highlight_street('pensa_drive','41008',false)

func _on_red_pine_street_area_mouse_entered():
	highlight_street('red_pine_street','41008',true)
func _on_red_pine_street_area_mouse_exited():
	highlight_street('red_pine_street','41008',false)

func _on_vista_drive_area_mouse_entered():
	highlight_street('vista_drive','41008',true)
func _on_vista_drive_area_mouse_exited():
	highlight_street('vista_drive','41008',false)

func _on_washington_drive_area_mouse_entered():
	highlight_street('washington_drive','41008',true)
func _on_washington_drive_area_mouse_exited():
	highlight_street('washington_drive','41008',false)
	
func _on_wilkins_drive_area_mouse_entered():
	highlight_street('wilkins_drive','41008',true)
func _on_wilkins_drive_area_mouse_exited():
	highlight_street('wilkins_drive','41008',false)
	
#############################################################
#############################################################
#############################################################

#41097#

func _on_barnum_lane_area_mouse_entered():
	highlight_street('barnum_lane','41097',true)
func _on_barnum_lane_area_mouse_exited():
	highlight_street('barnum_lane','41097',false)
	
func _on_deming_avenue_area_mouse_entered():
	highlight_street('deming_avenue','41097',true)
func _on_deming_avenue_area_mouse_exited():
	highlight_street('deming_avenue','41097',false)
	
func _on_gloucester_road_area_mouse_entered():
	highlight_street('gloucester_road','41097',true)
func _on_gloucester_road_area_mouse_exited():
	highlight_street('gloucester_road','41097',false)

func _on_joanne_drive_area_mouse_entered():
	highlight_street('joanne_drive','41097',true)
func _on_joanne_drive_area_mouse_exited():
	highlight_street('joanne_drive','41097',false)

func _on_kling_drive_area_mouse_entered():
	highlight_street('kling_drive','41097',true)
func _on_kling_drive_area_mouse_exited():
	highlight_street('kling_drive','41097',false)
	
func _on_lincolnia_road_area_mouse_entered():
	highlight_street('lincolnia_road','41097',true)
func _on_lincolnia_road_area_mouse_exited():
	highlight_street('lincolnia_road','41097',false)

func _on_meeting_house_way_area_mouse_entered():
	highlight_street('meeting_house_way','41097',true)
func _on_meeting_house_way_area_mouse_exited():
	highlight_street('meeting_house_way','41097',false)

func _on_north_beauregard_street_area_mouse_entered():
	highlight_street('north_beauregard_street','41097',true)
func _on_north_beauregard_street_area_mouse_exited():
	highlight_street('north_beauregard_street','41097',false)

func _on_north_chambliss_street_area_mouse_entered():
	highlight_street('north_chambliss_street','41097',true)
func _on_north_chambliss_street_area_mouse_exited():
	highlight_street('north_chambliss_street','41097',false)

func _on_north_morgan_street_area_mouse_entered():
	highlight_street('north_morgan_street','41097',true)
func _on_north_morgan_street_area_mouse_exited():
	highlight_street('north_morgan_street','41097',false)

func _on_rynex_drive_area_mouse_entered():
	highlight_street('rynex_drive','41097',true)
func _on_rynex_drive_area_mouse_exited():
	highlight_street('rynex_drive','41097',false)

func _on_shackleford_terrace_area_mouse_entered():
	highlight_street('shackleford_terrace','41097',true)
func _on_shackleford_terrace_area_mouse_exited():
	highlight_street('shackleford_terrace','41097',false)

#############################################################
#############################################################
#############################################################

#41012#
func _on_arcadia_road_area_mouse_entered():
	highlight_street('arcadia_road','41012',true)
func _on_arcadia_road_area_mouse_exited():
	highlight_street('arcadia_road','41012',false)

func _on_ashwood_place_area_mouse_entered():
	highlight_street('ashwood_place','41012',true)
func _on_ashwood_place_area_mouse_exited():
	highlight_street('ashwood_place','41012',false)
	
func _on_barcroft_mews_drive_area_mouse_entered():
	highlight_street('barcroft_mews_drive','41012',true)
func _on_barcroft_mews_drive_area_mouse_exited():
	highlight_street('barcroft_mews_drive','41012',false)

func _on_birchwood_road_area_mouse_entered():
	highlight_street('birchwood_road','41012',true)
func _on_birchwood_road_area_mouse_exited():
	highlight_street('birchwood_road','41012',false)

func _on_braddock_road_area_mouse_entered():
	highlight_street('braddock_road','41012',true)
func _on_braddock_road_area_mouse_exited():
	highlight_street('braddock_road','41012',false)

func _on_bryce_road_area_mouse_entered():
	highlight_street('bryce_road','41012',true)
func _on_bryce_road_area_mouse_exited():
	highlight_street('bryce_road','41012',false)

func _on_burnt_pine_court_area_mouse_entered():
	highlight_street('burnt_pine_court','41012',true)
func _on_burnt_pine_court_area_mouse_exited():
	highlight_street('burnt_pine_court','41012',false)

func _on_century_court_area_mouse_entered():
	highlight_street('century_court','41012',true)
func _on_century_court_area_mouse_exited():
	highlight_street('century_court','41012',false)

func _on_chaco_road_area_mouse_entered():
	highlight_street('chaco_road','41012',true)
func _on_chaco_road_area_mouse_exited():
	highlight_street('chaco_road','41012',false)

func _on_conrad_road_area_mouse_entered():
	highlight_street('conrad_road','41012',true)
func _on_conrad_road_area_mouse_exited():
	highlight_street('conrad_road','41012',false)

func _on_crestwood_drive_area_mouse_entered():
	highlight_street('crestwood_drive','41012',true)
func _on_crestwood_drive_area_mouse_exited():
	highlight_street('crestwood_drive','41012',false)

func _on_dakota_court_area_mouse_entered():
	highlight_street('dakota_court','41012',true)
func _on_dakota_court_area_mouse_exited():
	highlight_street('dakota_court','41012',false)

func _on_dogwood_place_area_mouse_entered():
	highlight_street('dogwood_place','41012',true)
func _on_dogwood_place_area_mouse_exited():
	highlight_street('dogwood_place','41012',false)

func _on_everglades_drive_area_mouse_entered():
	highlight_street('everglades_drive','41012',true)
func _on_everglades_drive_area_mouse_exited():
	highlight_street('everglades_drive','41012',false)
	
func _on_fairway_downs_court_area_mouse_entered():
	highlight_street('fairway_downs_court','41012',true)
func _on_fairway_downs_court_area_mouse_exited():
	highlight_street('fairway_downs_court','41012',false)

func _on_ginger_drive_area_mouse_entered():
	highlight_street('ginger_drive','41012',true)
func _on_ginger_drive_area_mouse_exited():
	highlight_street('ginger_drive','41012',false)
	
func _on_glenview_court_area_mouse_entered():
	highlight_street('glenview_court','41012',true)
func _on_glenview_court_area_mouse_exited():
	highlight_street('glenview_court','41012',false)
	
func _on_guest_lane_area_mouse_entered():
	highlight_street('guest_lane','41012',true)
func _on_guest_lane_area_mouse_exited():
	highlight_street('guest_lane','41012',false)
	
func _on_hawaii_court_area_mouse_entered():
	highlight_street('hawaii_court','41012',true)
func _on_hawaii_court_area_mouse_exited():
	highlight_street('hawaii_court','41012',false)

func _on_hillcrest_place_area_mouse_entered():
	highlight_street('hillcrest_place','41012',true)
func _on_hillcrest_place_area_mouse_exited():
	highlight_street('hillcrest_place','41012',false)

func _on_jewel_street_area_mouse_entered():
	highlight_street('jewel_street','41012',true)
func _on_jewel_street_area_mouse_exited():
	highlight_street('jewel_street','41012',false)

func _on_lakewood_drive_area_mouse_entered():
	highlight_street('lakewood_drive','41012',true)
func _on_lakewood_drive_area_mouse_exited():
	highlight_street('lakewood_drive','41012',false)

func _on_landess_street_area_mouse_entered():
	highlight_street('landess_street','41012',true)
func _on_landess_street_area_mouse_exited():
	highlight_street('landess_street','41012',false)

func _on_lassen_court_area_mouse_entered():
	highlight_street('lassen_court','41012',true)
func _on_lassen_court_area_mouse_exited():
	highlight_street('lassen_court','41012',false)

func _on_maplewood_drive_area_mouse_entered():
	highlight_street('maplewood_drive','41012',true)
func _on_maplewood_drive_area_mouse_exited():
	highlight_street('maplewood_drive','41012',false)

func _on_mesa_way_area_mouse_entered():
	highlight_street('mesa_way','41012',true)
func _on_mesa_way_area_mouse_exited():
	highlight_street('mesa_way','41012',false)

func _on_morgan_street_area_mouse_entered():
	highlight_street('morgan_street','41012',true)
func _on_morgan_street_area_mouse_exited():
	highlight_street('morgan_street','41012',false)

func _on_morin_street_area_mouse_entered():
	highlight_street('morin_street','41012',true)
func _on_morin_street_area_mouse_exited():
	highlight_street('morin_street','41012',false)

func _on_muir_place_area_mouse_entered():
	highlight_street('muir_place','41012',true)
func _on_muir_place_area_mouse_exited():
	highlight_street('muir_place','41012',false)

func _on_oakridge_drive_area_mouse_entered():
	highlight_street('oakridge_drive','41012',true)
func _on_oakridge_drive_area_mouse_exited():
	highlight_street('oakridge_drive','41012',false)

func _on_oakwood_drive_area_mouse_entered():
	highlight_street('oakwood_drive','41012',true)
func _on_oakwood_drive_area_mouse_exited():
	highlight_street('oakwood_drive','41012',false)

func _on_olympic_way_area_mouse_entered():
	highlight_street('olympic_way','41012',true)
func _on_olympic_way_area_mouse_exited():
	highlight_street('olympic_way','41012',false)

func _on_paramore_drive_area_mouse_entered():
	highlight_street('paramore_drive','41012',true)
func _on_paramore_drive_area_mouse_exited():
	highlight_street('paramore_drive','41012',false)

func _on_pinewood_terrace_area_mouse_entered():
	highlight_street('pinewood_terrace','41012',true)
func _on_pinewood_terrace_area_mouse_exited():
	highlight_street('pinewood_terrace','41012',false)

func _on_pine_lane_area_mouse_entered():
	highlight_street('pine_lane','41012',true)
func _on_pine_lane_area_mouse_exited():
	highlight_street('pine_lane','41012',false)

func _on_river_downs_road_area_mouse_entered():
	highlight_street('river_downs_road','41012',true)
func _on_river_downs_road_area_mouse_exited():
	highlight_street('river_downs_road','41012',false)

func _on_sequoia_court_area_mouse_entered():
	highlight_street('sequoia_court','41012',true)
func _on_sequoia_court_area_mouse_exited():
	highlight_street('sequoia_court','41012',false)

func _on_summit_place_area_mouse_entered():
	highlight_street('summit_place','41012',true)
func _on_summit_place_area_mouse_exited():
	highlight_street('summit_place','41012',false)

func _on_tahoe_court_area_mouse_entered():
	highlight_street('tahoe_court','41012',true)
func _on_tahoe_court_area_mouse_exited():
	highlight_street('tahoe_court','41012',false)

func _on_teton_place_area_mouse_entered():
	highlight_street('teton_place','41012',true)
func _on_teton_place_area_mouse_exited():
	highlight_street('teton_place','41012',false)

func _on_tonto_court_area_mouse_entered():
	highlight_street('tonto_court','41012',true)
func _on_tonto_court_area_mouse_exited():
	highlight_street('tonto_court','41012',false)

func _on_twin_knolls_court_area_mouse_entered():
	highlight_street('twin_knolls_court','41012',true)
func _on_twin_knolls_court_area_mouse_exited():
	highlight_street('twin_knolls_court','41012',false)

func _on_verde_court_area_mouse_entered():
	highlight_street('verde_court','41012',true)
func _on_verde_court_area_mouse_exited():
	highlight_street('verde_court','41012',false)

func _on_yellowstone_drive_area_mouse_entered():
	highlight_street('yellowstone_drive','41012',true)
func _on_yellowstone_drive_area_mouse_exited():
	highlight_street('yellowstone_drive','41012',false)

func _on_yosemite_drive_area_mouse_entered():
	highlight_street('yosemite_drive','41012',true)
func _on_yosemite_drive_area_mouse_exited():
	highlight_street('yosemite_drive','41012',false)

func _on_zion_court_area_mouse_entered():
	highlight_street('zion_court','41012',true)
func _on_zion_court_area_mouse_exited():
	highlight_street('zion_court','41012',false)

func _on_crater_place_area_mouse_entered():
	highlight_street('crater_place','41012',true)
func _on_crater_place_area_mouse_exited():
	highlight_street('crater_place','41012',false)


#############################################################
#############################################################
#############################################################

#41096#

func _on_brookside_drive_area_mouse_entered():
	highlight_street('brookside_drive','41096',true)
func _on_brookside_drive_area_mouse_exited():
	highlight_street('brookside_drive','41096',false)

func _on_green_spring_road_area_mouse_entered():
	highlight_street('green_spring_road','41096',true)
func _on_green_spring_road_area_mouse_exited():
	highlight_street('green_spring_road','41096',false)

func _on_magnolia_manor_way_area_mouse_entered():
	highlight_street('magnolia_manor_way','41096',true)
func _on_magnolia_manor_way_area_mouse_exited():
	highlight_street('magnolia_manor_way','41096',false)

func _on_park_road_area_mouse_entered():
	highlight_street('park_road','41096',true)
func _on_park_road_area_mouse_exited():
	highlight_street('park_road','41096',false)

func _on_vale_street_area_mouse_entered():
	highlight_street('vale_street','41096',true)
func _on_vale_street_area_mouse_exited():
	highlight_street('vale_street','41096',false)

func _on_witch_hazel_road_area_mouse_entered():
	highlight_street('witch_hazel_road','41096',true)
func _on_witch_hazel_road_area_mouse_exited():
	highlight_street('witch_hazel_road','41096',false)

#############################################################
#############################################################
#############################################################

#41011#

func _on_aqua_terrace_area_mouse_entered():
	highlight_street('aqua_terrace','41011',true)
func _on_aqua_terrace_area_mouse_exited():
	highlight_street('aqua_terrace','41011',false)

func _on_barcroft_lane_area_mouse_entered():
	highlight_street('barcroft_lane','41011',true)
func _on_barcroft_lane_area_mouse_exited():
	highlight_street('barcroft_lane','41011',false)

func _on_burton_circle_area_mouse_entered():
	highlight_street('burton_circle','41011',true)
func _on_burton_circle_area_mouse_exited():
	highlight_street('burton_circle','41011',false)

func _on_dockser_terrace_area_mouse_entered():
	highlight_street('dockser_terrace','41011',true)
func _on_dockser_terrace_area_mouse_exited():
	highlight_street('dockser_terrace','41011',false)

func _on_fairfax_parkway_area_mouse_entered():
	highlight_street('fairfax_parkway','41011',true)
func _on_fairfax_parkway_area_mouse_exited():
	highlight_street('fairfax_parkway','41011',false)

func _on_jay_miller_drive_area_mouse_entered():
	highlight_street('jay_miller_drive','41011',true)
func _on_jay_miller_drive_area_mouse_exited():
	highlight_street('jay_miller_drive','41011',false)

func _on_lakeview_drive_area_mouse_entered():
	highlight_street('lakeview_drive','41011',true)
func _on_lakeview_drive_area_mouse_exited():
	highlight_street('lakeview_drive','41011',false)
	
func _on_lakeview_terrace_area_mouse_entered():
	highlight_street('lakeview_terrace','41011',true)
func _on_lakeview_terrace_area_mouse_exited():
	highlight_street('lakeview_terrace','41011',false)

func _on_melvern_place_area_mouse_entered():
	highlight_street('melvern_place','41011',true)
func _on_melvern_place_area_mouse_exited():
	highlight_street('melvern_place','41011',false)

func _on_parkhill_drive_area_mouse_entered():
	highlight_street('parkhill_drive','41011',true)
func _on_parkhill_drive_area_mouse_exited():
	highlight_street('parkhill_drive','41011',false)

func _on_quaint_acre_circle_area_mouse_entered():
	highlight_street('quaint_acre_circle','41011',true)
func _on_quaint_acre_circle_area_mouse_exited():
	highlight_street('quaint_acre_circle','41011',false)

func _on_tallwood_terrace_area_mouse_entered():
	highlight_street('tallwood_terrace','41011',true)
func _on_tallwood_terrace_area_mouse_exited():
	highlight_street('tallwood_terrace','41011',false)

func _on_tollgate_terrace_area_mouse_entered():
	highlight_street('tollgate_terrace','41011',true)
func _on_tollgate_terrace_area_mouse_exited():
	highlight_street('tollgate_terrace','41011',false)

func _on_downing_court_area_mouse_entered():
	highlight_street('downing_court','41014',true)
func _on_downing_court_area_mouse_exited():
	highlight_street('downing_court','41014',false)

func _on_downing_street_area_mouse_entered():
	highlight_street('downing_street','41014',true)
func _on_downing_street_area_mouse_exited():
	highlight_street('downing_street','41014',false)

func _on_elmdale_road_area_mouse_entered():
	highlight_street('elmdale_road','41014',true)
func _on_elmdale_road_area_mouse_exited():
	highlight_street('elmdale_road','41014',false)

func _on_emory_street_area_mouse_entered():
	highlight_street('emory_street','41014',true)
func _on_emory_street_area_mouse_exited():
	highlight_street('emory_street','41014',false)

func _on_gainer_street_area_mouse_entered():
	highlight_street('gainer_street','41014',true)
func _on_gainer_street_area_mouse_exited():
	highlight_street('gainer_street','41014',false)

func _on_holyoke_drive_area_mouse_entered():
	highlight_street('holyoke_drive','41014',true)
func _on_holyoke_drive_area_mouse_exited():
	highlight_street('holyoke_drive','41014',false)

func _on_marionet_street_area_mouse_entered():
	highlight_street('marionet_street','41014',true)
func _on_marionet_street_area_mouse_exited():
	highlight_street('marionet_street','41014',false)

func _on_old_columbia_pike_area_mouse_entered():
	highlight_street('old_columbia_pike','41014',true)
func _on_old_columbia_pike_area_mouse_exited():
	highlight_street('old_columbia_pike','41014',false)

func _on_overlook_drive_area_mouse_entered():
	highlight_street('overlook_drive','41014',true)
func _on_overlook_drive_area_mouse_exited():
	highlight_street('overlook_drive','41014',false)

func _on_oxford_street_area_mouse_entered():
	highlight_street('oxford_street','41014',true)
func _on_oxford_street_area_mouse_exited():
	highlight_street('oxford_street','41014',false)

func _on_pinecrest_court_area_mouse_entered():
	highlight_street('pinecrest_court','41014',true)
func _on_pinecrest_court_area_mouse_exited():
	highlight_street('pinecrest_court','41014',false)

func _on_woodridge_road_area_mouse_entered():
	highlight_street('woodridge_road','41014',true)
func _on_woodridge_road_area_mouse_exited():
	highlight_street('woodridge_road','41014',false)

func _on_woodway_street_area_mouse_entered():
	highlight_street('woodway_street','41014',true)
func _on_woodway_street_area_mouse_exited():
	highlight_street('woodway_street','41014',false)

#############################################################
#############################################################
#############################################################

#41041#

func _on_fairview_place_area_mouse_entered():
	highlight_street('fairview_place','41041',true)
func _on_fairview_place_area_mouse_exited():
	highlight_street('fairview_place','41041',false)

func _on_glenwood_place_area_mouse_entered():
	highlight_street('glenwood_place','41041',true)
func _on_glenwood_place_area_mouse_exited():
	highlight_street('glenwood_place','41041',false)

func _on_glen_carlyn_road_area_mouse_entered():
	highlight_street('glen_carlyn_road','41041',true)
func _on_glen_carlyn_road_area_mouse_exited():
	highlight_street('glen_carlyn_road','41041',false)

func _on_hallran_road_area_mouse_entered():
	highlight_street('hallran_road','41041',true)
func _on_hallran_road_area_mouse_exited():
	highlight_street('hallran_road','41041',false)

func _on_hardwick_place_area_mouse_entered():
	highlight_street('hardwick_place','41041',true)
func _on_hardwick_place_area_mouse_exited():
	highlight_street('hardwick_place','41041',false)

func _on_jan_mar_drive_area_mouse_entered():
	highlight_street('jan_mar_drive','41041',true)
func _on_jan_mar_drive_area_mouse_exited():
	highlight_street('jan_mar_drive','41041',false)

func _on_kimble_court_area_mouse_entered():
	highlight_street('kimble_court','41041',true)
func _on_kimble_court_area_mouse_exited():
	highlight_street('kimble_court','41041',false)

func _on_lakeside_view_drive_mouse_entered():
	highlight_street('lakeside_view_drive','41041',true)
func _on_lakeside_view_drive_mouse_exited():
	highlight_street('lakeside_view_drive','41041',false)

func _on_lebanon_drive_area_mouse_entered():
	highlight_street('lebanon_drive','41041',true)
func _on_lebanon_drive_area_mouse_exited():
	highlight_street('lebanon_drive','41041',false)

func _on_maries_drive_area_mouse_entered():
	highlight_street('maries_drive','41041',true)
func _on_maries_drive_area_mouse_exited():
	highlight_street('maries_drive','41041',false)

func _on_merritt_place_area_mouse_entered():
	highlight_street('merritt_place','41041',true)
func _on_merritt_place_area_mouse_exited():
	highlight_street('merritt_place','41041',false)

func _on_munson_court_area_mouse_entered():
	highlight_street('munson_court','41041',true)
func _on_munson_court_area_mouse_exited():
	highlight_street('munson_court','41041',false)

func _on_munson_hill_road_area_mouse_entered():
	highlight_street('munson_hill_road','41041',true)
func _on_munson_hill_road_area_mouse_exited():
	highlight_street('munson_hill_road','41041',false)

func _on_munson_place_area_mouse_entered():
	highlight_street('munson_place','41041',true)
func _on_munson_place_area_mouse_exited():
	highlight_street('munson_place','41041',false)

func _on_olds_drive_area_mouse_entered():
	highlight_street('olds_drive','41041',true)
func _on_olds_drive_area_mouse_exited():
	highlight_street('olds_drive','41041',false)

func _on_south_5_th_road_area_mouse_entered():
	highlight_street('south_5th_road','41041',true)
func _on_south_5_th_road_area_mouse_exited():
	highlight_street('south_5th_road','41041',false)

func _on_south_6_th_road_area_mouse_entered():
	highlight_street('south_6th_road','41041',true)
func _on_south_6_th_road_area_mouse_exited():
	highlight_street('south_6th_road','41041',false)

func _on_south_6_th_street_area_mouse_entered():
	highlight_street('south_6th_street','41041',true)
func _on_south_6_th_street_area_mouse_exited():
	highlight_street('south_6th_street','41041',false)

func _on_south_manchester_street_area_mouse_entered():
	highlight_street('south_manchester_street','41041',true)
func _on_south_manchester_street_area_mouse_exited():
	highlight_street('south_manchester_street','41041',false)
	
	#############################################################
#############################################################
#############################################################

#41091#

func _on_gorham_street_area_mouse_entered():
	highlight_street('gorham_street','41091',true)
func _on_gorham_street_area_mouse_exited():
	highlight_street('gorham_street','41091',false)

func _on_rock_springs_avenue_area_mouse_entered():
	highlight_street('rock_springs_avenue','41091',true)
func _on_rock_springs_avenue_area_mouse_exited():
	highlight_street('rock_springs_avenue','41091',false)

func _on_south_carlin_springs_road_area_mouse_entered():
	highlight_street('south_carlin_springs_road','41091',true)
func _on_south_carlin_springs_road_area_mouse_exited():
	highlight_street('south_carlin_springs_road','41091',false)

	
	#############################################################
#############################################################
#############################################################

#41092#


func _on_forest_drive_area_mouse_entered():
	highlight_street('forest_drive','41092',true)
func _on_forest_drive_area_mouse_exited():
	highlight_street('forest_drive','41092',false)

func _on_leesburg_court_area_mouse_entered():
	highlight_street('leesburg_court','41092',true)
func _on_leesburg_court_area_mouse_exited():
	highlight_street('leesburg_court','41092',false)

func _on_lee_court_area_mouse_entered():
	highlight_street('lee_court','41092',true)
func _on_lee_court_area_mouse_exited():
	highlight_street('lee_court','41092',false)

func _on_seminary_road_area_mouse_entered():
	highlight_street('seminary_road','41092',true)
func _on_seminary_road_area_mouse_exited():
	highlight_street('seminary_road','41092',false)

func _on_skyline_village_court_area_mouse_entered():
	highlight_street('skyline_village_court','41092',true)
func _on_skyline_village_court_area_mouse_exited():
	highlight_street('skyline_village_court','41092',false)

func _on_south_12_th_street_area_mouse_entered():
	highlight_street('south_12th_street','41092',true)
func _on_south_12_th_street_area_mouse_exited():
	highlight_street('south_12th_street','41092',false)

func _on_south_14_th_street_area_mouse_entered():
	highlight_street('south_14th_street','41092',true)
func _on_south_14_th_street_area_mouse_exited():
	highlight_street('south_14th_street','41092',false)

func _on_south_george_mason_drive_area_mouse_entered():
	highlight_street('south_george_mason_drive','41092',true)
func _on_south_george_mason_drive_area_mouse_exited():
	highlight_street('south_george_mason_drive','41092',false)

func _on_south_greenbrier_street_are_mouse_entered():
	highlight_street('south_greenbrier_street','41092',true)
func _on_south_greenbrier_street_are_mouse_exited():
	highlight_street('south_greenbrier_street','41092',false)

func _on_south_hamilton_drive_area_mouse_entered():
	highlight_street('south_hamilton_drive','41092',true)
func _on_south_hamilton_drive_area_mouse_exited():
	highlight_street('south_hamilton_drive','41092',false)

func _on_south_harrison_street_area_mouse_entered():
	highlight_street('south_harrison_street','41092',true)
func _on_south_harrison_street_area_mouse_exited():
	highlight_street('south_harrison_street','41092',false)

func _on_south_jefferson_street_area_mouse_entered():
	highlight_street('south_jefferson_street','41092',true)
func _on_south_jefferson_street_area_mouse_exited():
	highlight_street('south_jefferson_street','41092',false)

func _on_washington_court_area_mouse_entered():
	highlight_street('washington_court','41092',true)
func _on_washington_court_area_mouse_exited():
	highlight_street('washington_court','41092',false)

	#############################################################
#############################################################
#############################################################

#41093#

func _on_bouffant_boulevard_area_mouse_entered():
	highlight_street('bouffant_boulevard','41093',true)
func _on_bouffant_boulevard_area_mouse_exited():
	highlight_street('bouffant_boulevard','41093',false)

func _on_center_lane_area_mouse_entered():
	highlight_street('center_lane','41093',true)
func _on_center_lane_area_mouse_exited():
	highlight_street('center_lane','41093',false)

func _on_dannys_lane_area_mouse_entered():
	highlight_street('dannys_lane','41093',true)
func _on_dannys_lane_area_mouse_exited():
	highlight_street('dannys_lane','41093',false)

func _on_dannys_place_area_mouse_entered():
	highlight_street('dannys_place','41093',true)
func _on_dannys_place_area_mouse_exited():
	highlight_street('dannys_place','41093',false)

func _on_magnolia_lane_area_mouse_entered():
	highlight_street('magnolia_lane','41093',true)
func _on_magnolia_lane_area_mouse_exited():
	highlight_street('magnolia_lane','41093',false)

func _on_maryalice_place_area_mouse_entered():
	highlight_street('maryalice_place','41093',true)
func _on_maryalice_place_area_mouse_exited():
	highlight_street('maryalice_place','41093',false)

func _on_north_rosser_street_area_mouse_entered():
	highlight_street('north_rosser_street','41093',true)
func _on_north_rosser_street_area_mouse_exited():
	highlight_street('north_rosser_street','41093',false)

func _on_paul_street_area_mouse_entered():
	highlight_street('paul_street','41093',true)
func _on_paul_street_area_mouse_exited():
	highlight_street('paul_street','41093',false)

func _on_scoville_street_area_mouse_entered():
	highlight_street('scoville_street','41093',true)
func _on_scoville_street_area_mouse_exited():
	highlight_street('scoville_street','41093',false)

func _on_williams_lane_area_mouse_entered():
	highlight_street('williams_lane','41093',true)
func _on_williams_lane_area_mouse_exited():
	highlight_street('williams_lane','41093',false)

	#############################################################
#############################################################
#############################################################

#41094#
func _on_arnet_street_area_mouse_entered():
	highlight_street('arnet_street','41094',true)
func _on_arnet_street_area_mouse_exited():
	highlight_street('arnet_street','41094',false)

func _on_barcroft_view_terrace_area_mouse_entered():
	highlight_street('barcroft_view_terrace','41094',true)
func _on_barcroft_view_terrace_area_mouse_exited():
	highlight_street('barcroft_view_terrace','41094',false)

func _on_bell_manor_court_area_mouse_entered():
	highlight_street('bell_manor_court','41094',true)
func _on_bell_manor_court_area_mouse_exited():
	highlight_street('bell_manor_court','41094',false)

func _on_carver_place_area_mouse_entered():
	highlight_street('carver_place','41094',true)
func _on_carver_place_area_mouse_exited():
	highlight_street('carver_place','41094',false)

func _on_dewey_jones_road_area_mouse_entered():
	highlight_street('dewey_jones_road','41094',true)
func _on_dewey_jones_road_area_mouse_exited():
	highlight_street('dewey_jones_road','41094',false)

func _on_ellery_circle_area_mouse_entered():
	highlight_street('ellery_circle','41094',true)
func _on_ellery_circle_area_mouse_exited():
	highlight_street('ellery_circle','41094',false)

func _on_falls_gate_court_area_mouse_entered():
	highlight_street('falls_gate_court','41094',true)
func _on_falls_gate_court_area_mouse_exited():
	highlight_street('falls_gate_court','41094',false)

func _on_hoffmans_lane_area_mouse_entered():
	highlight_street('hoffmans_lane','41094',true)
func _on_hoffmans_lane_area_mouse_exited():
	highlight_street('hoffmans_lane','41094',false)

func _on_lacy_boulevard_area_mouse_entered():
	highlight_street('lacy_boulevard','41094',true)
func _on_lacy_boulevard_area_mouse_exited():
	highlight_street('lacy_boulevard','41094',false)

func _on_lewis_lane_area_mouse_entered():
	highlight_street('lewis_lane','41094',true)
func _on_lewis_lane_area_mouse_exited():
	highlight_street('lewis_lane','41094',false)

func _on_moncure_avenue_area_mouse_entered():
	highlight_street('moncure_avenue','41094',true)
func _on_moncure_avenue_area_mouse_exited():
	highlight_street('moncure_avenue','41094',false)

func _on_munson_road_area_mouse_entered():
	highlight_street('munson_road','41094',true)
func _on_munson_road_area_mouse_exited():
	highlight_street('munson_road','41094',false)

func _on_oakview_gardens_drive_area_mouse_entered():
	highlight_street('oakview_gardens_drive','41094',true)
func _on_oakview_gardens_drive_area_mouse_exited():
	highlight_street('oakview_gardens_drive','41094',false)

func _on_pinkett_court_area_mouse_entered():
	highlight_street('pinkett_court','41094',true)
func _on_pinkett_court_area_mouse_exited():
	highlight_street('pinkett_court','41094',false)

func _on_poplar_lane_area_mouse_entered():
	highlight_street('poplar_lane','41094',true)
func _on_poplar_lane_area_mouse_exited():
	highlight_street('poplar_lane','41094',false)

func _on_sheppards_court_area_mouse_entered():
	highlight_street('sheppards_court','41094',true)
func _on_sheppards_court_area_mouse_exited():
	highlight_street('sheppards_court','41094',false)

func _on_summers_lane_area_mouse_entered():
	highlight_street('summers_lane','41094',true)
func _on_summers_lane_area_mouse_exited():
	highlight_street('summers_lane','41094',false)
	

	#############################################################
#############################################################
#############################################################

#41095#

func _on_bradley_boulevard_area_mouse_entered():
	highlight_street('bradley_boulevard','41095',true)
func _on_bradley_boulevard_area_mouse_exited():
	highlight_street('bradley_boulevard','41095',false)

func _on_chestnut_place_area_mouse_entered():
	highlight_street('chestnut_place','41095',true)
func _on_chestnut_place_area_mouse_exited():
	highlight_street('chestnut_place','41095',false)

func _on_christine_place_area_mouse_entered():
	highlight_street('christine_place','41095',true)
func _on_christine_place_area_mouse_exited():
	highlight_street('christine_place','41095',false)

func _on_colfax_avenue_area_mouse_entered():
	highlight_street('colfax_avenue','41095',true)
func _on_colfax_avenue_area_mouse_exited():
	highlight_street('colfax_avenue','41095',false)

func _on_cook_street_area_mouse_entered():
	highlight_street('cook_street','41095',true)
func _on_cook_street_area_mouse_exited():
	highlight_street('cook_street','41095',false)

func _on_david_lane_area_mouse_entered():
	highlight_street('david_lane','41095',true)
func _on_david_lane_area_mouse_exited():
	highlight_street('david_lane','41095',false)

func _on_dawes_avenue_area_mouse_entered():
	highlight_street('dawes_avenue','41095',true)
func _on_dawes_avenue_area_mouse_exited():
	highlight_street('dawes_avenue','41095',false)

func _on_doris_place_area_mouse_entered():
	highlight_street('doris_place','41095',true)
func _on_doris_place_area_mouse_exited():
	highlight_street('doris_place','41095',false)

func _on_faith_court_area_mouse_entered():
	highlight_street('faith_court','41095',true)
func _on_faith_court_area_mouse_exited():
	highlight_street('faith_court','41095',false)

func _on_hatton_court_area_mouse_entered():
	highlight_street('hatton_court','41095',true)
func _on_hatton_court_area_mouse_exited():
	highlight_street('hatton_court','41095',false)
	
func _on_hawthorne_avenue_area_mouse_entered():
	highlight_street('hawthorne_avenue','41095',true)
func _on_hawthorne_avenue_area_mouse_exited():
	highlight_street('hawthorne_avenue','41095',false)

func _on_holmes_run_parkway_area_mouse_entered():
	highlight_street('holmes_run_parkway','41095',true)
func _on_holmes_run_parkway_area_mouse_exited():
	highlight_street('holmes_run_parkway','41095',false)

func _on_lester_court_area_mouse_entered():
	highlight_street('lester_court','41095',true)
func _on_lester_court_area_mouse_exited():
	highlight_street('lester_court','41095',false)

func _on_north_stevens_street_area_mouse_entered():
	highlight_street('north_stevens_street','41095',true)
func _on_north_stevens_street_area_mouse_exited():
	highlight_street('north_stevens_street','41095',false)

func _on_resevoir_heights_avenue_area_mouse_entered():
	highlight_street('resevoir_heights_avenue','41095',true)
func _on_resevoir_heights_avenue_area_mouse_exited():
	highlight_street('resevoir_heights_avenue','41095',false)

func _on_skyline_heights_court_area_mouse_entered():
	highlight_street('skyline_heights_court','41095',true)
func _on_skyline_heights_court_area_mouse_exited():
	highlight_street('skyline_heights_court','41095',false)

func _on_terrett_court_area_mouse_entered():
	highlight_street('terrett_court','41095',true)
func _on_terrett_court_area_mouse_exited():
	highlight_street('terrett_court','41095',false)

func _on_wheat_court_area_mouse_entered():
	highlight_street('wheat_court','41095',true)
func _on_wheat_court_area_mouse_exited():
	highlight_street('wheat_court','41095',false)
	

#############################################################
#############################################################
#############################################################

#41098#


func _on_albro_lane_area_mouse_entered():
	highlight_street('albro_lane','41098',true)
func _on_albro_lane_area_mouse_exited():
	highlight_street('albro_lane','41098',false)
	
func _on_applegath_court_area_mouse_entered():
	highlight_street('applegath_court','41098',true)
func _on_applegath_court_area_mouse_exited():
	highlight_street('applegath_court','41098',false)

func _on_berlee_drive_area_mouse_entered():
	highlight_street('berlee_drive','41098',true)
func _on_berlee_drive_area_mouse_exited():
	highlight_street('berlee_drive','41098',false)

func _on_bushie_court_area_mouse_entered():
	highlight_street('bushie_court','41098',true)
func _on_bushie_court_area_mouse_exited():
	highlight_street('bushie_court','41098',false)

func _on_dahill_place_area_mouse_entered():
	highlight_street('dahill_place','41098',true)
func _on_dahill_place_area_mouse_exited():
	highlight_street('dahill_place','41098',false)

func _on_deane_court_area_mouse_entered():
	highlight_street('deane_court','41098',true)
func _on_deane_court_area_mouse_exited():
	highlight_street('deane_court','41098',false)

func _on_edgemoor_lane_area_mouse_entered():
	highlight_street('edgemoor_lane','41098',true)
func _on_edgemoor_lane_area_mouse_exited():
	highlight_street('edgemoor_lane','41098',false)

func _on_larstan_drive_area_mouse_entered():
	highlight_street('larstan_drive','41098',true)
func _on_larstan_drive_area_mouse_exited():
	highlight_street('larstan_drive','41098',false)

func _on_linmar_court_area_mouse_entered():
	highlight_street('linmar_court','41098',true)
func _on_linmar_court_area_mouse_exited():
	highlight_street('linmar_court','41098',false)

func _on_mayapple_place_area_mouse_entered():
	highlight_street('mayapple_place','41098',true)
func _on_mayapple_place_area_mouse_exited():
	highlight_street('mayapple_place','41098',false)

func _on_sano_street_area_mouse_entered():
	highlight_street('sano_street','41098',true)
func _on_sano_street_area_mouse_exited():
	highlight_street('sano_street','41098',false)

func _on_stanby_court_area_mouse_entered():
	highlight_street('stanby_court','41098',true)
func _on_stanby_court_area_mouse_exited():
	highlight_street('stanby_court','41098',false)

func _on_vengo_court_area_mouse_entered():
	highlight_street('vengo_court','41098',true)
func _on_vengo_court_area_mouse_exited():
	highlight_street('vengo_court','41098',false)

func _on_vicki_court_area_mouse_entered():
	highlight_street('vicki_court','41098',true)
func _on_vicki_court_area_mouse_exited():
	highlight_street('vicki_court','41098',false)
	
#############################################################
#############################################################
#############################################################

#41099#


func _on_carlyn_hill_drive_area_mouse_entered():
	highlight_street('carlyn_hill_drive','41099',true)
func _on_carlyn_hill_drive_area_mouse_exited():
	highlight_street('carlyn_hill_drive','41099',false)

func _on_crossroads_center_way_area_mouse_entered():
	highlight_street('crossroads_center_way','41099',true)
func _on_crossroads_center_way_area_mouse_exited():
	highlight_street('crossroads_center_way','41099',false)

func _on_diehl_court_area_mouse_entered():
	highlight_street('diehl_court','41099',true)
func _on_diehl_court_area_mouse_exited():
	highlight_street('diehl_court','41099',false)

func _on_moray_lane_area_mouse_entered():
	highlight_street('moray_lane','41099',true)
func _on_moray_lane_area_mouse_exited():
	highlight_street('moray_lane','41099',false)

func _on_robinwood_lane_area_mouse_entered():
	highlight_street('robinwood_lane','41099',true)
func _on_robinwood_lane_area_mouse_exited():
	highlight_street('robinwood_lane','41099',false)

func _on_spring_lane_area_mouse_entered():
	highlight_street('spring_lane','41099',true)
func _on_spring_lane_area_mouse_exited():
	highlight_street('spring_lane','41099',false)


