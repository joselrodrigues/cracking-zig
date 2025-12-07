const std = @import("std");
const testing = std.testing;

const merge_sorted_arrays = @import("04_merge_sorted_array.zig");
const mergeSortedArrays = merge_sorted_arrays.mergeSortedArrays;

test "merges two arrays with equal elements" {
    var nums1 = [_]i32{ 1, 2, 3, 0, 0, 0 };
    const nums2 = [_]i32{ 2, 5, 6 };
    mergeSortedArrays(&nums1, 3, &nums2, 3);

    const expected = [_]i32{ 1, 2, 2, 3, 5, 6 };
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges when nums2 is empty" {
    var nums1 = [_]i32{1};
    const nums2 = [_]i32{};
    mergeSortedArrays(&nums1, 1, &nums2, 0);

    const expected = [_]i32{1};
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges when nums1 is empty" {
    var nums1 = [_]i32{0};
    const nums2 = [_]i32{1};
    mergeSortedArrays(&nums1, 0, &nums2, 1);

    const expected = [_]i32{1};
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges with all nums1 elements smaller" {
    var nums1 = [_]i32{ 1, 2, 3, 0, 0, 0 };
    const nums2 = [_]i32{ 4, 5, 6 };
    mergeSortedArrays(&nums1, 3, &nums2, 3);

    const expected = [_]i32{ 1, 2, 3, 4, 5, 6 };
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges with all nums2 elements smaller" {
    var nums1 = [_]i32{ 4, 5, 6, 0, 0, 0 };
    const nums2 = [_]i32{ 1, 2, 3 };
    mergeSortedArrays(&nums1, 3, &nums2, 3);

    const expected = [_]i32{ 1, 2, 3, 4, 5, 6 };
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges with interleaved elements" {
    var nums1 = [_]i32{ 1, 3, 5, 0, 0, 0 };
    const nums2 = [_]i32{ 2, 4, 6 };
    mergeSortedArrays(&nums1, 3, &nums2, 3);

    const expected = [_]i32{ 1, 2, 3, 4, 5, 6 };
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges with duplicate values" {
    var nums1 = [_]i32{ 1, 1, 1, 0, 0, 0 };
    const nums2 = [_]i32{ 1, 1, 1 };
    mergeSortedArrays(&nums1, 3, &nums2, 3);

    const expected = [_]i32{ 1, 1, 1, 1, 1, 1 };
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges with negative numbers" {
    var nums1 = [_]i32{ -3, -1, 0, 0, 0 };
    const nums2 = [_]i32{ -2, 0 };
    mergeSortedArrays(&nums1, 2, &nums2, 2);

    const expected = [_]i32{ -3, -2, -1, 0 };
    try testing.expect(std.mem.eql(i32, nums1[0..4], &expected));
}

test "merges single element arrays" {
    var nums1 = [_]i32{ 2, 0 };
    const nums2 = [_]i32{1};
    mergeSortedArrays(&nums1, 1, &nums2, 1);

    const expected = [_]i32{ 1, 2 };
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

test "merges with larger nums2" {
    var nums1 = [_]i32{ 1, 0, 0, 0, 0 };
    const nums2 = [_]i32{ 2, 3, 4, 5 };
    mergeSortedArrays(&nums1, 1, &nums2, 4);

    const expected = [_]i32{ 1, 2, 3, 4, 5 };
    try testing.expect(std.mem.eql(i32, &nums1, &expected));
}

