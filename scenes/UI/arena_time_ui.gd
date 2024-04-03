extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = $MarginContainer/Label

func _process(delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)	


func format_seconds_to_string(seconds: float):
	var to_display = '%s: %s '
	if seconds < 60:
		var minutes = 0
		return to_display % ['0', str(floor(seconds))]
	else:
		var minutes = floor(seconds/60)
		return to_display % [str(minutes), str(floor(seconds - (minutes*60)))]
