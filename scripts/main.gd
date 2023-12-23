extends Node3D

# Shows variables in editor
@export var tileStart:PackedScene
@export var tileEnd:PackedScene
@export var tileStraight:PackedScene
@export var tileCorner:PackedScene
@export var tileCrossroads:PackedScene
@export var tileEnemy:PackedScene
@export var tileEmpty:Array[PackedScene]

#var PathGenInstance:PathGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_completeGrid()
	
	await get_tree().create_timer(2).timeout
	_popAlongGrid()

func _addCurvePoint(c3d:Curve3D, v3:Vector3) -> bool:
	c3d.add_point(v3)
	return true

func _popAlongGrid():
	var enemy = tileEnemy.instantiate()
	var c3d:Curve3D = Curve3D.new()
	
	for element in PathGenInstance.getPathRoute():
		c3d.add_point(Vector3(element.x, 0.4, element.y))
	
	var p3d:Path3D = Path3D.new()
	add_child(p3d)
	p3d.curve = c3d
	
	var pf3d:PathFollow3D = PathFollow3D.new()
	p3d.add_child(pf3d)
	pf3d.add_child(enemy)
	
	var currDistance:float = 0.0
	
	while currDistance < c3d.point_count-1:
		currDistance += 0.02
		pf3d.progress = clamp(currDistance, 0, c3d.point_count-1.00001)
		await get_tree().create_timer(0.01).timeout

func _completeGrid():
	
	for x in range(PathGenInstance.pathConfig.mapLength):
		for y in range(PathGenInstance.pathConfig.mapHeight):
			if !PathGenInstance.getPathRoute().has(Vector2i(x,y)):
				var tile:Node3D = tileEmpty.pick_random().instantiate()
				add_child(tile)
				tile.global_position = Vector3(x,0,y)
				tile.global_rotation_degrees = Vector3(0, randi_range(0,3)*90, 0)
	
	for i in range(PathGenInstance.getPathRoute().size()):
		var tileScore:int = PathGenInstance.getTileScore(i)
		
		var tile:Node3D = tileEmpty[0].instantiate()
		var tileRotation:Vector3 = Vector3.ZERO
		
		# start spawn
		if tileScore == 2:
			tile = tileEnd.instantiate()
			tileRotation = Vector3(0,270,0)
			
		# end spawn
		elif tileScore == 8:
			tile = tileStart.instantiate()
			tileRotation = Vector3(0,90,0)
		
		# horizontal straight
		if tileScore == 10:
			tile = tileStraight.instantiate()
			tileRotation = Vector3(0,90,0)
			
		# horizontal vertical
		elif tileScore == 1 || tileScore == 4 || tileScore == 5:
			tile = tileStraight.instantiate()
			tileRotation = Vector3(0,0,0)
			
		# right corner
		elif tileScore == 12:
			tile = tileCorner.instantiate()
			tileRotation = Vector3(0,90,0)
			
		# corner
		elif tileScore == 6:
			tile = tileCorner.instantiate()
			tileRotation = Vector3(0,180,0)
			
		# corner
		elif tileScore == 9:
			tile = tileCorner.instantiate()
			tileRotation = Vector3(0,0,0)
			
		# corner
		elif tileScore == 3:
			tile = tileCorner.instantiate()
			tileRotation = Vector3(0,270,0)
		
		elif tileScore == 15:
			tile = tileCrossroads.instantiate()
			tileRotation = Vector3(0,0,0)
		
		add_child(tile)
		tile.global_position = Vector3(PathGenInstance.getPathTile(i).x, 0, PathGenInstance.getPathTile(i).y)
		tile.global_rotation_degrees = tileRotation
	
