class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready() -> void:
	state_machine.Initialize(self)
	pass


func _process(delta: float) -> void:
	var raw_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var raw_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if raw_x != 0:
		direction = Vector2(sign(raw_x), 0)
	elif raw_y != 0:
		direction = Vector2(0, sign(raw_y))
	else:
		direction = Vector2.ZERO


func _physics_process(delta: float) -> void:
	move_and_slide()


func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	 
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	animation_player.flip_h = true if cardinal_direction == Vector2.RIGHT else false
	return true


 
func UpdateAnimation(state: String) -> void:
	animation_player.play( state + "_" + AnimDirection() )


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
