@tool
class_name PickUpComponent extends Node

@export var pickup_distance : Vector3 = Vector3(0,0,-1)

var parent
var object : Node3D
var picked_up : bool = false

const pickup_lerp : float = 0.3

func _ready() -> void:
	parent = get_parent()
	if parent is InteractionComponent:
		parent.player_interacted.connect(update_state)

func _get_configuration_warnings() -> PackedStringArray:
	if parent is not InteractionComponent:
		return ["This node must have a InteractionComponent as the parent"]
	else:
		return[]

func _notification(what: int) -> void:
	if what == NOTIFICATION_ENTER_TREE:
		parent = get_parent()
		update_configuration_warnings()

func update_state(interactable: Node3D) -> void:
	if picked_up:
		picked_up = false
		object = null
		interactable.freeze = false
	else:
		object = interactable
		interactable.freeze = true
		picked_up = true

func _physics_process(delta: float) -> void:
	if picked_up:
		var camera_transform = Global.player.CameraController.global_transform
		object.global_transform = object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), pickup_lerp)
