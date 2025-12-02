const std = @import("std");
const testing = std.testing;

const remove_duplicates = @import("02_remove_duplicates.zig");
const removeDuplicates = remove_duplicates.removeDuplicates;

test "removes duplicates from simple array" {
    var nums = [_]i32{ 1, 1, 2 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 2), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
    try testing.expectEqual(@as(i32, 2), nums[1]);
}

test "removes duplicates from array with multiple duplicates" {
    var nums = [_]i32{ 0, 0, 1, 1, 1, 2, 2, 3, 3, 4 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 5), k);
    try testing.expectEqual(@as(i32, 0), nums[0]);
    try testing.expectEqual(@as(i32, 1), nums[1]);
    try testing.expectEqual(@as(i32, 2), nums[2]);
    try testing.expectEqual(@as(i32, 3), nums[3]);
    try testing.expectEqual(@as(i32, 4), nums[4]);
}

test "handles array with no duplicates" {
    var nums = [_]i32{ 1, 2, 3, 4, 5 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 5), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
    try testing.expectEqual(@as(i32, 2), nums[1]);
    try testing.expectEqual(@as(i32, 3), nums[2]);
    try testing.expectEqual(@as(i32, 4), nums[3]);
    try testing.expectEqual(@as(i32, 5), nums[4]);
}

test "handles array with all duplicates" {
    var nums = [_]i32{ 1, 1, 1, 1, 1 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 1), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
}

test "handles single element array" {
    var nums = [_]i32{1};
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 1), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
}

test "handles two element array with duplicates" {
    var nums = [_]i32{ 1, 1 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 1), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
}

test "handles two element array without duplicates" {
    var nums = [_]i32{ 1, 2 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 2), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
    try testing.expectEqual(@as(i32, 2), nums[1]);
}

test "handles negative numbers" {
    var nums = [_]i32{ -3, -3, -1, -1, 0, 0, 1, 1 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 4), k);
    try testing.expectEqual(@as(i32, -3), nums[0]);
    try testing.expectEqual(@as(i32, -1), nums[1]);
    try testing.expectEqual(@as(i32, 0), nums[2]);
    try testing.expectEqual(@as(i32, 1), nums[3]);
}

test "handles many consecutive duplicates" {
    var nums = [_]i32{ 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 3), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
    try testing.expectEqual(@as(i32, 2), nums[1]);
    try testing.expectEqual(@as(i32, 3), nums[2]);
}

test "handles alternating duplicates" {
    var nums = [_]i32{ 1, 1, 2, 2, 3, 3, 4, 4 };
    const k = removeDuplicates(&nums);

    try testing.expectEqual(@as(usize, 4), k);
    try testing.expectEqual(@as(i32, 1), nums[0]);
    try testing.expectEqual(@as(i32, 2), nums[1]);
    try testing.expectEqual(@as(i32, 3), nums[2]);
    try testing.expectEqual(@as(i32, 4), nums[3]);
}