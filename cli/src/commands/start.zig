const std = @import("std");
const problem_module = @import("../core/problem.zig");
const progress_module = @import("../core/progress.zig");
const Problem = problem_module.Problem;

pub fn run(allocator: std.mem.Allocator, problem_query: []const u8) !void {
    const problems_path = "../problems";
    var problems_list = try problem_module.scanProblems(allocator, problems_path);
    defer {
        for (problems_list.items) |*p| {
            p.deinit(allocator);
        }
        problems_list.deinit(allocator);
    }

    const problem = findProblem(problems_list.items, problem_query) orelse {
        try std.fs.File.stderr().writeAll("Error: Problem not found: ");
        try std.fs.File.stderr().writeAll(problem_query);
        try std.fs.File.stderr().writeAll("\n");
        std.process.exit(1);
    };

    try openInEditor(allocator, problem);

    var progress = try progress_module.loadProgress(allocator);
    defer progress.deinit(allocator);

    try progress_module.setStatus(&progress, allocator, problem.id, .in_progress);
    try progress_module.saveProgress(&progress, allocator);

    try std.fs.File.stdout().writeAll("Opened problem: ");
    try std.fs.File.stdout().writeAll(problem.id);
    try std.fs.File.stdout().writeAll("\n");
}

fn findProblem(problems: []Problem, query: []const u8) ?Problem {
    for (problems) |p| {
        const number_str = std.fmt.allocPrint(std.heap.page_allocator, "{:0>2}", .{p.number}) catch continue;
        defer std.heap.page_allocator.free(number_str);

        if (std.mem.eql(u8, p.name, query)) return p;

        const full_name = std.fmt.allocPrint(std.heap.page_allocator, "{s}_{s}", .{ number_str, p.name }) catch continue;
        defer std.heap.page_allocator.free(full_name);
        if (std.mem.eql(u8, full_name, query)) return p;

        if (std.mem.eql(u8, number_str, query)) return p;

        if (std.mem.indexOf(u8, p.id, query)) |_| return p;
    }
    return null;
}

fn openInEditor(allocator: std.mem.Allocator, problem: Problem) !void {
    const editor = detectEditor();

    const readme_path = try std.fs.path.join(allocator, &[_][]const u8{ problem.path, "README.md" });
    defer allocator.free(readme_path);

    const zig_filename = try std.fmt.allocPrint(allocator, "{s}.zig", .{
        problem.path[std.mem.lastIndexOf(u8, problem.path, "/").? + 1 ..],
    });
    defer allocator.free(zig_filename);

    const zig_path = try std.fs.path.join(allocator, &[_][]const u8{ problem.path, zig_filename });
    defer allocator.free(zig_path);

    const args = try buildEditorArgs(allocator, editor, readme_path, zig_path);
    defer {
        for (args) |arg| allocator.free(arg);
        allocator.free(args);
    }

    var child = std.process.Child.init(args, allocator);
    _ = try child.spawnAndWait();
}

fn detectEditor() []const u8 {
    if (std.posix.getenv("EDITOR")) |editor| {
        return editor;
    }
    if (std.posix.getenv("VISUAL")) |visual| {
        return visual;
    }
    return "nvim";
}

fn buildEditorArgs(allocator: std.mem.Allocator, editor: []const u8, readme: []const u8, zig_file: []const u8) ![]const []const u8 {
    if (std.mem.eql(u8, editor, "nvim") or std.mem.eql(u8, editor, "vim")) {
        var args = try allocator.alloc([]const u8, 4);
        args[0] = try allocator.dupe(u8, editor);
        args[1] = try allocator.dupe(u8, "-O");
        args[2] = try allocator.dupe(u8, readme);
        args[3] = try allocator.dupe(u8, zig_file);
        return args;
    } else if (std.mem.eql(u8, editor, "code") or std.mem.indexOf(u8, editor, "vscode") != null) {
        var args = try allocator.alloc([]const u8, 4);
        args[0] = try allocator.dupe(u8, "code");
        args[1] = try allocator.dupe(u8, "--reuse-window");
        args[2] = try allocator.dupe(u8, readme);
        args[3] = try allocator.dupe(u8, zig_file);
        return args;
    } else {
        var args = try allocator.alloc([]const u8, 3);
        args[0] = try allocator.dupe(u8, editor);
        args[1] = try allocator.dupe(u8, readme);
        args[2] = try allocator.dupe(u8, zig_file);
        return args;
    }
}