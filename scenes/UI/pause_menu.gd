extends CanvasLayer

@onready var panel_container = $MarginContainer/PanelContainer
var is_closing: bool
var options_menu_scene = preload('res://scenes/UI/options_menu.tscn')

func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size/2
	%ResumeButton.pressed.connect(on_resume_pressed)
	%OptionButton.pressed.connect(on_options_pressed)
	%BackButton.pressed.connect(on_back_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	$AnimationPlayer.play('default')
	
	var tween = create_tween()
	#below line is to force Godot to animate the child node of a container node. 
	#Essentially, the panel container is always rendered with scale 1 in the first
	#frame regardless of the animation node, so this explicitly ensures that it is not.  
	tween.tween_property(panel_container, 'scale', Vector2.ZERO, 0)  
	tween.tween_property(panel_container, 'scale', Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	
func _unhandled_input(event):
	if event.is_action_pressed('Unpause'):
		get_tree().paused = false
		queue_free()
	if event.is_action_pressed('Pause'):
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	is_closing = true
	$AnimationPlayer.play_backwards('default')
	var tween = create_tween()
	tween.tween_property(panel_container, 'scale', Vector2.ONE, 0)  
	tween.tween_property(panel_container, 'scale', Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()
	

func on_resume_pressed():
	close()
	
	
func on_options_pressed():
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_button.pressed.connect(on_options_back_button_pressed.bind(options_menu_instance))
	
	
func on_back_pressed():
	get_tree().paused = false
	queue_free()
	
	
func on_options_back_button_pressed(options_instance):
	options_instance.queue_free()
	
	
func on_quit_pressed():
	get_tree().quit()
