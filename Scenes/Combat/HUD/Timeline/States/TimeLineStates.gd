extends StateMachine

func _ready():
	yield(owner, "ready")
	set_state("Idle")
