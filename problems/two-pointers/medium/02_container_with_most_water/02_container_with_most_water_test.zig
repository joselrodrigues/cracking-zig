const std = @import("std");
const testing = std.testing;

const container = @import("02_container_with_most_water.zig");
const maxArea = container.maxArea;

test "example case with maximum area 49" {
    const height = [_]i32{ 1, 8, 6, 2, 5, 4, 8, 3, 7 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 49), result);
}

test "two lines of equal height" {
    const height = [_]i32{ 1, 1 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 1), result);
}

test "lines at ends are tallest" {
    const height = [_]i32{ 4, 3, 2, 1, 4 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 16), result);
}

test "ascending heights" {
    const height = [_]i32{ 1, 2, 3, 4, 5 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 6), result);
}

test "descending heights" {
    const height = [_]i32{ 5, 4, 3, 2, 1 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 6), result);
}

test "all same height" {
    const height = [_]i32{ 3, 3, 3, 3, 3 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 12), result);
}

test "single tall line among short ones" {
    const height = [_]i32{ 1, 8, 1 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 2), result);
}

test "zero height lines" {
    const height = [_]i32{ 0, 5, 0, 5, 0 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 10), result);
}

test "large array" {
    const height = [_]i32{ 2, 3, 10, 5, 7, 8, 9 };
    const result = maxArea(&height);
    try testing.expectEqual(@as(i32, 36), result);
}