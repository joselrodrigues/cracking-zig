const std = @import("std");

pub fn isPalindrome(s: []const u8) bool {
    var left: usize = 0;
    var right: usize = s.len;

    while (left < right) {
        if (!std.ascii.isAlphanumeric(s[left])) {
            left += 1;
        } else if (!std.ascii.isAlphanumeric(s[right - 1])) {
            right -= 1;
        } else {
            const leftChar = std.ascii.toLower(s[left]);
            const rightChar = std.ascii.toLower(s[right - 1]);
            if (leftChar != rightChar) {
                return false;
            }
            left += 1;
            right -= 1;
        }
    }

    return true;
}

pub fn isPalindromeOptimized(s: []const u8) bool {
    if (s.len == 0) return true;

    var left: usize = 0;
    var right: usize = s.len - 1;

    while (left < right) {
        while (left < right and !std.ascii.isAlphanumeric(s[left])) {
            left += 1;
        }
        while (left < right and !std.ascii.isAlphanumeric(s[right])) {
            right -= 1;
        }

        if (std.ascii.toLower(s[left]) != std.ascii.toLower(s[right])) {
            return false;
        }

        left += 1;
        if (right == 0) break;
        right -= 1;
    }

    return true;
}