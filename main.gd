# main ver 1.1

extends Node2D

const min_time = 0.9
const max_time = 3.2

const ruler_y0 = 80

const Pig = preload("res://global/pig.tscn")

var tiempo   
var start   
var time_left
var cerdo     

func nuevo_tiempo():
	tiempo = Global.rndf(min_time, max_time) 
	$reto.text = "t = " + Global.str_units(tiempo, "secs")

func compute_score():
	return Global.get_score(abs(Global.get_dur(start) - tiempo), max_time, 50)

func update_score(value):
	Global.score += value
	$score.text = "score = " + str(Global.score)

func start_fall():
	start = Global.get_clock()

func pos_barril():
	var xb = Global.rndi(450, 950)
	if xb in range(600, 800):
		return pos_barril()
	return Vector2(xb, 566)
	
func reset():
	nuevo_tiempo()
	$aviso.text = ""
	$flecha.visible = false
	$level.text = "Level: "+str(Global.level)
	cerdo = Pig.instance() 
	cerdo.connect("crash", self, "pig_crash")
	cerdo.connect("kill_pig", self, "destroy_pig")
	cerdo.connect("start_falling", self, "start_fall")
	add_child(cerdo) 
	$barril.position = pos_barril()

func pig_fall():
	start = Global.get_clock()

func pig_crash(body):
	if body == "platform": 
		var d = Global.get_distance(tiempo) 
		var dur = Global.get_dur(start)
		$flecha.position.y = Global.pix_distance(d, ruler_y0)
		$flecha.visible = true
		$aviso.text = 'Impacto: ' + Global.str_units(dur, 'secs')
	elif body == "barril": 
		update_score(50)
	elif body == "piso":
		update_score(compute_score())

func _ready():
	$music.stop()
	if Global.inicio:
		get_tree().change_scene("res://screens/portada.tscn")
		Global.inicio = false
	else:
		$music.play()
		reset()

func _process(_delta):
	var t = int($timer.time_left)
	if t != time_left:
		time_left = t
		$time.text  = "Time: " + str(t)
	var y = $piso.position.y
	var r = $piso.rotation_degrees
	if Input.is_action_pressed("ui_up"):
		if y > 78: $piso.position.y = y - 1	
	elif Input.is_action_pressed("ui_down"):
		if y < 560: $piso.position.y = y + 1
	elif Input.is_action_pressed("ui_right"):
		if r < 80: $piso.rotation_degrees = r + 1
	elif Input.is_action_pressed("ui_left"):
		if r > -80: $piso.rotation_degrees = r - 1
	elif Input.is_action_pressed("ui_accept"): 
		if cerdo.position == cerdo.pos0:
			cerdo.fall()
	elif Input.is_action_pressed("ui_cancel"): 
		Global.level += 1
		get_tree().change_scene("res://screens/portada.tscn")

func destroy_pig():
	cerdo.queue_free() # kill pig
	reset()

func _on_timer_timeout():
	get_tree().change_scene("res://screens/pregunta.tscn")
