extends RefCounted
class_name ParsedChart

var chart_data = {}

static func init_from_file(file_path: String) -> ParsedChart:
    assert(FileAccess.file_exists(file_path))

    var data_json: String = FileAccess.get_file_as_string(file_path)
    var parsed_data = JSON.parse_string(data_json)

    assert(parsed_data is Dictionary)

    var init_parsed_chart: ParsedChart = ParsedChart.new()

    init_parsed_chart.chart_data = parsed_data

    return init_parsed_chart

func get_notes_for_lane_in_timeframe(lane: int, start_time: float, end_time: float) -> Array:
    var notes_in_lane = chart_data["note_data"]["lane_%d" % lane]

    var new_notes_in_lane = []

    for note in notes_in_lane:
        if note["start_time"] < start_time:
            continue

        if note["end_time"] >= end_time:
            continue

        new_notes_in_lane.append(note)

    return new_notes_in_lane





