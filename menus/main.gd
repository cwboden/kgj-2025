extends Control

@export var first_level: PackedScene


func _ready() -> void:
	$TitleMargin/AnimationPlayer.play("pulsate")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(first_level)


func _on_settings_pressed() -> void:
	var coming_soon = AcceptDialog.new()
	coming_soon.title = "Settings"
	coming_soon.dialog_text = "Coming soon :)"
	add_child(coming_soon)
	coming_soon.popup_centered()


func _on_exit_pressed() -> void:
	get_tree().quit()
