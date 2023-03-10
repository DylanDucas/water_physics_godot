extends Area2D

@export var distance_spring = 32

#Vitesses de dissipation des vagues
@export var passes = 2

var spread = 0.01

var spring = preload("res://water_spring.tscn")
var bottom = 0
var spring_array = []
var first_spring
var last_spring

func _ready():
	#Prend la scale puis la remplace par la collision size
	$CollisionShape2D.scale = scale
	$CollisionShape2D.position = scale / 2
	
	var nb_spring = round(scale.x / distance_spring)
	
	scale = Vector2(1,1)
	if nb_spring == 0:
		nb_spring = 1
		
	#Crée les springs et enregistre le premier puis le dernier
	for i in nb_spring + 1:
		var s = spring.instantiate()
		$water_springs.add_child(s)
		s.position.x = i * distance_spring
		spring_array.append(s)
		if i == 0:
			first_spring = s
		elif i == nb_spring:
			last_spring = s
			bottom = s.position.y + $CollisionShape2D.scale.y

func update_polygon():
	var points_array = []
	#met la position de tout les points dans un array
	for i in spring_array:
		points_array.append(i.position)
	
	#Génère les vagues
	var left_deltas = []
	var right_deltas = []
	for i in range (spring_array.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in range(passes):
		for i in range(spring_array.size()):
			if i > 0:
				left_deltas[i] = spread * (spring_array[i].position.y - spring_array[i-1].position.y)
				spring_array[i-1].velocity += left_deltas[i]
			if i < spring_array.size()-1:
				right_deltas[i] = spread * (spring_array[i].position.y - spring_array[i+1].position.y)
				spring_array[i+1].velocity += right_deltas[i]
	
	#Les deux points bas du polygon puis le transforme en packedVector. L'ORDRE DES POINTS EST IMPORTANT
	points_array.append(Vector2(last_spring.position.x,bottom))
	points_array.append(Vector2(first_spring.position.x,bottom))
	points_array = PackedVector2Array(points_array)
	#Update le polygon
	$polygon.set_polygon(points_array)
	$polygon.set_uv(points_array)

func _process(delta):
	update_polygon()
