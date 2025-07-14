extends CharacterBody3D


@export var SPEED_DEFAULT = 5.0
@export var JUMP_VELOCITY = 4.5
@export var SPEED_CROUCH : float = 2.0

var _mouseInput : bool = false
var _rotationInput : float
var _tiltInput : float
var _mouseRotation : Vector3
var _playerRotation : Vector3
var _cameraRotation : Vector3
var _isCrouching : bool = false
var _speed : float

@export_range(5, 10, 0.1) var CrouchSpeed : float = 7.0
@export var MouseSensitivity : float = 0.5
@export var TiltLowerLimit := deg_to_rad(-90.0)
@export var TileUpperLimit := deg_to_rad(90.0)
@export var CameraController : Camera3D
@export var AnimationPlayer3d : AnimationPlayer
@export var CrouchShapecast : Node3D
@export var ToggleCrouch : bool = true

func _input(event):
	if event.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("crouch") and is_on_floor():
		toggle_crouch()
	if event.is_action_pressed("crouch") and _isCrouching == false and is_on_floor() and ToggleCrouch == false:
		crouching(true)
	if event.is_action_released("crouch") and ToggleCrouch == false:
		if CrouchShapecast.is_colliding() == false:
			crouching(false)
		elif CrouchShapecast.is_colliding() == true:
			uncrouch_check()
		
		
func _ready():
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_speed = SPEED_DEFAULT
	CrouchShapecast.add_exception($".")

func uncrouch_check():
	if CrouchShapecast.is_colliding() == false:
		crouching(false)
	if CrouchShapecast.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch_check()


func update_camera(delta):
	_mouseRotation.x += _tiltInput * delta
	_mouseRotation.x = clamp(_mouseRotation.x, TiltLowerLimit, TileUpperLimit)
	_mouseRotation.y += _rotationInput * delta
	
	_playerRotation = Vector3(0.0, _mouseRotation.y, 0.0)
	_cameraRotation = Vector3(_mouseRotation.x, 0.0, 0.0)
	
	CameraController.transform.basis = Basis.from_euler(_cameraRotation)
	CameraController.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_playerRotation)
	
	_rotationInput = 0.0
	_tiltInput = 0.0
	
func _unhandled_input(event: InputEvent):
	_mouseInput = event is InputEventMouseMotion
	if _mouseInput:
		_rotationInput = -event.relative.x * MouseSensitivity
		_tiltInput = -event.relative.y * MouseSensitivity


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	update_camera(delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and _isCrouching == false:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)

	move_and_slide()

func toggle_crouch():
	if _isCrouching == true and CrouchShapecast.is_colliding() == false:
		crouching(false)
	elif _isCrouching == false:
		crouching(true)	

func crouching(state : bool):
	match state:
		true:
			AnimationPlayer3d.play("Crouch", 0, CrouchSpeed)
			set_movement_speed("crouching")
		false:
			AnimationPlayer3d.play("Crouch", 0, -CrouchSpeed, true)
			set_movement_speed("default")
			
	

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "Crouch":
		_isCrouching = !_isCrouching

func set_movement_speed(state : String):
	match state:
		"default":
			_speed = SPEED_DEFAULT
		"crouching":
			_speed = SPEED_CROUCH
