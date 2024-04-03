extends CanvasLayer

signal back_pressed

@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var back_button = %BackButton

func _ready():
	%WindowButton.pressed.connect(on_window_button_pressed)
	update_display()
	
	music_slider.value_changed.connect(on_music_slider_changed)
	sfx_slider.value_changed.connect(on_sfx_slider_changed)
	
	
func update_display():
	sfx_slider.value = get_bus_volume_percent('sfx')
	music_slider.value = get_bus_volume_percent('music')

func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		%WindowButton.button_pressed = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		%WindowButton.button_pressed = true


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)
	
	
func set_bus_volume_percent(bus_name: String, volume_linear):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(volume_linear)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_music_slider_changed(value: float):
	set_bus_volume_percent('music', value)
	
	
func on_sfx_slider_changed(value: float):
	set_bus_volume_percent('sfx', value)
