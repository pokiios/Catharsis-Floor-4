extends VBoxContainer

@export var sceneToLoad: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func onPlayButtonPressed() -> void:
	get_tree().change_scene_to_packed(sceneToLoad)



func onQuitButtonPressed() -> void:
	get_tree().quit()
