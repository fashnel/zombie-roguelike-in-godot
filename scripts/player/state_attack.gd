class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 13.0

@onready var animation_player : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"

func Enter() -> void:
	player.UpdateAnimation("attack")
	animation_player.animation_finished.connect(EndAttack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	attacking = true
	pass
	
	
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	pass
	
func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if !attacking:
		if player.direction == Vector2.ZERO:
			return idle
		return walk
	return null
	
func Physics(_delta : float) -> State:
	return null
	
	
func HandleInput(_event : InputEvent) -> State:
	return null
	
	#_newAnimName : String
func EndAttack() -> void:
	attacking = false 
