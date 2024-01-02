extends Control

var loading: bool
var path: String
var waitForInput: bool

func _ready():
	pass
	

func _process(delta):
	if loading:
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(path, progress)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$ProgressBar.value = progress[0] * 100
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			$ProgressBar.value = progress[0] * 100
			$Control/VBoxContainer/Label.text = "Press Any Key To Continue"
			waitForInput = true
			
			


func _input(event):
	if (waitForInput):
		if event is InputEventKey:
			var scene = ResourceLoader.load_threaded_get(path)
			changeScene(scene)


func changeScene(resource: PackedScene):
	var currentNode = resource.instantiate()
	get_tree().root.add_child(currentNode)
	
	
	for item in get_tree().root.get_children():
		if item != currentNode:
			get_tree().root.remove_child(item)
			item.queue_free()


func loadLevel(path: String):
	self.path = path
	show()
	if(ResourceLoader.has_cached(path)):
		ResourceLoader.load_threaded_get(path)
	else:
		ResourceLoader.load_threaded_request(path, "", true)
		loading = true
		
		
