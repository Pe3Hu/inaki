extends Node2D
class_name Pas


var dancer
var part
var chesspiece
var layer


func set_vars(data_) -> void:
	dancer = data_.dancer
	part = data_.part
	chesspiece = data_.chesspiece
	layer = data_.layer


func get_ends():
	var start = dancer.beacons.back()
	var ends = [start]
	var windroses = start.neighbors[layer]
	
	if windroses.size() > 0:
		match chesspiece:
			"pawn":
				pass
			"rook":
				for windrose in windroses:
					if windrose.length() == 1:
						var beacons = get_beacons_line(start, windrose)
						ends.append_array(beacons)
			"bishop":
				for windrose in windroses:
					if windrose.length() == 2:
						var beacons = get_beacons_line(start, windrose)
						ends.append_array(beacons)
			"queen":
				for windrose in windroses:
					var beacons = get_beacons_line(start, windrose)
					ends.append_array(beacons)
			"king":
				for windrose in windroses:
					var beacon = windroses[windrose]
				
					if beacon.dancers.size() == 0:
						ends.append(beacon)
			"knight":
				for windrose in windroses:
					if windrose.length() == 2:
						var beacons = get_beacons_knight(start, windrose)
						ends.append_array(beacons)
			"cat":
				for beacons in Global.obj.ballroom.arr.beacon:
					for beacon in beacons:
						if beacon.dancers.size() == 0:
							ends.append(beacon)
						
	return ends


func get_beacons_line(start_, windrose_):
	var beacon = start_
	var beacons = []
	
	while beacon.neighbors[layer].keys().has(windrose_):
		beacon = beacon.neighbors[layer][windrose_]
		
		if beacon.dancers.size() == 0:
			beacons.append(beacon)
		else:
			return beacons
	
	return beacons


func get_beacons_knight(start_,windrose_):
	var size = 2
	var beacon = start_
	var beacons = []
	
	while beacon.neighbors[layer].keys().has(windrose_) && beacons.size() < size:
		beacon = beacon.neighbors[layer][windrose_]
		beacons.append(beacon)
	
	if beacons.size() == size:
		var end = beacons.back()
		beacons = []
		
		for windrose in Global.dict.windrose:
			if windrose.length() == windrose_.length():
				if windrose != windrose_ && windrose != Global.dict.reflected_windrose[windrose_]:
					if end.neighbors[layer].keys().has(windrose):
						beacon = end.neighbors[layer][windrose]
						
						if beacon.dancers.size() == 0:
							beacons.append(beacon)
		
		return beacons
	else:
		return []
