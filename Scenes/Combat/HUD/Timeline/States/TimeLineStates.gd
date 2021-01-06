extends StatesMachine

func _ready():
	yield(owner, "ready")
	set_state("Idle")
