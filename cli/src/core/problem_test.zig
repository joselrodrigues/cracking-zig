const std = @import("std");
const testing = std.testing;
const problem = @import("problem.zig");
const Problem = problem.Problem;
const Difficulty = problem.Difficulty;

test "Difficulty fromString" {
    try testing.expectEqual(Difficulty.easy, Difficulty.fromString("easy").?);
    try testing.expectEqual(Difficulty.medium, Difficulty.fromString("medium").?);
    try testing.expectEqual(Difficulty.hard, Difficulty.fromString("hard").?);
    try testing.expectEqual(@as(?Difficulty, null), Difficulty.fromString("invalid"));
}

test "scanProblems finds problems" {
    const allocator = testing.allocator;

    const problems_path = "../problems";
    var problems_list = try problem.scanProblems(allocator, problems_path);
    defer {
        for (problems_list.items) |*p| {
            p.deinit(allocator);
        }
        problems_list.deinit(allocator);
    }

    try testing.expect(problems_list.items.len > 0);

    var found_pair_sum = false;
    for (problems_list.items) |p| {
        if (std.mem.eql(u8, p.name, "pair_sum_sorted")) {
            found_pair_sum = true;
            try testing.expectEqual(Difficulty.easy, p.difficulty);
            try testing.expectEqualStrings("two-pointers", p.pattern);
            try testing.expectEqual(@as(u8, 1), p.number);
        }
    }
    try testing.expect(found_pair_sum);
}