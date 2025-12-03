const std = @import("std");
const testing = std.testing;

const find_first_occurrence = @import("01_find_first_occurrence.zig");
const findFirstOccurrence = find_first_occurrence.findFirstOccurrence;

test "finds needle at beginning of haystack" {
    const haystack = "sadbutsad";
    const needle = "sad";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 0), result);
}

test "returns negative when needle not found" {
    const haystack = "leetcode";
    const needle = "leeto";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, -1), result);
}

test "finds needle in middle of haystack" {
    const haystack = "hello";
    const needle = "ll";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 2), result);
}

test "finds needle at end of haystack" {
    const haystack = "example";
    const needle = "ple";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 4), result);
}

test "finds single character needle" {
    const haystack = "abcdef";
    const needle = "c";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 2), result);
}

test "handles needle same length as haystack when match" {
    const haystack = "test";
    const needle = "test";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 0), result);
}

test "handles needle same length as haystack when no match" {
    const haystack = "test";
    const needle = "best";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, -1), result);
}

test "handles needle longer than haystack" {
    const haystack = "hi";
    const needle = "hello";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, -1), result);
}

test "finds first occurrence when multiple matches exist" {
    const haystack = "ababcabc";
    const needle = "abc";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 2), result);
}

test "handles repeated characters in needle" {
    const haystack = "aaaaaab";
    const needle = "aaab";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 3), result);
}

test "handles partial matches before full match" {
    const haystack = "mississippi";
    const needle = "issip";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 4), result);
}

test "handles single character haystack match" {
    const haystack = "a";
    const needle = "a";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, 0), result);
}

test "handles single character haystack no match" {
    const haystack = "a";
    const needle = "b";
    const result = findFirstOccurrence(haystack, needle);

    try testing.expectEqual(@as(i32, -1), result);
}