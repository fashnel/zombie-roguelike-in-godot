class_name EnemyStateDestroy extends EnemyState


@export var anim_name : String = "idle"
@export var destroy_time : float = 0.2
@export var speed_knockback : float = 100.0
@export var decelerate_speed : float = 10.0

@export_category("AI")
var _timer : float = 0.0
var _direction : Vector2

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass 


func Enter() -> void:
	enemy.invulnerable = true
	_timer = destroy_time
	_direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.animation_player.modulate = Color(2.285, 0.794, 0.688)

	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -speed_knockback
	
	enemy.UpdateAnimation(anim_name)
	pass
	
	
func Exit() -> void:
	pass
	
	
func Process(_delta : float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		enemy.queue_free()
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
	
func Physics(delta : float) -> EnemyState:
	return null
	
	
func _on_enemy_destroyed() -> void:
	state_machine.ChangeState(self)
	
	
