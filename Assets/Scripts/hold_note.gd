extends Note
class_name HoldNote

@export var tail_polygon_2d: Polygon2D
@export var tail_width: float = 144

var tail_length: float = 144

func change_tail_length(new_length: float):
    self.tail_length = new_length
    
    var new_polygon = PackedVector2Array([
        Vector2(-tail_width / 2, 0),
        Vector2(-tail_width / 2, -new_length),
        Vector2(tail_width / 2, -new_length),
        Vector2(tail_width / 2, 0)
    ])

    self.tail_polygon_2d.polygon = new_polygon

# func _process(_delta: float) -> void:
#     change_tail_length(ChartTimeSynchroniser.current_time * 100)

