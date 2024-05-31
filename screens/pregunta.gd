# pregunta

extends Control

const preg = [
	"¿Quién propuso que los cuerpos más pesados caen primero al suelo?",
	"La caída libre de los cuerpos es proporcional a:",
	"¿Qué tema de Física estudia el movimiento al caer el personaje?",
	"¿Qué principio de la Física se aplica en este juego?",
	"Para d=kt\u00b2 expresada en metros (m)\n¿Cuáles serán las unidades para la constante k?",
	"¿A qué tipo de movimiento pertenece la caída libre?",
	"Un objeto en caída libre se caracteriza por tener:",
	"La distancia que cae un objeto es directamente proporcional a:",
	"Si para t=1s tenemos d=1u\n¿Cuánto vale d para t=3s?",
]

const pr = [
	["Aristóteles", "Galileo", "Juan Filopón", "Averroes"],
	["El tiempo", "El peso", "El espacio", "La gravedad"],
	["Cinemática", "Mecánica", "Estática", "Dinámica"],
	["Caída Libre", "Leyes de Newton", "Ley de la Inercia", "Tiro Parabólico"],
	["m/s", "m/s\u00b2", "m", "1/s\u00b2"],
	["Rectílineo uniformemente acelerado", "Rectílineo uniforme", "Circular uniforme", "Tiro parabólico"],
	["Una aceleración constante", "Una velocidad constante", "Una velocidad promedio", "Un desplazamiento uniforme"],
	["t\u00b2", "2t", "4t", "t\u2074"],
	["d=9u", "d=3u", "d=10u", "d=6u"],
]

var idxOK = 0
var sel = -1

onready var ok = false
onready var rojo  = preload("res://images/rojo.png")
onready var verde = preload("res://images/verde.png")

func get_preg():
	var np = Global.rndi(0, len(preg)-1)
	if Global.prev != -1 and Global.prev == np:
		return get_preg()
	Global.prev = np
	return np

func _ready():
	var np = get_preg()
	$box/preg.text = preg[np]
	var ops = pr[np]
	var rOK = ops[0]
	ops.shuffle()
	for i in range(len(ops)):
		var r = ops[i]
		$box/opciones.set_item_text(i, " "+str(i+1)+") "+r)
		if r == rOK:
			idxOK = i
	for i in range(0,$box/opciones.get_item_count()): 
		$box/opciones.set_item_tooltip_enabled(i, false)

func _on_opciones_item_selected(index):
	if sel != -1: 
		return
	sel = index
	ok = true
	$click.play()
	for i in range(0,$box/opciones.get_item_count()):
		$box/opciones.set_item_disabled(i, true)
	if sel == idxOK: 
		$box/opciones.set_item_icon(sel, verde)
	else:
		$box/opciones.set_item_icon(sel, rojo)

func _on_seguir_pressed():
	if ok == false: 
		$Alert.popup_centered() 
		return
	if sel == idxOK: 
		Global.nivel += 1
		if Global.nivel == 3:
			get_tree().change_scene("res://levels/nivel3.tscn")
		else:
			get_tree().change_scene("res://levels/nivel2.tscn")
	else:
		Global.nivel -= 1
		get_tree().change_scene("res://levels/nivel1.tscn")
