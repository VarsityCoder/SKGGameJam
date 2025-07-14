class_name PlayerMovementState

extends State

var PLAYER : Player

func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player

func _process(delta: float) -> void:
	pass
