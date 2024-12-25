extends Node
var MainTrack
var SecondaryTrack
var CurrentlyPlayingSong = null
func TransitionTo(Song : String):
	if Song != CurrentlyPlayingSong:
		if !MainTrack:
			MainTrack = AudioStreamPlayer.new()
			MainTrack.stream = load("res://Music/" + Song + ".mp3")
			add_child(MainTrack)
			MainTrack.playing = true
			MainTrack.finished.connect(Loop)
			CurrentlyPlayingSong = Song
		else:
			SecondaryTrack = MainTrack
			
			MainTrack = AudioStreamPlayer.new()
			MainTrack.stream = load("res://Music/" + Song + ".mp3")
			MainTrack.volume_db = -30
			add_child(MainTrack)
			MainTrack.playing = true
			MainTrack.finished.connect(Loop)
			CurrentlyPlayingSong = Song
			
			var NewTween = get_tree().create_tween()
			NewTween.tween_property(SecondaryTrack,"volume_db",-30,1)
			NewTween.parallel().tween_property(MainTrack,"volume_db",0,1)
			
			await NewTween.finished
			SecondaryTrack.queue_free()
			SecondaryTrack = null

func Loop():
	MainTrack.play()
