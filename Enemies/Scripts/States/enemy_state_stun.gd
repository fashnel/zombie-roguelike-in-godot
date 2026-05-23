class_name EnemyStateStun extends EnemyState


@export var anim_name : String = "idle"
@export var stun_time : float = 0.2
@export var speed_knockback : float = 100.0
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2
var _animation_finished : bool = false

func init() -> void:
	enemy.EnemyDamaged.connect(_on_enemy_damaged)
	pass 


func Enter() -> void:
	enemy.invulnerable = true
	_timer = stun_time
	_direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.animation_player.modulate = Color(2.285, 0.794, 0.688)
	
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -speed_knockback
	
	enemy.UpdateAnimation(anim_name)
	pass
	
	
func Exit() -> void:
	enemy.invulnerable = false
	pass
	
	
func Process(_delta : float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		enemy.animation_player.modulate = Color.WHITE
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
	
func Physics(delta : float) -> EnemyState:
	return null
	
	
func _on_enemy_damaged() -> void:
	state_machine.ChangeState(self)
	
