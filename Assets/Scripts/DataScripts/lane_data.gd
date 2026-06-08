extends RefCounted
class_name LaneData

var lane_id: int

var notes_in_lane: Array[NoteData] = []

func _init(raw_lane_data: Array, init_lane_id: int):
    self.lane_id = init_lane_id

    for raw_note_data in raw_lane_data:
        self.notes_in_lane.append(
            NoteData.new(raw_note_data)
        )

func get_notes_in_timeframe(start_time: float, end_time: float) -> Array[NoteData]:
    var new_notes_in_lane: Array[NoteData] = []

    for note_data: NoteData in notes_in_lane:
        if note_data.start_time < start_time:
            continue

        if note_data.start_time >= end_time:
            continue

        new_notes_in_lane.append(note_data)

    return new_notes_in_lane
