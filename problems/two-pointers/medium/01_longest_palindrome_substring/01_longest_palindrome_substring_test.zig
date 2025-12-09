const std = @import("std");
const testing = std.testing;

const longest_palindrome = @import("01_longest_palindrome_substring.zig");
const longestPalindrome = longest_palindrome.longestPalindrome;

test "odd length palindrome" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("babad", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "bab") or std.mem.eql(u8, result, "aba"));
}

test "even length palindrome" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("cbbd", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "bb"));
}

test "single character" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("a", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "a"));
}

test "no palindrome longer than one" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("ac", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "a") or std.mem.eql(u8, result, "c"));
}

test "entire string is palindrome" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("racecar", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "racecar"));
}

test "palindrome at start" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("abaxyz", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "aba"));
}

test "palindrome at end" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("xyzaba", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "aba"));
}

test "multiple palindromes same length" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("abacabad", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "abacaba"));
}

test "all same characters" {
    const allocator = testing.allocator;
    const result = try longestPalindrome("aaaa", allocator);
    defer allocator.free(result);

    try testing.expect(std.mem.eql(u8, result, "aaaa"));
}
