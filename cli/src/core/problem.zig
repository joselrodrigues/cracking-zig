const std = @import("std");

pub const Difficulty = enum {
    easy,
    medium,
    hard,

    pub fn fromString(s: []const u8) ?Difficulty {
        if (std.mem.eql(u8, s, "easy")) return .easy;
        if (std.mem.eql(u8, s, "medium")) return .medium;
        if (std.mem.eql(u8, s, "hard")) return .hard;
        return null;
    }
};

pub const ProblemStatus = enum {
    not_started,
    in_progress,
    completed,
};

pub const Problem = struct {
    id: []const u8,
    pattern: []const u8,
    difficulty: Difficulty,
    number: u8,
    name: []const u8,
    path: []const u8,
    status: ProblemStatus,

    pub fn deinit(self: *Problem, allocator: std.mem.Allocator) void {
        allocator.free(self.id);
        allocator.free(self.pattern);
        allocator.free(self.name);
        allocator.free(self.path);
    }
};

pub fn scanProblems(allocator: std.mem.Allocator, root_path: []const u8) !std.ArrayList(Problem) {
    var problems: std.ArrayList(Problem) = .empty;
    errdefer problems.deinit(allocator);

    var root_dir = try std.fs.cwd().openDir(root_path, .{ .iterate = true });
    defer root_dir.close();

    var pattern_iter = root_dir.iterate();
    while (try pattern_iter.next()) |pattern_entry| {
        if (pattern_entry.kind != .directory) continue;

        var pattern_dir = try root_dir.openDir(pattern_entry.name, .{ .iterate = true });
        defer pattern_dir.close();

        var diff_iter = pattern_dir.iterate();
        while (try diff_iter.next()) |diff_entry| {
            if (diff_entry.kind != .directory) continue;

            const difficulty = Difficulty.fromString(diff_entry.name) orelse continue;

            var diff_dir = try pattern_dir.openDir(diff_entry.name, .{ .iterate = true });
            defer diff_dir.close();

            var problem_iter = diff_dir.iterate();
            while (try problem_iter.next()) |problem_entry| {
                if (problem_entry.kind != .directory) continue;

                const problem = try parseProblem(
                    allocator,
                    root_path,
                    pattern_entry.name,
                    difficulty,
                    problem_entry.name,
                ) orelse continue;

                try problems.append(allocator, problem);
            }
        }
    }

    return problems;
}

fn parseProblem(
    allocator: std.mem.Allocator,
    root_path: []const u8,
    pattern: []const u8,
    difficulty: Difficulty,
    dir_name: []const u8,
) !?Problem {
    const number_end = std.mem.indexOf(u8, dir_name, "_") orelse return null;
    const number_str = dir_name[0..number_end];
    const number = std.fmt.parseInt(u8, number_str, 10) catch return null;

    const name = dir_name[number_end + 1 ..];

    const id = try std.fmt.allocPrint(allocator, "{s}/{s}/{s}", .{ pattern, @tagName(difficulty), dir_name });
    errdefer allocator.free(id);

    const path = try std.fs.path.join(allocator, &[_][]const u8{
        root_path,
        pattern,
        @tagName(difficulty),
        dir_name,
    });
    errdefer allocator.free(path);

    if (!try validateProblemStructure(path, dir_name)) {
        allocator.free(id);
        allocator.free(path);
        return null;
    }

    return Problem{
        .id = id,
        .pattern = try allocator.dupe(u8, pattern),
        .difficulty = difficulty,
        .number = number,
        .name = try allocator.dupe(u8, name),
        .path = path,
        .status = .not_started,
    };
}

fn validateProblemStructure(dir_path: []const u8, dir_name: []const u8) !bool {
    var dir = std.fs.cwd().openDir(dir_path, .{}) catch return false;
    defer dir.close();

    const readme_name = try std.fmt.allocPrint(std.heap.page_allocator, "README.md", .{});
    defer std.heap.page_allocator.free(readme_name);

    const zig_file = try std.fmt.allocPrint(std.heap.page_allocator, "{s}.zig", .{dir_name});
    defer std.heap.page_allocator.free(zig_file);

    const test_file = try std.fmt.allocPrint(std.heap.page_allocator, "{s}_test.zig", .{dir_name});
    defer std.heap.page_allocator.free(test_file);

    dir.access(readme_name, .{}) catch return false;
    dir.access(zig_file, .{}) catch return false;
    dir.access(test_file, .{}) catch return false;

    return true;
}