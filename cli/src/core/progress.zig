const std = @import("std");
const problem = @import("problem.zig");
const ProblemStatus = problem.ProblemStatus;

pub const ProgressEntry = struct {
    status: ProblemStatus,
    last_attempt: []const u8,
    attempts: u32,
    notes: []const u8,

    pub fn deinit(self: *ProgressEntry, allocator: std.mem.Allocator) void {
        allocator.free(self.last_attempt);
        allocator.free(self.notes);
    }
};

pub const Progress = struct {
    version: []const u8,
    problems: std.StringHashMap(ProgressEntry),

    pub fn init(allocator: std.mem.Allocator) Progress {
        return Progress{
            .version = "1.0",
            .problems = std.StringHashMap(ProgressEntry).init(allocator),
        };
    }

    pub fn deinit(self: *Progress, allocator: std.mem.Allocator) void {
        var it = self.problems.iterator();
        while (it.next()) |entry| {
            allocator.free(entry.key_ptr.*);
            var val = entry.value_ptr.*;
            val.deinit(allocator);
        }
        self.problems.deinit();
    }
};

pub fn getProgressPath(allocator: std.mem.Allocator) ![]const u8 {
    const home = std.posix.getenv("HOME") orelse return error.HomeNotFound;
    const config_dir = try std.fs.path.join(allocator, &[_][]const u8{ home, ".cracking-zig" });
    defer allocator.free(config_dir);

    std.fs.cwd().makeDir(config_dir) catch |err| {
        if (err != error.PathAlreadyExists) return err;
    };

    return try std.fs.path.join(allocator, &[_][]const u8{ home, ".cracking-zig", "progress.json" });
}

pub fn loadProgress(allocator: std.mem.Allocator) !Progress {
    const progress_path = try getProgressPath(allocator);
    defer allocator.free(progress_path);

    const file = std.fs.cwd().openFile(progress_path, .{}) catch |err| {
        if (err == error.FileNotFound) {
            return Progress.init(allocator);
        }
        return err;
    };
    defer file.close();

    const file_size = (try file.stat()).size;
    const content = try allocator.alloc(u8, file_size);
    defer allocator.free(content);
    const bytes_read = try file.read(content);
    if (bytes_read != file_size) return error.UnexpectedEof;

    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, content, .{});
    defer parsed.deinit();

    var progress = Progress.init(allocator);
    errdefer progress.deinit(allocator);

    if (parsed.value.object.get("problems")) |problems_obj| {
        if (problems_obj != .object) return error.InvalidFormat;

        var it = problems_obj.object.iterator();
        while (it.next()) |entry| {
            const key = try allocator.dupe(u8, entry.key_ptr.*);
            errdefer allocator.free(key);

            const val = entry.value_ptr.*;
            if (val != .object) continue;

            const status_str = val.object.get("status").?.string;
            const status = parseStatus(status_str) orelse .not_started;

            const last_attempt = try allocator.dupe(u8, val.object.get("last_attempt").?.string);
            errdefer allocator.free(last_attempt);

            const attempts = @as(u32, @intCast(val.object.get("attempts").?.integer));

            const notes = try allocator.dupe(u8, val.object.get("notes").?.string);
            errdefer allocator.free(notes);

            const progress_entry = ProgressEntry{
                .status = status,
                .last_attempt = last_attempt,
                .attempts = attempts,
                .notes = notes,
            };

            try progress.problems.put(key, progress_entry);
        }
    }

    return progress;
}

pub fn saveProgress(progress: *const Progress, allocator: std.mem.Allocator) !void {
    const progress_path = try getProgressPath(allocator);
    defer allocator.free(progress_path);

    const file = try std.fs.cwd().createFile(progress_path, .{});
    defer file.close();

    var buffer: std.ArrayList(u8) = .empty;
    defer buffer.deinit(allocator);

    try buffer.appendSlice(allocator, "{\n  \"version\": \"");
    try buffer.appendSlice(allocator, progress.version);
    try buffer.appendSlice(allocator, "\",\n  \"problems\": {\n");

    var it = progress.problems.iterator();
    var first = true;
    while (it.next()) |entry| {
        if (!first) {
            try buffer.appendSlice(allocator, ",\n");
        }
        first = false;

        try buffer.appendSlice(allocator, "    \"");
        try buffer.appendSlice(allocator, entry.key_ptr.*);
        try buffer.appendSlice(allocator, "\": {\n");

        try buffer.appendSlice(allocator, "      \"status\": \"");
        try buffer.appendSlice(allocator, statusToString(entry.value_ptr.*.status));
        try buffer.appendSlice(allocator, "\",\n");

        try buffer.appendSlice(allocator, "      \"last_attempt\": \"");
        try buffer.appendSlice(allocator, entry.value_ptr.*.last_attempt);
        try buffer.appendSlice(allocator, "\",\n");

        const attempts_str = try std.fmt.allocPrint(allocator, "      \"attempts\": {},\n", .{entry.value_ptr.*.attempts});
        defer allocator.free(attempts_str);
        try buffer.appendSlice(allocator, attempts_str);

        try buffer.appendSlice(allocator, "      \"notes\": \"");
        try buffer.appendSlice(allocator, entry.value_ptr.*.notes);
        try buffer.appendSlice(allocator, "\"\n");

        try buffer.appendSlice(allocator, "    }");
    }

    try buffer.appendSlice(allocator, "\n  }\n}\n");

    try file.writeAll(buffer.items);
}

pub fn getStatus(progress: *const Progress, problem_id: []const u8) ProblemStatus {
    if (progress.problems.get(problem_id)) |entry| {
        return entry.status;
    }
    return .not_started;
}

pub fn setStatus(
    progress: *Progress,
    allocator: std.mem.Allocator,
    problem_id: []const u8,
    status: ProblemStatus,
) !void {
    const now = try getCurrentTimestamp(allocator);
    defer allocator.free(now);

    if (progress.problems.getPtr(problem_id)) |entry| {
        entry.status = status;
        allocator.free(entry.last_attempt);
        entry.last_attempt = try allocator.dupe(u8, now);
        entry.attempts += 1;
    } else {
        const key = try allocator.dupe(u8, problem_id);
        errdefer allocator.free(key);

        const progress_entry = ProgressEntry{
            .status = status,
            .last_attempt = try allocator.dupe(u8, now),
            .attempts = 1,
            .notes = try allocator.dupe(u8, ""),
        };

        try progress.problems.put(key, progress_entry);
    }
}

pub fn markCompleted(
    progress: *Progress,
    allocator: std.mem.Allocator,
    problem_id: []const u8,
    tests_passed: bool,
) !void {
    if (!tests_passed) {
        return error.CannotMarkCompletedTestsFailed;
    }
    try setStatus(progress, allocator, problem_id, .completed);
}

fn getCurrentTimestamp(allocator: std.mem.Allocator) ![]const u8 {
    return try allocator.dupe(u8, "2025-01-01T00:00:00Z");
}

fn statusToString(status: ProblemStatus) []const u8 {
    return switch (status) {
        .not_started => "not_started",
        .in_progress => "in_progress",
        .completed => "completed",
    };
}

fn parseStatus(s: []const u8) ?ProblemStatus {
    if (std.mem.eql(u8, s, "not_started")) return .not_started;
    if (std.mem.eql(u8, s, "in_progress")) return .in_progress;
    if (std.mem.eql(u8, s, "completed")) return .completed;
    return null;
}