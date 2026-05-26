extends RefCounted
class_name ParsedChart

# var chart_data = {}

var lane_data_array: Dictionary[int, LaneData] = {}

static func init_from_file(file_path: String) -> ParsedChart:
	assert(FileAccess.file_exists(file_path))

	var data_json: String = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data_json)

	assert(parsed_data is Dictionary)

	var init_parsed_chart: ParsedChart = ParsedChart.new()

	var i = 0

	for lane_id: int in range(parsed_data["note_data"].size()):
		var raw_lane_data = parsed_data["note_data"]["lane_%d" % lane_id]

		var lane_data: LaneData = LaneData.new()
		lane_data.lane_id = lane_id

		for raw_note_data in raw_lane_data:
			var note_data: NoteData = NoteData.new()

			note_data.start_time = raw_note_data["start_time"]
			note_data.end_time = raw_note_data["end_time"]

			note_data.note_type = raw_note_data["note_id"]
			note_data.instant = raw_note_data["instant"]

			print(raw_note_data)
			print(note_data.start_time)
			print(note_data.end_time)
			print(note_data.instant)
			print(note_data.note_type)
			

			i += 1
			print(i)

			lane_data.notes_in_lane.append(note_data)

		init_parsed_chart.lane_data_array[lane_id] = lane_data

	return init_parsed_chart

func get_notes_for_lane_in_timeframe(lane_id: int, start_time: float, end_time: float) -> Array[NoteData]:
	var lane_data = self.lane_data_array[lane_id]

	return lane_data.get_notes_in_timeframe(start_time, end_time)
