extends Panel

onready var sub_node: Sub = get_node("../../Sub")

func _ready():
	var _err = sub_node.connect("move_input_recieved", self, "update_test_label")

func update_depth_label(depth):
	$DepthLabel.text = depth

func update_test_label(new_text):
	$TestLabel.text = str(new_text) + " " + str(new_text.length())
