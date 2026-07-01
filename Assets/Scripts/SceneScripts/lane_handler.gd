extends Node2D
class_name LaneHandler

@export var lanes: Array[Lane]

# var current_time_seconds: float = 0

var current_parsed_chart: ParsedChart

const NOTE_SPAWN_BUFFER = 50.0

var previous_current_time = 0.0

var total_offset: float = 0.0
var no_of_offsets: float = 0.0

var song_ended: bool = false

func _ready() -> void:
	InputHandler.lane_pressed.connect(_on_lane_pressed)
	InputHandler.lane_released.connect(_on_lane_released)

	initialise_chart()

func _process(_delta: float) -> void:
	var current_time = ChartTimeSynchroniser.current_rhythm_time()

	if not current_parsed_chart:
		return

	for lane: Lane in lanes:
		var notes_in_lane_during_change_in_current_time = current_parsed_chart.get_notes_for_lane_in_timeframe(
			lane.lane_id,
			previous_current_time + NOTE_SPAWN_BUFFER,
			current_time + NOTE_SPAWN_BUFFER
		)

		for note_data: NoteData in notes_in_lane_during_change_in_current_time:
			spawn_note_in_lane(lane.lane_id, note_data)

	previous_current_time = current_time

	if not song_ended and current_time >= current_parsed_chart.length_of_song:
		song_ended = true

		print("Song Ended!")

func _exit_tree() -> void:
	if InputHandler.lane_pressed.is_connected(_on_lane_pressed):
		InputHandler.lane_pressed.disconnect(_on_lane_pressed)

	if InputHandler.lane_released.is_connected(_on_lane_released):
		InputHandler.lane_released.disconnect(_on_lane_released)


func _on_lane_pressed(lane_id: int, precise_time: float):
	var nearby_note_datas: Array[NoteData] = current_parsed_chart.get_notes_for_lane_in_timeframe(
		lane_id,
		ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) - 0.140,
		ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) + 0.210	
	)

	lanes[lane_id].hit_effect_polygon_2d.activate_hit_effect()

	if len(nearby_note_datas) == 0:
		return

	for note_data: NoteData in nearby_note_datas:
		if note_data.note_already_hit or note_data.note_held_down:
			continue

		var offset = 1000 * (ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) - note_data.start_time)

		if note_data.note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
			note_data.note_already_hit = true

			lanes[lane_id].handle_note_completion(note_data)

		elif note_data.note_type == Enums.NOTE_TYPE.HOLD_NOTE:
			note_data.note_held_down = true

		note_data.note_hit_judgement_data = JudgementManager.calculate_judgement_data_for_press(note_data.note_type, offset)

		JudgementManager.log_judgement_data(note_data.note_hit_judgement_data)

		print("judgement: %s" % note_data.note_hit_judgement_data.judgement_offset)

		break

func _on_lane_released(lane_id: int, precise_time: float):
	var current_note_datas: Array[NoteData] = lanes[lane_id].current_note_datas

	lanes[lane_id].hit_effect_polygon_2d.deactivate_hit_effect()

	if len(current_note_datas) == 0:
		return

	for note_data: NoteData in current_note_datas:
		if note_data.note_already_hit or not note_data.note_held_down:
			continue

		var offset = 1000 * (ChartTimeSynchroniser.get_rhythm_time_from_precise_time(precise_time) - note_data.end_time)

		if note_data.note_type == Enums.NOTE_TYPE.HOLD_NOTE:
			note_data.note_held_down = false

			note_data.note_already_hit = true

			lanes[lane_id].handle_note_completion(note_data)

		note_data.note_release_judgement_data = JudgementManager.calculate_judgement_data_for_release(note_data.note_type, offset)

		JudgementManager.log_judgement_data(note_data.note_release_judgement_data)

		print("judgement: %s" % note_data.note_release_judgement_data.judgement_offset)

		break

func initialise_chart():
	current_parsed_chart = ParsedChart.init_from_file("res://Assets/Charts/test_chart_2.json")

	for lane: Lane in lanes:
		var notes_in_lane = current_parsed_chart.get_notes_for_lane_in_timeframe(lane.lane_id, 0.0, NOTE_SPAWN_BUFFER)

		for note_data: NoteData in notes_in_lane:
			spawn_note_in_lane(lane.lane_id, note_data)

func spawn_note_in_lane(lane_id: int, note_data: NoteData) -> void:
	var lane: Lane = lanes[lane_id]

	lane.spawn_note(note_data)



	
