extends Node2D

onready var rng   = RandomNumberGenerator.new()
onready var score = 0
onready var level = 1
onready var prev  = -1 
onready var tiempo = 0
onready var max_time = 3.2
onready var min_time = 1.41
onready var inicio = true
onready var nivel = 1


func get_clock(): return OS.get_ticks_msec()

func rndf(x,y): return rng.randf_range(x, y)
func rndi(x,y): return rng.randi_range(x, y)

func round_dec(x): return floor(x * 10) / 10
func get_dur(ini): return round_dec((get_clock() - ini) * 1e-3)

func get_score(err, mxtime, pts): 
	return round((1.0 - inverse_lerp(0, mxtime, err)) * pts)
func str_units(x, units=''): 
	return str(round_dec(x)) + " " + units

func get_distance(t): return 9.81 * t * t / 2 
func pix_distance(d, y0): return 9 * d + y0 

func compute_score(start):
	var dur = get_dur(start)
	var err = abs(dur - tiempo)
	return get_score(err, max_time, 50)

func compute_tiempo():
	tiempo = floor(rng.randf_range(min_time, max_time) * 10) / 10
	return tiempo

func get_correct_height():
	return (9.8*(tiempo*tiempo)*9.8)/2

func calc_pos():
	var response=0
	response = rng.randf_range(500, 930)
	while(660<response && response<800):
		response = rng.randf_range(500, 930)
	return response

func _ready():
	rng.randomize()
