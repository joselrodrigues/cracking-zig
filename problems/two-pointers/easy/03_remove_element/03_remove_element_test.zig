const std = @import("std");
const testing = std.testing;

const remove_element = @import("03_remove_element.zig");
const removeElement = remove_element.removeElement;

fn arrayDoesNotContain(nums: []i32, k: usize, val: i32) bool {
    for (nums[0..k]) |num| {
        if (num == val) return false;
    }
    return true;
}

test "removes target value from simple array" {
    var nums = [_]i32{ 3, 2, 2, 3 };
    const k = removeElement(&nums, 3);

    try testing.expectEqual(@as(usize, 2), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 3));
}

test "removes target value from longer array" {
    var nums = [_]i32{ 0, 1, 2, 2, 3, 0, 4, 2 };
    const k = removeElement(&nums, 2);

    try testing.expectEqual(@as(usize, 5), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 2));
}

test "handles empty array" {
    var nums = [_]i32{};
    const k = removeElement(&nums, 1);

    try testing.expectEqual(@as(usize, 0), k);
}

test "handles array with single element to remove" {
    var nums = [_]i32{1};
    const k = removeElement(&nums, 1);

    try testing.expectEqual(@as(usize, 0), k);
}

test "handles array with single element to keep" {
    var nums = [_]i32{1};
    const k = removeElement(&nums, 2);

    try testing.expectEqual(@as(usize, 1), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
}

test "handles array with all elements equal to target" {
    var nums = [_]i32{ 3, 3, 3, 3 };
    const k = removeElement(&nums, 3);

    try testing.expectEqual(@as(usize, 0), k);
}

test "handles array with no elements equal to target" {
    var nums = [_]i32{ 1, 2, 3, 4, 5 };
    const k = removeElement(&nums, 6);

    try testing.expectEqual(@as(usize, 5), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 6));
}

test "removes target from beginning of array" {
    var nums = [_]i32{ 2, 2, 2, 1, 3, 4 };
    const k = removeElement(&nums, 2);

    try testing.expectEqual(@as(usize, 3), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 2));
}

test "removes target from end of array" {
    var nums = [_]i32{ 1, 3, 4, 2, 2, 2 };
    const k = removeElement(&nums, 2);

    try testing.expectEqual(@as(usize, 3), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 2));
}

test "removes target from middle of array" {
    var nums = [_]i32{ 1, 3, 2, 2, 4, 5 };
    const k = removeElement(&nums, 2);

    try testing.expectEqual(@as(usize, 4), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 2));
}

test "handles alternating target and non-target values" {
    var nums = [_]i32{ 1, 2, 1, 2, 1, 2 };
    const k = removeElement(&nums, 2);

    try testing.expectEqual(@as(usize, 3), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 2));
}

test "handles zero as target value" {
    var nums = [_]i32{ 0, 1, 0, 2, 0, 3 };
    const k = removeElement(&nums, 0);

    try testing.expectEqual(@as(usize, 3), k);
    try testing.expect(arrayDoesNotContain(&nums, k, 0));
}