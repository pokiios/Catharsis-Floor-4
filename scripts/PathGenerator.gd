extends Node
class_name PathGenerator

## private variables

var _loopCount:int

var pathConfig:PathGeneratorConfig = preload("res://resources/basic_path_config.res")

var _pathRoute:Array[Vector2i]

func _init():
	generatePath(pathConfig.addLoops)
	
	while(_pathRoute.size() < pathConfig.minPathSize or _pathRoute.size() > pathConfig.maxPathSize
	or _loopCount < pathConfig.minLoops or _loopCount > pathConfig.maxLoops):
		generatePath(pathConfig.addLoops)

func generatePath(addLoops:bool = false):
	_pathRoute.clear()
	randomize()
	_loopCount = 0
	
	var x = 0
	var y = int(pathConfig.mapHeight/2)
	
	while x < pathConfig.mapLength:
		if !_pathRoute.has(Vector2i(x,y)):
			_pathRoute.append(Vector2i(x,y))
			
		var choice:int = randi_range(0,2)
		
		if choice == 0 || x < 2 || x % 2 == 0 || x == pathConfig.mapLength - 1:
			x += 1
		elif choice == 1 && y < pathConfig.mapHeight - 2 && !_pathRoute.has(Vector2i(x,y+1)):
			y += 1
		elif choice == 2 && y > 1 && !_pathRoute.has(Vector2i(x,y-1)):
			y -= 1
			
	if addLoops:
		_addLoops()
		
	return _pathRoute
	
func getTileScore(index:int) -> int:
	# init vars
	var score:int = 0
	var x = _pathRoute[index].x
	var y = _pathRoute[index].y
	
	# define score based on how many tiles are adjacent to current tile
	score += 1 if _pathRoute.has(Vector2i(x,y-1)) else 0
	score += 2 if _pathRoute.has(Vector2i(x+1,y)) else 0
	score += 4 if _pathRoute.has(Vector2i(x,y+1)) else 0
	score += 8 if _pathRoute.has(Vector2i(x-1,y)) else 0
	
	return score

func getPathRoute() -> Array[Vector2i]:
	return _pathRoute

## Returns specific Tile at given index
func getPathTile(index:int) -> Vector2i:
	return _pathRoute[index]

func _addLoops():
	var loopsGenerated:bool = true
	
	while loopsGenerated:
		loopsGenerated = false
		for i in range(_pathRoute.size()):
			var loop:Array[Vector2i] = _isLoopOption(i)
			if loop.size() > 0:
				loopsGenerated = true
				for j in range(loop.size()):
					_pathRoute.insert(i+1+j, loop[j])

