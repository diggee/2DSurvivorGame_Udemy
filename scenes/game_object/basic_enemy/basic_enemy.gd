extends CharacterBody2D


@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign > 0:
		visuals.scale.x = 1
	else:
		visuals.scale.x = -1 


func _ready():
	$HurtBoxComponent.hit.connect(on_hit)
	
	
func on_hit():
	$AudioStreamPlayer2D.play()
