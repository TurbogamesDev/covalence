extends RefCounted
class_name ParsedChart

# var chart_data = {}

var lane_data_array: Dictionary[int, LaneData] = {}

var length_of_song: float = 0.0

static func init_from_file(file_path: String) -> ParsedChart:
	assert(FileAccess.file_exists(file_path))

	var data_json: String = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data_json)

	assert(parsed_data is Dictionary)

	var init_parsed_chart: ParsedChart = ParsedChart.new()

	init_parsed_chart.length_of_song = parsed_data["metadata"]["length_of_song"]

	for lane_id: int in range(parsed_data["note_data"].size()):
		var raw_lane_data = parsed_data["note_data"]["lane_%d" % lane_id]

		init_parsed_chart.lane_data_array[lane_id] = LaneData.new(raw_lane_data, lane_id)

	return init_parsed_chart

func get_notes_for_lane_in_timeframe(lane_id: int, start_time: float, end_time: float) -> Array[NoteData]:
	var lane_data = self.lane_data_array[lane_id]

	return lane_data.get_notes_in_timeframe(start_time, end_time)

func get_total_number_of_start_note_datas() -> Dictionary[Enums.NOTE_TYPE, int]:
	var total_start_note_datas: Dictionary[Enums.NOTE_TYPE, int] = {}

	for lane_data: LaneData in lane_data_array.values():
		for note_data: NoteData in lane_data.notes_in_lane:
			var note_type = note_data.note_type

			total_start_note_datas.get_or_add(note_type, 0)

			total_start_note_datas[note_type] += 1

	return total_start_note_datas

func get_total_number_of_end_note_datas() -> Dictionary[Enums.NOTE_TYPE, int]:
	var total_end_note_datas: Dictionary[Enums.NOTE_TYPE, int] = {}

	for lane_data: LaneData in lane_data_array.values():
		for note_data: NoteData in lane_data.notes_in_lane:
			if note_data.instant:
				continue

			var note_type = note_data.note_type

			total_end_note_datas.get_or_add(note_type, 0)

			total_end_note_datas[note_type] += 1

	return total_end_note_datas