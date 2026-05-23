class_name Box extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.Damaged.connect(TakeDamage)

# _damage : int
func TakeDamage(_hurt_box : HurtBox) -> void:
	queue_free()
