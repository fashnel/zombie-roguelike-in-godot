class_name EnemyStateDestroy extends EnemyState


@export var anim_name : String = "idle"
@export var destroy_time : float = 0.2
@export var speed_knockback : float = 150.0
@export var decelerate_speed : float = 10.0

@export var hit_sound : AudioStream
@onready var audio : AudioStreamPlayer2D = $"../../AudioStreamPlayer2D"

@export_category("AI")
var _timer : float = 0.0
var _direction : Vector2
var _damage_position : Vector2
var _audio_finished : bool

func init() -> void:
	interruptible = false
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass 


func Enter() -> void:
	enemy.invulnerable = true
	enemy.hurt_box.monitoring = false
	_audio_finished = false
	_timer = destroy_time
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.animation_player.modulate = Color(2.285, 0.794, 0.688)
	audio.stream = hit_sound
	audio.pitch_scale = randf_range(0.8, 1.2)
	audio.play()
	audio.finished.connect(_on_audio_finished)

	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -speed_knockback
	
	enemy.UpdateAnimation(anim_name)
	pass
	
	
func Exit() -> void:
	audio.finished.disconnect(_on_audio_finished)
	pass
	
	
func Process(_delta : float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		enemy.animation_player.modulate = Color.WHITE
	if _audio_finished:
		enemy.queue_free()
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
	
func Physics(_delta : float) -> EnemyState:
	return null
	
	
func _on_enemy_destroyed(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)
	
func _on_audio_finished() -> void:
	_audio_finished = true
