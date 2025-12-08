const std = @import("std");
const testing = std.testing;

const valid_palindrome = @import("05_valid_palindrome.zig");
const isPalindrome = valid_palindrome.isPalindrome;

test "empty string" {
    const result = isPalindrome("");
    try testing.expect(result == true);
}

test "single character" {
    const result = isPalindrome("a");
    try testing.expect(result == true);
}

test "palindrome with two characters" {
    const result = isPalindrome("aa");
    try testing.expect(result == true);
}

test "non-palindrome with two characters" {
    const result = isPalindrome("ab");
    try testing.expect(result == false);
}

test "string with no alphanumeric characters" {
    const result = isPalindrome("!, (?)");
    try testing.expect(result == true);
}

test "palindrome with punctuation and numbers" {
    const result = isPalindrome("12.02.2021");
    try testing.expect(result == true);
}

test "non-palindrome with punctuation and numbers" {
    const result = isPalindrome("21.02.2021");
    try testing.expect(result == false);
}

test "non-palindrome with punctuation" {
    const result = isPalindrome("hello, world!");
    try testing.expect(result == false);
}

test "valid palindrome with mixed case and punctuation" {
    const result = isPalindrome("A man, a plan, a canal: Panama");
    try testing.expect(result == true);
}

test "not a palindrome" {
    const result = isPalindrome("race a car");
    try testing.expect(result == false);
}