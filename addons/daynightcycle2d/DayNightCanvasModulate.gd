extends CanvasModulate

const seconds_per_day:int = 86400
const seconds_per_hour:int = 3600

export(float, 0, 1) var brightness_night = 0.3
export(float, 0, 1) var brightness_day = 1.0
export(Color) var color_dawn = Color("494688")
export(Color) var color_day = Color("fff1d0")
export(Color) var color_dusk = Color("854646")
export(Color) var color_night = Color("27264c")

var dawn_time_in_seconds:int = 60 * 60 * 6
var dusk_time_in_seconds:int = 60 * 60 * 21
var transition_time:int = 60 * 60

var sunrise_start:int
var sunrise_end:int
var sunset_start:int
var sunset_end:int

var color_gradient:Gradient = Gradient.new()

var cloudiness_factor:float = 0
var color_add:Color = Color(0, 0, 0, 0)

export(NodePath) var clockNodePath
var clock

var current_color:Color = color_night

var thunderstorm_enabled:bool = false
var thunderstorm_strength:float = 0.2
var lightning_strike_on:bool = false

var thunder_random:RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	clock = get_node(clockNodePath)
	clock.connect("time_passed", self, "_on_time_passed")
	
	sunrise_start = dawn_time_in_seconds - 60 * 60
	sunrise_end = dawn_time_in_seconds + 60 * 60
	
	sunset_start = dusk_time_in_seconds - 60 * 60
	sunset_end = dusk_time_in_seconds + 60 * 60 
	
	# set the night color at the beginning and end of the 24 hour cycle
	color_gradient.add_point(0, color_night)
	color_gradient.add_point(float(sunrise_start) / seconds_per_day, color_night)
	color_gradient.add_point(float(sunrise_end) / seconds_per_day, color_dawn)
	color_gradient.add_point(0.5, color_day)
	color_gradient.add_point(float(sunset_start) / seconds_per_day, color_day)
	color_gradient.add_point(float(sunset_end) / seconds_per_day, color_dusk)
	color_gradient.add_point(0.99999, color_night)


# when time passes, we calculate the brightness and tint of the environment
# based on the current time of day
func _on_time_passed(t):
	var time = clock.time
	
	var time_of_day = int(time) % seconds_per_day
	var percent = float(time_of_day) / seconds_per_day
	current_color = color_gradient.interpolate(float(time_of_day) / seconds_per_day)
	
	# apply color
	color = current_color
	
	# add color add
	color += color_add
	
	# add cloudiness
	if cloudiness_factor > 0.5:
		var a = (cloudiness_factor - 0.5) * 2.0
		color = color.linear_interpolate(color.darkened(0.5), a)


func lightning_strike():
	lightning_strike_on = true
	var a = rand_range(0.2, 0.8)
	color_add = Color(a, a, a, 0)


func _process(delta):
	if thunderstorm_enabled:
		if lightning_strike_on:
			if color_add.r <= 0.01:
				lightning_strike_on = false
			else:
				color_add *= 0.9
		else:
			var rand = abs(thunder_random.randfn(0, 1))
			if rand < thunderstorm_strength * 0.1:
				lightning_strike()
