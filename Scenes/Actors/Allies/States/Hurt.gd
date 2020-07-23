extends StateBase


func enter_state():
	var anim_player : AnimationPlayer = owner.get_node_or_null("AnimationPlayer")
	
	anim_player.play("WhiteFlash")
	
	yield(anim_player, "animation_finished")
	states_machine.set_state("Idle")
