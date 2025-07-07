class_name MovementState
extends StateMachineState
## Used to create movement states such as being on the ground or in the air.


@onready var player : PlayerContainer = get_node(^"../..")
@onready var statistics : PlayerStatistics = player.statistics
@onready var variables : PlayerVariables = player.variables
