extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

var _mouseInput : bool = false
var _rotationInput : float
var _tiltInput : float
var _mouseRotation : Vector3
var _playerRotation : Vector3
var _cameraRotation : Vector3
@export var MouseSensitivity : float = 0.5
@export var TiltLowerLimit := deg_to_rad(-90.0)
@export var TileUpperLimit := deg_to_rad(90.0)
@export var CameraController : Camera3D

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
		
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


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
	_mouseInput = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouseInput:
		_rotationInput = -event.relative.x * MouseSensitivity
		_tiltInput = -event.relative.y * MouseSensitivity


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	update_camera(delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
