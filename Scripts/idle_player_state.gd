class_name IdlePlayerState

extends PlayerMovementState

func update(delta):
	if Global.player.velocity.length() > 0.0:
		transition.emit("WalkingPlayerState")
