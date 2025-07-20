extends Control

@export var first_level: PackedScene


func _ready() -> void:
	$TitleMargin/AnimationPlayer.play("pulsate")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(first_level)


func _on_credits_pressed() -> void:
	OS.shell_open("https://github.com/cwboden/kgj-2025/blob/main/ATTRIBUTIONS.md")


func _on_exit_pressed() -> void:
	get_tree().quit()
