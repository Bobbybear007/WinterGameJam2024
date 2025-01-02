extends Control
class_name ContainerSelection

@export var panel: Panel

var chosen_container = null
var final_container = null

func _ready() -> void:
	hide_panel()

func display_panel() -> void:
	Engine.time_scale = 0
	panel.visible = true

func hide_panel() -> void:
	Engine.time_scale = 1
	panel.visible = false

func cancel() -> void:
	print("AHEE. AHEE. ERHEE. AHEE.")
	chosen_container = null
	final_container = null
	print("Canceled action")
	hide_panel()

func confirm() -> void:
	final_container = chosen_container
	print(final_container)
	hide_panel()

func _on_hat_btn_pressed() -> void:
	chosen_container = "hat"


func _on_jacket_btn_pressed() -> void:
	chosen_container = "jacket"


func _on_lunchbox_btn_pressed() -> void:
	chosen_container = "lunchbox"


func _on_ok_pressed() -> void:
	confirm()


func _on_cancel_pressed() -> void:
	cancel()
