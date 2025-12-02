const std = @import("std");
const testing = std.testing;

const pair_sum = @import("01_pair_sum_sorted.zig");
const pairSum = pair_sum.pairSum;

test "finds pair with positive numbers" {
    const nums = [_]i32{ 1, 2, 3, 4, 6 };
    const target = 6;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, 6), sum);
}

test "finds pair with mixed positive and negative" {
    const nums = [_]i32{ -5, -2, 3, 4, 6 };
    const target = 7;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, 7), sum);
}

test "finds pair with duplicate values" {
    const nums = [_]i32{ 1, 1, 1 };
    const target = 2;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, 2), sum);
    try testing.expect(indices[0] != indices[1]);
}

test "returns null when target too large" {
    const nums = [_]i32{ 1, 2, 3, 4 };
    const target = 10;
    const result = pairSum(nums[0..], target);

    try testing.expectEqual(@as(?[2]usize, null), result);
}

test "returns null when target too small" {
    const nums = [_]i32{ 5, 6, 7, 8 };
    const target = 3;
    const result = pairSum(nums[0..], target);

    try testing.expectEqual(@as(?[2]usize, null), result);
}

test "finds pair at opposite ends" {
    const nums = [_]i32{ 1, 2, 3, 4, 5 };
    const target = 6;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, 6), sum);
}

test "finds pair in middle" {
    const nums = [_]i32{ 1, 2, 3, 4, 5 };
    const target = 5;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, 5), sum);
}

test "finds pair with all negative numbers" {
    const nums = [_]i32{ -10, -5, -2, -1 };
    const target = -7;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, -7), sum);
}

test "finds pair with zero target" {
    const nums = [_]i32{ -3, 0, 1, 3, 5 };
    const target = 0;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, 0), sum);
}

test "finds pair in two element array" {
    const nums = [_]i32{ 1, 2 };
    const target = 3;
    const result = pairSum(nums[0..], target);

    try testing.expect(result != null);
    const indices = result.?;
    const sum = nums[indices[0]] + nums[indices[1]];
    try testing.expectEqual(@as(i32, 3), sum);
}

test "returns null for two element array without pair" {
    const nums = [_]i32{ 1, 2 };
    const target = 10;
    const result = pairSum(nums[0..], target);

    try testing.expectEqual(@as(?[2]usize, null), result);
}