func _isLoopOption(index:int) -> Array[Vector2i]:
	var x:int = _pathRoute[index].x
	var y:int = _pathRoute[index].y
	var returnPath:Array[Vector2i]
	
	#Yellow
	if (x < pathConfig.mapLength - 1 and y > 1
		and _tileLocFree(x, y-3) and _tileLocFree(x+1, y-3) and _tileLocFree(x+2, y-3)		
		and _tileLocFree(x-1, y-2) and _tileLocFree(x, y-2) and _tileLocFree(x+1, y-2) and _tileLocFree(x+2, y-2) and _tileLocFree(x+3, y-2)
		and _tileLocFree(x-1, y-1) and _tileLocFree(x, y-1) and _tileLocFree(x+1, y-1) and _tileLocFree(x+2, y-1) and _tileLocFree(x+3, y-1)
		and _tileLocFree(x+1,y) and _tileLocFree(x+2,y) and _tileLocFree(x+3,y)
		and _tileLocFree(x+1,y+1) and _tileLocFree(x+2,y+1)):
		returnPath = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y-1), Vector2i(x+2,y-2), Vector2i(x+1,y-2), Vector2i(x,y-2), Vector2i(x,y-1)]

		if _pathRoute[index-1].y > y:
			returnPath.reverse()
			
		_loopCount += 1
		returnPath.append(Vector2i(x,y))
	#Blue
	elif (x > 2 and y > 1
			and _tileLocFree(x, y-3) and _tileLocFree(x-1, y-3) and _tileLocFree(x-2, y-3)		
			and _tileLocFree(x-1, y) and _tileLocFree(x-2, y) and _tileLocFree(x-3, y)
			and _tileLocFree(x+1, y-1) and _tileLocFree(x, y-1) and _tileLocFree(x-2, y-1) and _tileLocFree(x-3, y-1)
			and _tileLocFree(x+1, y-2) and _tileLocFree(x, y-2) and _tileLocFree(x-1, y-2) and _tileLocFree(x-2, y-2) and _tileLocFree(x-3, y-2)
			and _tileLocFree(x-1, y+1) and _tileLocFree(x-2, y+1)):
		returnPath = [Vector2i(x,y-1), Vector2i(x,y-2), Vector2i(x-1,y-2), Vector2i(x-2,y-2), Vector2i(x-2,y-1), Vector2i(x-2,y), Vector2i(x-1,y)]

		if _pathRoute[index-1].x > x:
			returnPath.reverse()

		_loopCount += 1
		returnPath.append(Vector2i(x,y))
	#Red
	elif (x < pathConfig.mapLength - 1 and y < pathConfig.mapHeight - 2
			and _tileLocFree(x, y+3) and _tileLocFree(x+1, y+3) and _tileLocFree(x+2, y+3)		
			and _tileLocFree(x+1, y-1) and _tileLocFree(x+2, y-1)
			and _tileLocFree(x+1, y) and _tileLocFree(x+2, y) and _tileLocFree(x+3, y)
			and _tileLocFree(x-1, y+1) and _tileLocFree(x, y+1) and _tileLocFree(x+2, y+1) and _tileLocFree(x+3, y+1)
			and _tileLocFree(x-1, y+2) and _tileLocFree(x, y+2) and _tileLocFree(x+1, y+2) and _tileLocFree(x+2, y+2) and _tileLocFree(x+3, y+2)):
		returnPath = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y+1), Vector2i(x+2,y+2), Vector2i(x+1,y+2), Vector2i(x,y+2), Vector2i(x,y+1)]

		if _pathRoute[index-1].y < y:
			returnPath.reverse()
		
		_loopCount += 1
		returnPath.append(Vector2i(x,y))
	# Brown
	elif (x > 2 and y < pathConfig.mapLength-2
			and _tileLocFree(x, y+3) and _tileLocFree(x-1, y+3) and _tileLocFree(x-2, y+3)
			and _tileLocFree(x-1, y-1) and _tileLocFree(x-2, y-1)
			and _tileLocFree(x-1, y) and _tileLocFree(x-2, y) and _tileLocFree(x-3, y)
			and _tileLocFree(x+1, y+1) and _tileLocFree(x, y+1) and _tileLocFree(x-2, y+1) and _tileLocFree(x-3, y+1)
			and _tileLocFree(x+1, y+2) and _tileLocFree(x, y+2) and _tileLocFree(x-1, y+2) and _tileLocFree(x-2, y+2) and _tileLocFree(x-3, y+2)):
		returnPath = [Vector2i(x,y+1), Vector2i(x,y+2), Vector2i(x-1,y+2), Vector2i(x-2,y+2), Vector2i(x-2,y+1), Vector2i(x-2,y), Vector2i(x-1,y)]

		if _pathRoute[index-1].x > x:
			returnPath.reverse()
		
		_loopCount += 1
		returnPath.append(Vector2i(x,y))
		
	return returnPath

func _tileLocTaken(x:int, y:int) -> bool:
	return _pathRoute.has(Vector2i(x,y))

func _tileLocFree(x:int, y:int) -> bool:
	return !_pathRoute.has(Vector2i(x,y))

func getLoopCount() -> int:
	return _loopCount

