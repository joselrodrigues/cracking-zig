const std = @import("std");

pub fn maxArea(height: []const i32) i32 {
    var left: usize = 0;
    var right: usize = height.len - 1;
    var max_area: i32 = 0;

    while (left < right) {
        const new_area: i32 = @min(height[left], height[right]) * @as(i32, @intCast(right - left));
        max_area = @max(new_area, max_area);

        if (height[left] < height[right]) {
            left += 1;
        } else if (height[right] < height[left]) {
            right -= 1;
        } else {
            left += 1;
            right -= 1;
        }
    }

    return max_area;
}

