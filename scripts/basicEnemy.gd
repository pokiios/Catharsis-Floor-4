extends Node3D

var enemySettings:EnemySettings = preload("res://resources/basic_enemy_settings.res")

var attackable:bool = false
var distanceTravelled:float = 0

var path3d:Path3D
var pathFollow3d:PathFollow3D

var enemyProgress:float = 0
var enemySpeed:float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready!")
	$Path3D.curve = pathRouteToCurve3d()
	$Path3D/PathFollow3D.progress = 0

func _onSpawningStateEntered():
	print("Spawning!")
	attackable = false
	$AnimationPlayer.play("spawn")
	await $AnimationPlayer.animation_finished
	$EnemyStateChart.send_event("toTravelling")
	
func _onTravellingStateEntered() -> void:
	print("Travelling!")
	attackable = true


func _onTravellingStateProcessing(delta):
	distanceTravelled += (delta * enemySettings.speed)
	var distanceTravelledOnScreen:float = clamp(distanceTravelled, 0, PathGenInstance.getPathRoute().size()-1)
	$Path3D/PathFollow3D.progress = distanceTravelledOnScreen
	
	if distanceTravelled > PathGenInstance.getPathRoute().size()-1:
		$EnemyStateChart.send_event("toDamaging")

func _onDespawningStateEntered():
	print("Despawning.")
	$AnimationPlayer.play("despawn")
	await $AnimationPlayer.animation_finished
	$EnemyStateChart.send_event("toRemoveEnemy")

func _onRemoveEnemyStateEntered() -> void:
	print("Queue Free")
	queue_free()

func _onDamagingStateEntered() -> void:
	attackable = false
	print("Doing Damage")
	$EnemyStateChart.send_event("toDespawning")

func _onDyingStateEntered() -> void:
	print("Playing Dying Animation Now")
	$EnemyStateChart.send_event("toRemoveEnemy")
	
func pathRouteToCurve3d() -> Curve3D:
	var c3d:Curve3D = Curve3D.new()
	
	for element in PathGenInstance.getPathRoute():
		c3d.add_point(Vector3(element.x, 0.25, element.y))
	return c3d
