extends Area2D

var dampening = 0.03
var velocity = 0
var target_height = 0
var spring_constant = 0.015
var velocity_div = 40
var bottom = 0


#Enregistre position original
func _ready():
	target_height = position.y

func _process(delta):
	#La loi de hooke
	var height = position.y
	var x = height - target_height
	var loss = -dampening * velocity
	var force = - spring_constant * x + loss
	velocity += force
	position.y += velocity
	

#applique force sur entré et sortie d'un rigidbody
func _on_body_entered(body):
	if body is RigidBody2D:
		velocity = body.linear_velocity.y / velocity_div

func _on_body_exited(body):
	if body is RigidBody2D:
		velocity = body.linear_velocity.y / velocity_div
