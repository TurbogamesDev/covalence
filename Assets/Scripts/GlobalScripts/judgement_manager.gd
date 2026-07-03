extends Node

const MAXIMUM_OFFSET_FOR_JUDGEMENT_PRESS_1: Dictionary[Enums.JUDGEMENT_TYPE, float] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: -140.0,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: -70.0,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: -35.0,
    Enums.JUDGEMENT_TYPE.EXACT: 35.0,
    Enums.JUDGEMENT_TYPE.LATE_PERFECT: 70.0,
    Enums.JUDGEMENT_TYPE.LATE_GOOD: 140.0,
    Enums.JUDGEMENT_TYPE.MISS: INF
}

const MAXIMUM_OFFSET_FOR_JUDGEMENT_RELEASE_1: Dictionary[Enums.JUDGEMENT_TYPE, float] = {
    Enums.JUDGEMENT_TYPE.TOO_EARLY: -140.0,
    Enums.JUDGEMENT_TYPE.EARLY_GOOD: -70.0,
    Enums.JUDGEMENT_TYPE.EARLY_PERFECT: -35.0,
    Enums.JUDGEMENT_TYPE.EXACT: INF
}

static func get_judgement_data_from_max_offset_table_and_offset(max_offset_table: Dictionary[Enums.JUDGEMENT_TYPE, float], offset: float) -> JudgementData:
    for judgement_type: Enums.JUDGEMENT_TYPE in max_offset_table:
        var max_offset: float = max_offset_table[judgement_type]

        if offset >= max_offset:
            continue

        return JudgementData.new(judgement_type, offset)

    return JudgementData.new(Enums.JUDGEMENT_TYPE.NONE, offset)

func calculate_judgement_data_for_press(note_type: Enums.NOTE_TYPE, offset: float) -> JudgementData:
    if note_type == Enums.NOTE_TYPE.REGULAR_NOTE:
        return get_judgement_data_from_max_offset_table_and_offset(MAXIMUM_OFFSET_FOR_JUDGEMENT_PRESS_1, offset)

    elif note_type == Enums.NOTE_TYPE.HOLD_NOTE:
        return get_judgement_data_from_max_offset_table_and_offset(MAXIMUM_OFFSET_FOR_JUDGEMENT_PRESS_1, offset)

    return JudgementData.new(Enums.JUDGEMENT_TYPE.NONE, offset)

func calculate_judgement_data_for_release(note_type: Enums.NOTE_TYPE, offset: float) -> JudgementData:
    if note_type == Enums.NOTE_TYPE.HOLD_NOTE:
        return get_judgement_data_from_max_offset_table_and_offset(MAXIMUM_OFFSET_FOR_JUDGEMENT_RELEASE_1, offset)

    return JudgementData.new(Enums.JUDGEMENT_TYPE.NONE, offset)
