extends CanvasLayer

var health : Array[HP] = []

func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HP:
			health.append(child)
			child.visible = false
	pass 
	

func update_hp(_lost_hp : int) -> void:
	update_max_hp()
	for i in _lost_hp:
		health[i].visible = false
	pass

func update_max_hp() -> void:
	for i in health.size():
		health[i].visible = true
	pass
	
