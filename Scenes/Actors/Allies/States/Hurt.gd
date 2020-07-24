extends StateBase


func enter_state():
	var anim_player : AnimationPlayer = owner.get_node_or_null("AnimationPlayer")
	
	anim_player.play("RedFlash")
	
	yield(anim_player, "animation_finished")
	states_machine.set_state("Idle")


func exit_state():
	owner.emit_signal("hurt_animation_finished")
