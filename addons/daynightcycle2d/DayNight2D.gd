extends Node

export(NodePath) var cameraNodePath
var camera

onready var cloudLayer = $CloudLayer
onready var clock = $DayNightClock
onready var canvasModulate = $DayNightCanvasModulate
onready var rainParticles = $RainParticles

var is_raining = true

func _ready():
	if cameraNodePath:
		camera = get_node(cameraNodePath)
	
	set_cloudiness(0)

func start_rain(amount:int = 1000):
	rainParticles.amount = amount
	rainParticles.emitting = true
	is_raining = true


func stop_rain():
	rainParticles.emitting = false
	is_raining = false


func start_thunderstorm(strength: float = rand_range(0.2, 1)):
	canvasModulate.thunderstorm_strength = strength
	canvasModulate.thunderstorm_enabled = true


func stop_thunderstorm():
	canvasModulate.thunderstorm_enabled = false


func set_cloud_speed(speed:float = 0.1):
	cloudLayer.get_node("ParallaxLayer/AnimationPlayer").playback_speed = speed


func set_cloudiness(factor:float = 0.5):
	var clouds = cloudLayer.get_node("ParallaxLayer")
	if factor < 0.5:
		clouds.modulate.a = factor
	else:
		clouds.modulate.a = 1 - factor
	
	canvasModulate.cloudiness_factor = factor


func _process(delta):
	if camera:
		rainParticles.global_position = camera.global_position
