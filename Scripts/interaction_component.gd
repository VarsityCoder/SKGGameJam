class_name InteractionComponent extends Node

@export var mesh : MeshInstance3D
@export var context : String
@export var override_icon : bool
@export var new_icon : Texture2D

var highlight_material = preload("res://Assets/InteractableHighlight.tres")

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	connect_parent()


func connect_parent() -> void:
	parent.add_user_signal("focused")
	parent.add_user_signal("unfocused")
	parent.add_user_signal("interacted")
	parent.connect("focused", Callable(self, "in_range"))
	parent.connect("unfocused", Callable(self, "not_in_range"))
	parent.connect("interacted", Callable(self, "on_interact"))
	

func in_range() -> void:
	mesh.material_overlay = highlight_material
	Global.ui_context.update_content(context)
	Global.ui_context.update_icon(new_icon, override_icon)

func not_in_range() -> void:
	mesh.material_overlay = null
	Global.ui_context.reset()

func on_interact() -> void:
	print(parent.name)

func set_default_mesh() -> void:
	if mesh:
		pass
	else:
		for i in parent.get_children():
			if i is MeshInstance3D:
				mesh = i
				
			
