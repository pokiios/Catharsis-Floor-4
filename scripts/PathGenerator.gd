extends Object
class_name PathGenerator

## private variables
var _gridLength:int
var _gridHeight:int
var _loopCount:int

var _path:Array[Vector2i]

# private functions
func _init(length:int, height:int):
	_gridLength = length
	_gridHeight = height

# public functions
func generatePath(addLoops:bool = false):
	_path.clear()
	_loopCount = 0
	randomize()
	
	var x = 0
	var y = int(_gridHeight/2)
	
	while x < _gridLength:
		if !_path.has(Vector2i(x,y)):
			_path.append(Vector2i(x,y))
			
		var choice:int = randi_range(0,2)
		
		if choice == 0 || x < 2 || x % 2 == 0 || x == _gridLength - 1:
			x += 1
		elif choice == 1 && y < _gridHeight-2 && !_path.has(Vector2i(x,y+1)):
			y += 1
		elif choice == 2 && y > 1 && !_path.has(Vector2i(x,y-1)):
			y -= 1
			
	if addLoops:
		_addLoops()
		
	return _path
	
func getTileScore(index:int) -> int:
	# init vars
	var score:int = 0
	var x = _path[index].x
	var y = _path[index].y
	
	# define score based on how many tiles are adjacent to current tile
	score += 1 if _path.has(Vector2i(x,y-1)) else 0
	score += 2 if _path.has(Vector2i(x+1,y)) else 0
	score += 4 if _path.has(Vector2i(x,y+1)) else 0
	score += 8 if _path.has(Vector2i(x-1,y)) else 0
	
	return score

func getPath() -> Array[Vector2i]:
	return _path
	
func _addLoops():
	var loopsGenerated:bool = false
	
	while loopsGenerated:
		loopsGenerated = false
		for i in range(_path.size()):
			var loop:Array[Vector2i] = _isLoopOption(i)
			if loop.size() > 0:
				loopsGenerated = true
				for j in range(loop.size()):
					_path.insert(i+1+j, loop[j])

func _isLoopOption(index:int) -> Array[Vector2i]:
	var x:int = _path[index].x
	var y:int = _path[index].y
	var returnPath:Array[Vector2i]
	
	#Yellow
	if x < _gridLength-1 && y > 1 && _tileLocFree(x, y-3) && _tileLocFree(x+1, y-3) && _tileLocFree(x+2, y-3) && _tileLocFree(x-1, y-2) && _tileLocFree(x, y-2) && _tileLocFree(x+1, y-2) && _tileLocFree(x+2, y-2) && _tileLocFree(x+3, y-2) && _tileLocFree(x-1, y-1) && _tileLocFree(x, y-1) && _tileLocFree(x+1, y-1) && _tileLocFree(x+2, y-1) && _tileLocFree(x+3, y-1) && _tileLocFree(x+1,y) && _tileLocFree(x+2,y) && _tileLocFree(x+3,y) && _tileLocFree(x+1,y+1) && _tileLocFree(x+2,y+1):
		returnPath = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y-1), Vector2i(x+2,y-2), Vector2i(x+1,y-2), Vector2i(x,y-2), Vector2i(x,y-1)]

		if _path[index-1].y > y:
			returnPath.reverse()
			
		_loopCount += 1
		returnPath.append(Vector2i(x,y))
	#Blue
	elif x > 2 && y > 1 && _tileLocFree(x, y-3) && _tileLocFree(x-1, y-3) && _tileLocFree(x-2, y-3) && _tileLocFree(x-1, y) && _tileLocFree(x-2, y) && _tileLocFree(x-3, y) && _tileLocFree(x+1, y-1) && _tileLocFree(x, y-1) && _tileLocFree(x-2, y-1) && _tileLocFree(x-3, y-1) && _tileLocFree(x+1, y-2) && _tileLocFree(x, y-2) && _tileLocFree(x-1, y-2) && _tileLocFree(x-2, y-2) && _tileLocFree(x-3, y-2) && _tileLocFree(x-1, y+1) && _tileLocFree(x-2, y+1):
		returnPath = [Vector2i(x,y-1), Vector2i(x,y-2), Vector2i(x-1,y-2), Vector2i(x-2,y-2), Vector2i(x-2,y-1), Vector2i(x-2,y), Vector2i(x-1,y)]

		if _path[index-1].x > x:
			returnPath.reverse()

		_loopCount += 1
		returnPath.append(Vector2i(x,y))
	#Red
	elif x < _gridLength-1 && y < _gridHeight-2 && _tileLocFree(x, y+3) && _tileLocFree(x+1, y+3) && _tileLocFree(x+2, y+3) && _tileLocFree(x+1, y-1) && _tileLocFree(x+2, y-1) && _tileLocFree(x+1, y) && _tileLocFree(x+2, y) && _tileLocFree(x+3, y) && _tileLocFree(x-1, y+1) && _tileLocFree(x, y+1) && _tileLocFree(x+2, y+1) && _tileLocFree(x+3, y+1) && _tileLocFree(x-1, y+2) && _tileLocFree(x, y+2) && _tileLocFree(x+1, y+2) && _tileLocFree(x+2, y+2) && _tileLocFree(x+3, y+2):
		returnPath = [Vector2i(x+1,y), Vector2i(x+2,y), Vector2i(x+2,y+1), Vector2i(x+2,y+2), Vector2i(x+1,y+2), Vector2i(x,y+2), Vector2i(x,y+1)]

		if _path[index-1].y < y:
			returnPath.reverse()
		
		_loopCount += 1
		returnPath.append(Vector2i(x,y))
	# Brown
	elif x > 2 && y < _gridHeight-2 && _tileLocFree(x, y+3) && _tileLocFree(x-1, y+3) && _tileLocFree(x-2, y+3) && _tileLocFree(x-1, y-1) && _tileLocFree(x-2, y-1) && _tileLocFree(x-1, y) && _tileLocFree(x-2, y) && _tileLocFree(x-3, y) && _tileLocFree(x+1, y+1) && _tileLocFree(x, y+1) && _tileLocFree(x-2, y+1) && _tileLocFree(x-3, y+1)&& _tileLocFree(x+1, y+2) && _tileLocFree(x, y+2) && _tileLocFree(x-1, y+2) && _tileLocFree(x-2, y+2) && _tileLocFree(x-3, y+2):
		returnPath = [Vector2i(x,y+1), Vector2i(x,y+2), Vector2i(x-1,y+2), Vector2i(x-2,y+2), Vector2i(x-2,y+1), Vector2i(x-2,y), Vector2i(x-1,y)]

		if _path[index-1].x > x:
			returnPath.reverse()
		
		_loopCount += 1
		returnPath.append(Vector2i(x,y))
		
	return returnPath

func _tileLocTaken(x:int, y:int) -> bool:
	return _path.has(Vector2i(x,y))

func _tileLocFree(x:int, y:int) -> bool:
	return !_path.has(Vector2i(x,y))

func getLoopCount() -> int:
	return _loopCount

func getPathTile(index:int) -> Vector2i:
	return _path[index]
