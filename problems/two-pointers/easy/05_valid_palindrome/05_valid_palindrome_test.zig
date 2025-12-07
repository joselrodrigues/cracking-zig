const std = @import("std");
const testing = std.testing;

const valid_palindrome = @import("05_valid_palindrome.zig");
const isPalindrome = valid_palindrome.isPalindrome;

test "valid palindrome with mixed case and punctuation" {
    const result = isPalindrome("A man, a plan, a canal: Panama");
    try testing.expect(result == true);
}

test "not a palindrome" {
    const result = isPalindrome("race a car");
    try testing.expect(result == false);
}

test "empty string after filtering" {
    const result = isPalindrome(" ");
    try testing.expect(result == true);
}

test "single character" {
    const result = isPalindrome("a");
    try testing.expect(result == true);
}

test "two same characters" {
    const result = isPalindrome("aa");
    try testing.expect(result == true);
}

test "two different characters" {
    const result = isPalindrome("ab");
    try testing.expect(result == false);
}

test "palindrome with numbers" {
    const result = isPalindrome("A1b2B1a");
    try testing.expect(result == true);
}

test "only numbers palindrome" {
    const result = isPalindrome("12321");
    try testing.expect(result == true);
}

test "only special characters" {
    const result = isPalindrome(".,!");
    try testing.expect(result == true);
}

test "palindrome with spaces" {
    const result = isPalindrome("a b a");
    try testing.expect(result == true);
}