extends Node3D

var curve3d: Curve3D

var enemyProgress:float = 0
var enemySpeed:float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curve3d = Curve3D.new()
	for i in PathGenInstance.getPathRoute():
		curve3d.add_point(Vector3(i.x, 0, i.y))
		
		$Path3D.curve = curve3d
		$Path3D/PathFollow3D.progress_ratio = 0

func _onSpawningStateEntered() -> void:
	$AnimationPlayer.play("spawn")
	await $AnimationPlayer.animation_finished
	$EnemyStateChart.send_event("toTravelling")
	

func _onTravellingStateProcessing(delta) -> void:
	enemyProgress += delta * enemySpeed
	$Path3D/PathFollow3D.progress_ratio = enemyProgress
	if enemyProgress >= PathGenInstance.getPathRoute().size():
		print("Stop!")
