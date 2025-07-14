extends CenterContainer

@export var DotRadius : float = 1.0
@export var DotColor : Color = Color.WHITE
@export var ReticleLines : Array[Line2D]
@export var PlayerController : CharacterBody3D
@export var ReticleSpeed : float = 0.25
@export var ReticleDistance : float = 2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	adjust_reticle_lines()

func _draw():
	draw_circle(Vector2(0,0), DotRadius, DotColor)

func adjust_reticle_lines():
	var vel = PlayerController.get_real_velocity()
	var origin = Vector3(0,0,0)
	var pos = Vector2(0,0)
	var speed = origin.distance_to(vel)
	
	ReticleLines[0].position = lerp(ReticleLines[0].position, pos + Vector2(0, -speed * ReticleDistance), ReticleSpeed)
	ReticleLines[1].position = lerp(ReticleLines[1].position, pos + Vector2(speed * ReticleDistance, 0), ReticleSpeed)
	ReticleLines[2].position = lerp(ReticleLines[2].position, pos + Vector2(0, speed * ReticleDistance), ReticleSpeed)
	ReticleLines[3].position = lerp(ReticleLines[3].position, pos + Vector2(-speed * ReticleDistance, 0), ReticleSpeed)
