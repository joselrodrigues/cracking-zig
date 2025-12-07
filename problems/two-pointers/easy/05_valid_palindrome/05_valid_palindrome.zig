const std = @import("std");

fn isAlphanumeric(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9');
}

fn toLower(c: u8) u8 {
    if (c >= 'A' and c <= 'Z') {
        return c + ('a' - 'A');
    }
    return c;
}

pub fn isPalindrome(s: []const u8) bool {
    if (s.len == 0) return true;

    var left: usize = 0;
    var right: usize = s.len - 1;

    while (left < right) {
        while (left < right and !isAlphanumeric(s[left])) {
            left += 1;
        }
        while (left < right and !isAlphanumeric(s[right])) {
            right -= 1;
        }

        if (toLower(s[left]) != toLower(s[right])) {
            return false;
        }

        left += 1;
        if (right == 0) break;
        right -= 1;
    }

    return true;
}