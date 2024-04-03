extends AudioStreamPlayer


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	$FirstHalfMusic.play()
	
	
func on_timer_timeout():
	$FirstHalfMusic.stop()
	$WaitTimer.start()
	$WaitTimer.timeout.connect(on_wait_timer_timeout)
	
	
func on_wait_timer_timeout():
	$SecondHalfMusic.play()
