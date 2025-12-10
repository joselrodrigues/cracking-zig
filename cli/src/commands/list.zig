const std = @import("std");
const problem_module = @import("../core/problem.zig");
const progress_module = @import("../core/progress.zig");
const Problem = problem_module.Problem;
const Progress = progress_module.Progress;
const ProblemStatus = problem_module.ProblemStatus;
const Difficulty = problem_module.Difficulty;

const Color = enum {
    reset,
    green,
    yellow,
    white,

    fn code(self: Color) []const u8 {
        return switch (self) {
            .reset => "\x1b[0m",
            .green => "\x1b[32m",
            .yellow => "\x1b[33m",
            .white => "\x1b[37m",
        };
    }
};

pub fn run(allocator: std.mem.Allocator) !void {
    const problems_path = "../problems";
    var problems_list = try problem_module.scanProblems(allocator, problems_path);
    defer {
        for (problems_list.items) |*p| {
            p.deinit(allocator);
        }
        problems_list.deinit(allocator);
    }

    var progress = try progress_module.loadProgress(allocator);
    defer progress.deinit(allocator);

    for (problems_list.items) |*p| {
        p.status = progress_module.getStatus(&progress, p.id);
    }

    try printProblems(allocator, problems_list.items);
}

fn printProblems(allocator: std.mem.Allocator, problems: []Problem) !void {
    var pattern_map = std.StringHashMap(std.ArrayList(Problem)).init(allocator);
    defer {
        var it = pattern_map.iterator();
        while (it.next()) |entry| {
            allocator.free(entry.key_ptr.*);
            entry.value_ptr.*.deinit(allocator);
        }
        pattern_map.deinit();
    }

    for (problems) |p| {
        const key = try allocator.dupe(u8, p.pattern);
        const entry = try pattern_map.getOrPut(key);
        if (!entry.found_existing) {
            entry.value_ptr.* = std.ArrayList(Problem).empty;
        } else {
            allocator.free(key);
        }
        try entry.value_ptr.*.append(allocator, p);
    }

    try std.fs.File.stdout().writeAll("\n");

    var it = pattern_map.iterator();
    while (it.next()) |entry| {
        const pattern = entry.key_ptr.*;
        const pattern_problems = entry.value_ptr.*.items;

        var completed: usize = 0;
        for (pattern_problems) |p| {
            if (p.status == .completed) completed += 1;
        }

        try std.fs.File.stdout().writeAll(pattern);
        const status_line = try std.fmt.allocPrint(allocator, " ({}/{})\n", .{ completed, pattern_problems.len });
        defer allocator.free(status_line);
        try std.fs.File.stdout().writeAll(status_line);

        try printByDifficulty(allocator, pattern_problems, .easy);
        try printByDifficulty(allocator, pattern_problems, .medium);
        try printByDifficulty(allocator, pattern_problems, .hard);

        try std.fs.File.stdout().writeAll("\n");
    }
}

fn printByDifficulty(allocator: std.mem.Allocator, problems: []Problem, difficulty: Difficulty) !void {
    var filtered = std.ArrayList(Problem).empty;
    defer filtered.deinit(allocator);

    for (problems) |p| {
        if (p.difficulty == difficulty) {
            try filtered.append(allocator, p);
        }
    }

    if (filtered.items.len == 0) return;

    var completed: usize = 0;
    for (filtered.items) |p| {
        if (p.status == .completed) completed += 1;
    }

    const diff_name = @tagName(difficulty);
    try std.fs.File.stdout().writeAll("  ");
    try std.fs.File.stdout().writeAll(diff_name);
    const status_line = try std.fmt.allocPrint(allocator, " ({}/{})\n", .{ completed, filtered.items.len });
    defer allocator.free(status_line);
    try std.fs.File.stdout().writeAll(status_line);

    std.mem.sort(Problem, filtered.items, {}, problemLessThan);

    for (filtered.items) |p| {
        const status_icon = getStatusIcon(p.status);
        const color = getStatusColor(p.status);

        try std.fs.File.stdout().writeAll("    ");
        try std.fs.File.stdout().writeAll(color.code());
        try std.fs.File.stdout().writeAll(status_icon);
        try std.fs.File.stdout().writeAll(" ");

        const number_str = try std.fmt.allocPrint(allocator, "{:0>2}", .{p.number});
        defer allocator.free(number_str);
        try std.fs.File.stdout().writeAll(number_str);
        try std.fs.File.stdout().writeAll("_");
        try std.fs.File.stdout().writeAll(p.name);
        try std.fs.File.stdout().writeAll(Color.reset.code());
        try std.fs.File.stdout().writeAll("\n");
    }
}

fn problemLessThan(_: void, a: Problem, b: Problem) bool {
    return a.number < b.number;
}

fn getStatusIcon(status: ProblemStatus) []const u8 {
    return switch (status) {
        .not_started => "[ ]",
        .in_progress => "[~]",
        .completed => "[✓]",
    };
}

fn getStatusColor(status: ProblemStatus) Color {
    return switch (status) {
        .not_started => .white,
        .in_progress => .yellow,
        .completed => .green,
    };
}