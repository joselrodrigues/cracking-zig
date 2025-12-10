const std = @import("std");
const testing = std.testing;
const progress_module = @import("progress.zig");
const Progress = progress_module.Progress;
const ProblemStatus = @import("problem.zig").ProblemStatus;

test "Progress init and deinit" {
    const allocator = testing.allocator;
    var progress = Progress.init(allocator);
    defer progress.deinit(allocator);

    try testing.expect(progress.problems.count() == 0);
}

test "getStatus returns not_started for unknown problem" {
    const allocator = testing.allocator;
    var progress = Progress.init(allocator);
    defer progress.deinit(allocator);

    const status = progress_module.getStatus(&progress, "unknown");
    try testing.expectEqual(ProblemStatus.not_started, status);
}

test "setStatus and getStatus" {
    const allocator = testing.allocator;
    var progress = Progress.init(allocator);
    defer progress.deinit(allocator);

    try progress_module.setStatus(&progress, allocator, "test_problem", .in_progress);

    const status = progress_module.getStatus(&progress, "test_problem");
    try testing.expectEqual(ProblemStatus.in_progress, status);
}

test "setStatus increments attempts" {
    const allocator = testing.allocator;
    var progress = Progress.init(allocator);
    defer progress.deinit(allocator);

    try progress_module.setStatus(&progress, allocator, "test_problem", .in_progress);
    try progress_module.setStatus(&progress, allocator, "test_problem", .completed);

    const entry = progress.problems.get("test_problem").?;
    try testing.expectEqual(@as(u32, 2), entry.attempts);
}