const std = @import("std");

pub fn longestPalindrome(s: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var maxLen: usize = 1;
    var start: usize = 0;

    for (0..s.len) |i| {
        const leng1 = expand(s, i, i);
        const leng2 = if (i + 1 < s.len) expand(s, i, i + 1) else 0;

        const len = @max(leng1, leng2);
        if (len > maxLen) {
            maxLen = len;
            start = i - (len - 1) / 2;
        }
    }

    return try allocator.dupe(u8, s[start .. start + maxLen]);
}

pub fn expand(s: []const u8, left: usize, right: usize) usize {
    var l = left;
    var r = right;

    if (r >= s.len or s[l] != s[r]) return 0;

    while (l > 0 and r < s.len - 1 and s[l - 1] == s[r + 1]) {
        l -= 1;
        r += 1;
    }

    return r - l + 1;
}
