class_name WalkingPlayerState

extends State

func enter() -> void:
	Global.player._speed = Global.player.SPEED_DEFAULT

func update(delta):
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")

func _input(event) -> void:
	if event.is_action_pressed("sprint") and Global.player.is_on_floor():
		transition.emit("SprintingPlayerState")
	
