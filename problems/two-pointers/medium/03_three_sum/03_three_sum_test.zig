const std = @import("std");
const testing = std.testing;

const three_sum = @import("03_three_sum.zig");
const threeSum = three_sum.threeSum;

fn containsTriplet(result: []const []const i32, expected: []const i32) bool {
    for (result) |triplet| {
        if (triplet.len != 3) continue;
        if (std.mem.eql(i32, triplet, expected)) return true;
    }
    return false;
}

test "example with two triplets" {
    const allocator = testing.allocator;
    var nums = [_]i32{ -1, 0, 1, 2, -1, -4 };
    const result = try threeSum(&nums, allocator);
    defer {
        for (result) |triplet| {
            allocator.free(triplet);
        }
        allocator.free(result);
    }

    try testing.expectEqual(@as(usize, 2), result.len);
    try testing.expect(containsTriplet(result, &[_]i32{ -1, -1, 2 }));
    try testing.expect(containsTriplet(result, &[_]i32{ -1, 0, 1 }));
}

test "no valid triplets" {
    const allocator = testing.allocator;
    var nums = [_]i32{ 0, 1, 1 };
    const result = try threeSum(&nums, allocator);
    defer allocator.free(result);

    try testing.expectEqual(@as(usize, 0), result.len);
}

test "all zeros" {
    const allocator = testing.allocator;
    var nums = [_]i32{ 0, 0, 0 };
    const result = try threeSum(&nums, allocator);
    defer {
        for (result) |triplet| {
            allocator.free(triplet);
        }
        allocator.free(result);
    }

    try testing.expectEqual(@as(usize, 1), result.len);
    try testing.expect(containsTriplet(result, &[_]i32{ 0, 0, 0 }));
}

test "multiple duplicates" {
    const allocator = testing.allocator;
    var nums = [_]i32{ -1, -1, -1, 0, 0, 0, 1, 1, 1 };
    const result = try threeSum(&nums, allocator);
    defer {
        for (result) |triplet| {
            allocator.free(triplet);
        }
        allocator.free(result);
    }

    try testing.expectEqual(@as(usize, 2), result.len);
    try testing.expect(containsTriplet(result, &[_]i32{ -1, 0, 1 }));
    try testing.expect(containsTriplet(result, &[_]i32{ 0, 0, 0 }));
}

test "single triplet" {
    const allocator = testing.allocator;
    var nums = [_]i32{ -2, 0, 1, 1, 2 };
    const result = try threeSum(&nums, allocator);
    defer {
        for (result) |triplet| {
            allocator.free(triplet);
        }
        allocator.free(result);
    }

    try testing.expectEqual(@as(usize, 2), result.len);
    try testing.expect(containsTriplet(result, &[_]i32{ -2, 0, 2 }));
    try testing.expect(containsTriplet(result, &[_]i32{ -2, 1, 1 }));
}

test "all negative numbers" {
    const allocator = testing.allocator;
    var nums = [_]i32{ -5, -4, -3, -2, -1 };
    const result = try threeSum(&nums, allocator);
    defer allocator.free(result);

    try testing.expectEqual(@as(usize, 0), result.len);
}

test "all positive numbers" {
    const allocator = testing.allocator;
    var nums = [_]i32{ 1, 2, 3, 4, 5 };
    const result = try threeSum(&nums, allocator);
    defer allocator.free(result);

    try testing.expectEqual(@as(usize, 0), result.len);
}