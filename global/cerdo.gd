# cerdo
extends RigidBody2D

signal start_falling
signal crash(body)
signal kill_pig

const pos0 = Vector2(718, 58)   # start-game reset position

onready var first_hit = false

func fall():
	emit_signal("start_falling")
	gravity_scale = 1 # activar caida cerdito
	angular_velocity = 12 # vel. rotacion todo:click-time = force
	sleeping = false # move
	$click.play() # sonido click

func _ready():
	position = pos0
	sleeping = true      # pause: freeze movement
	gravity_scale = 0    # desactivate forces
	rotation_degrees = 0 # reset angle
	position = pos0      # reset to initial pos
	first_hit = false
	set_pickable(true) # activate pig touch
	$fade.interpolate_property($image, 'modulate', $image.get_modulate(),
		Color(1, 1, 1, 0), 0.2, Tween.TRANS_SINE, Tween.EASE_IN)

func _on_onscreen_screen_exited():
	emit_signal("crash", "suelo")
	#$ouch.pitch_scale = 1.5
	$ouch.play()

func _on_cerdo_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton: 
		fall()
		
func _on_cerdo_body_entered(body):
	if body.name == "barril":
		$ouch.pitch_scale = 0.75
		$ouch.play()
		$fade.start()
		emit_signal("crash", body.name)
		return
	if not $hit.playing:
		$hit.play() # audio golpe cerdito
		emit_signal("crash", "platform")
	if body.name == "piso" and first_hit == false:
		first_hit = true
		emit_signal("crash", body.name)

func _on_ouch_finished():
	emit_signal("kill_pig")

func _on_fade_tween_completed(_object, _key):
	emit_signal("kill_pig")
