extends Node3D

# Shows variables in editor
@export var tileStart:PackedScene
@export var tileEnd:PackedScene
@export var tileStraight:PackedScene
@export var tileCorner:PackedScene
@export var tileCrossroads:PackedScene
@export var tileEnemy:PackedScene
@export var tileEmpty:Array[PackedScene]

@export var basicEnemy:PackedScene

@onready var cam = $Camera3D
var RAYCAST_LENGTH:float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_completeGrid()
	
	for i in range(10):
		await get_tree().create_timer(2).timeout
		print("Creating enemy")
		var enemy = basicEnemy.instantiate()
		add_child(enemy)

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var spaceState = get_world_3d().direct_space_state
		var mousePos:Vector2 = get_viewport().get_mouse_position()
		var origin:Vector3 = cam.project_ray_origin(mousePos)
		var end:Vector3 = origin + cam.project_ray_normal(mousePos) * RAYCAST_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var rayResult:Dictionary = spaceState.intersect_ray(query)
		if rayResult.size() > 0:
			var co3d:CollisionObject3D = rayResult.get("collider")
			print(co3d.get_groups()) 

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
	
