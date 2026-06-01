extends Node2D
class_name LaneHandler

@export var lanes: Array[Lane]

# var current_time_seconds: float = 0

var current_parsed_chart: ParsedChart

const NOTE_SPAWN_BUFFER = 2.0

var previous_current_time = 0.0



var total_offset: float = 0.0
var no_of_offsets: float = 0.0

func _ready() -> void:
	InputHandler.lane_pressed.connect(_on_lane_pressed)
	InputHandler.lane_released.connect(_on_lane_released)

	initialise_chart()

func _process(_delta: float) -> void:
	if not current_parsed_chart:
		return

	for lane: Lane in lanes:
		var notes_in_lane_during_change_in_current_time = current_parsed_chart.get_notes_for_lane_in_timeframe(
			lane.lane_id,
			previous_current_time + NOTE_SPAWN_BUFFER,
			ChartTimeSynchroniser.current_rhythm_time() + NOTE_SPAWN_BUFFER
		)

		for note_data: NoteData in notes_in_lane_during_change_in_current_time:
			spawn_note_in_lane(lane.lane_id, note_data)

	previous_current_time = ChartTimeSynchroniser.current_rhythm_time()

func _exit_tree() -> void:
	if InputHandler.lane_pressed.is_connected(_on_lane_pressed):
		InputHandler.lane_pressed.disconnect(_on_lane_pressed)

	if InputHandler.lane_released.is_connected(_on_lane_released):
		InputHandler.lane_released.disconnect(_on_lane_released)


func _on_lane_pressed(lane_id: int, precise_time: float):
	print("lane %d pressed at %f seconds!" % [lane_id, ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time)])

	var nearby_note_datas: Array[NoteData] = current_parsed_chart.get_notes_for_lane_in_timeframe(
		lane_id,
		ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) - 0.140,
		ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) + 0.140	
	)

	if len(nearby_note_datas) > 0:
		# print("nearest note was at %f seconds, and the offset was %f seconds." % [nearby_note_datas[0].start_time, ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) - nearby_note_datas[0].start_time])
		print("%f ms" % ((ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) - nearby_note_datas[0].start_time) * 1_000.0))

		print(nearby_note_datas[0].start_time)

		lanes[lane_id].handle_note_hit(nearby_note_datas[0])

		total_offset += (ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) - nearby_note_datas[0].start_time) * 1_000.0
		no_of_offsets += 1

	else:
		print("no note was nearby")

		print(total_offset / no_of_offsets)

	lanes[lane_id].hit_effect_polygon_2d.activate_hit_effect()


func _on_lane_released(lane_id: int, precise_time: float):
	lanes[lane_id].hit_effect_polygon_2d.deactivate_hit_effect()

	# print("lane %d released at %f seconds!" % [lane_id, ChartTimeSynchroniser.current_rhythm_time()])


func initialise_chart():
	current_parsed_chart = ParsedChart.init_from_file("res://Assets/Charts/test_chart_2.json")

	for lane: Lane in lanes:
		var notes_in_lane = current_parsed_chart.get_notes_for_lane_in_timeframe(lane.lane_id, 0.0, NOTE_SPAWN_BUFFER)

		for note_data: NoteData in notes_in_lane:
			spawn_note_in_lane(lane.lane_id, note_data)

func spawn_note_in_lane(lane_id: int, note_data: NoteData) -> void:
	var lane: Lane = lanes[lane_id]

	lane.spawn_note(note_data)



	
