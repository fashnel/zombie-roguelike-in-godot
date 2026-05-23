class_name State_Stun extends State

@export var knockback_speed : float = 100.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0
@export var stun_time : float = 0.2

var hurt_box : HurtBox
var direction : Vector2
var next_state : State = null
var _timer : float

@onready var idle : State = $"../Idle"

func init() -> void:
	player.player_damaged.connect(_player_damaged)
	

func Enter() -> void:
	_timer = stun_time
	
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed 
	player.SetDirection() 
	player.make_invulnerable(invulnerable_duration)
	player.animation_player.modulate = Color(2.285, 0.794, 0.688)
	pass
	
	
func Exit() -> void:
	next_state = null
	pass
	
	
func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	_timer -= _delta
	if _timer <= 0:
		player.animation_player.modulate = Color.WHITE
		next_state = idle
	return next_state
	
	
func Physics(_delta : float) -> State:
	return null
	
	
func HandleInput(_event : InputEvent) -> State:
	return null
	
	
func _player_damaged(_hurt_box : HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState(self)
	pass
