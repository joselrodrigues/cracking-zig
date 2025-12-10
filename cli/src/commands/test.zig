const std = @import("std");
const problem_module = @import("../core/problem.zig");
const progress_module = @import("../core/progress.zig");
const Problem = problem_module.Problem;

pub fn run(allocator: std.mem.Allocator, problem_query: ?[]const u8) !void {
    const problem = if (problem_query) |query|
        try findProblemByQuery(allocator, query)
    else
        try detectProblemFromCwd(allocator);

    try std.fs.File.stdout().writeAll("Running tests for: ");
    try std.fs.File.stdout().writeAll(problem.id);
    try std.fs.File.stdout().writeAll("\n\n");

    const test_result = try runTests(allocator, problem);
    defer allocator.free(test_result.output);

    try std.fs.File.stdout().writeAll(test_result.output);

    if (test_result.success) {
        try std.fs.File.stdout().writeAll("\nAll tests passed!\n");

        const response = try promptMarkCompleted(allocator);
        if (response) {
            var progress = try progress_module.loadProgress(allocator);
            defer progress.deinit(allocator);

            try progress_module.setStatus(&progress, allocator, problem.id, .completed);
            try progress_module.saveProgress(&progress, allocator);

            try std.fs.File.stdout().writeAll("Problem marked as completed!\n");
        }
    } else {
        try std.fs.File.stdout().writeAll("\nTests failed.\n");
        std.process.exit(1);
    }
}

fn findProblemByQuery(allocator: std.mem.Allocator, query: []const u8) !Problem {
    const problems_path = "../problems";
    var problems_list = try problem_module.scanProblems(allocator, problems_path);
    defer {
        for (problems_list.items) |*p| {
            p.deinit(allocator);
        }
        problems_list.deinit(allocator);
    }

    for (problems_list.items) |p| {
        if (std.mem.eql(u8, p.name, query) or std.mem.indexOf(u8, p.id, query) != null) {
            return Problem{
                .id = try allocator.dupe(u8, p.id),
                .pattern = try allocator.dupe(u8, p.pattern),
                .difficulty = p.difficulty,
                .number = p.number,
                .name = try allocator.dupe(u8, p.name),
                .path = try allocator.dupe(u8, p.path),
                .status = p.status,
            };
        }
    }

    try std.fs.File.stderr().writeAll("Error: Problem not found: ");
    try std.fs.File.stderr().writeAll(query);
    try std.fs.File.stderr().writeAll("\n");
    std.process.exit(1);
}

fn detectProblemFromCwd(allocator: std.mem.Allocator) !Problem {
    const cwd_path = try std.fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd_path);

    const problems_path = "../problems";
    var problems_list = try problem_module.scanProblems(allocator, problems_path);
    defer {
        for (problems_list.items) |*p| {
            p.deinit(allocator);
        }
        problems_list.deinit(allocator);
    }

    for (problems_list.items) |p| {
        const full_path = try std.fs.realpathAlloc(allocator, p.path);
        defer allocator.free(full_path);

        if (std.mem.eql(u8, cwd_path, full_path)) {
            return Problem{
                .id = try allocator.dupe(u8, p.id),
                .pattern = try allocator.dupe(u8, p.pattern),
                .difficulty = p.difficulty,
                .number = p.number,
                .name = try allocator.dupe(u8, p.name),
                .path = try allocator.dupe(u8, p.path),
                .status = p.status,
            };
        }
    }

    try std.fs.File.stderr().writeAll("Error: Not in a problem directory\n");
    std.process.exit(1);
}

const TestResult = struct {
    success: bool,
    output: []const u8,
};

fn runTests(allocator: std.mem.Allocator, problem: Problem) !TestResult {
    const dir_name = problem.path[std.mem.lastIndexOf(u8, problem.path, "/").? + 1 ..];
    const test_file = try std.fmt.allocPrint(allocator, "{s}/{s}_test.zig", .{ problem.path, dir_name });
    defer allocator.free(test_file);

    var child = std.process.Child.init(&[_][]const u8{ "zig", "master", "test", test_file }, allocator);
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Pipe;

    try child.spawn();

    var stdout_buffer: [1024 * 1024]u8 = undefined;
    var stderr_buffer: [1024 * 1024]u8 = undefined;

    const stdout_len = try child.stdout.?.read(&stdout_buffer);
    const stderr_len = try child.stderr.?.read(&stderr_buffer);

    const term = try child.wait();

    const output = if (stderr_len > 0)
        try allocator.dupe(u8, stderr_buffer[0..stderr_len])
    else
        try allocator.dupe(u8, stdout_buffer[0..stdout_len]);

    return TestResult{
        .success = switch (term) {
            .Exited => |code| code == 0,
            else => false,
        },
        .output = output,
    };
}

fn promptMarkCompleted(allocator: std.mem.Allocator) !bool {
    try std.fs.File.stdout().writeAll("Mark as completed? [Y/n]: ");

    const stdin = std.fs.File.stdin();
    var buffer: [10]u8 = undefined;
    const bytes_read = try stdin.read(&buffer);

    if (bytes_read == 0) return true;

    const response = std.mem.trim(u8, buffer[0..bytes_read], &std.ascii.whitespace);
    _ = allocator;

    if (response.len == 0) return true;
    if (std.ascii.toLower(response[0]) == 'y') return true;
    if (std.ascii.toLower(response[0]) == 'n') return false;

    return true;
}