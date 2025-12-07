const std = @import("std");

pub fn findFirstOccurrence(haystack: []const u8, needle: []const u8) i32 {
    if (needle.len > haystack.len) {
        return -1;
    }
    var letf: usize = 0;
    var right: usize = needle.len;

    while (right <= haystack.len) {
        if (std.mem.eql(u8, haystack[letf..right], needle)) {
            return @intCast(letf);
        }
        letf += 1;
        right += 1;
    }

    return -1;
}

