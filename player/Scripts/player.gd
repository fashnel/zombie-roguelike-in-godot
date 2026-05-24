class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var last_velocity_normalized : Vector2 = Vector2.ZERO
var invulnerable : bool = false
var hp : int = 10
var max_hp : int = 10

@onready var animation_player : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var hit_box : HitBox = $HitBox

signal DirectionChanged(new_direction : Vector2) 
signal player_damaged(hurt_box : HurtBox)

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect(_take_damage)
	update_hp(99)
	pass


func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

func _physics_process(_delta: float) -> void:
	move_and_slide()



func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if abs(direction.x) > 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	else:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	return true

 
func UpdateAnimation(state: String) -> void:
	animation_player.play( state + "_" + AnimDirection() )


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"

func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(99)
	pass
	

func update_hp(delta : int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	var lost_hp = max_hp - hp
	PlayerHud.update_hp(lost_hp)
	pass
	

func make_invulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	pass
