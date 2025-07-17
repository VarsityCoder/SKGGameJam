class_name SprintingPlayerState

extends PlayerMovementState

@export var TopAnimSpeed : float = 1.6

func enter() -> void:
	Global.player._speed = Global.player.SPEED_SPRINTING


func _input(event) -> void:
	if event.is_action_released("sprint"):
		transition.emit("WalkingPlayerState")
