extends Control


func _ready() -> void:
	var thanks_for_playing = AcceptDialog.new()
	thanks_for_playing.title = "Thanks for Playing!!"
	thanks_for_playing.dialog_text = "We hope you enjoyed playing our game.\nUntil next time!!"
	
	add_child(thanks_for_playing)
	thanks_for_playing.confirmed.connect(_go_to_home)

	thanks_for_playing.popup_centered()
	
	
func _go_to_home():
	get_tree().change_scene_to_file("res://menus/main.tscn")
