class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var last_velocity_normalized : Vector2 = Vector2.ZERO

@onready var animation_player : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

signal DirectionChanged(new_direction : Vector2) 

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	pass


func _process(delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

func _physics_process(delta: float) -> void:
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
