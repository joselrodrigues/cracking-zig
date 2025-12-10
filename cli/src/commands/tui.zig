const std = @import("std");
const problem_module = @import("../core/problem.zig");
const progress_module = @import("../core/progress.zig");
const terminal = @import("../tui/terminal.zig");
const Problem = problem_module.Problem;
const ProblemStatus = problem_module.ProblemStatus;

const State = struct {
    problems: std.ArrayList(Problem),
    progress: progress_module.Progress,
    selected: usize,
    scroll_offset: usize,
    filter: std.ArrayList(u8),
    filter_mode: bool,
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

    var state = State{
        .problems = problems_list,
        .progress = progress,
        .selected = 0,
        .scroll_offset = 0,
        .filter = .empty,
        .filter_mode = false,
    };
    defer state.filter.deinit(allocator);

    const original_termios = try terminal.enableRawMode();
    defer terminal.disableRawMode(original_termios) catch {};

    try terminal.hideCursor();
    defer terminal.showCursor() catch {};

    try terminal.clearScreen();

    var running = true;
    while (running) {
        try render(allocator, &state);

        const key = try terminal.readKey();
        running = try handleInput(allocator, &state, key, original_termios);
    }

    try terminal.clearScreen();
    try terminal.moveCursor(1, 1);
}

fn render(allocator: std.mem.Allocator, state: *State) !void {
    try terminal.clearScreen();
    try terminal.moveCursor(1, 1);

    try std.fs.File.stdout().writeAll(terminal.Color.bright_cyan.code());
    try std.fs.File.stdout().writeAll("━━━ Cracking Zig ");
    try std.fs.File.stdout().writeAll(terminal.Color.reset.code());

    const total = state.problems.items.len;
    var completed: usize = 0;
    for (state.problems.items) |p| {
        if (p.status == .completed) completed += 1;
    }

    const progress_str = try std.fmt.allocPrint(allocator, "({}/{})", .{ completed, total });
    defer allocator.free(progress_str);

    try std.fs.File.stdout().writeAll(terminal.Color.bright_yellow.code());
    try std.fs.File.stdout().writeAll(progress_str);
    try std.fs.File.stdout().writeAll(terminal.Color.reset.code());
    try std.fs.File.stdout().writeAll(" ━━━\r\n\r\n");

    // Build filtered list of indices
    var filtered: std.ArrayList(usize) = .empty;
    defer filtered.deinit(allocator);

    for (state.problems.items, 0..) |p, idx| {
        if (matchesFilter(&p, state.filter.items)) {
            try filtered.append(allocator, idx);
        }
    }

    const visible_height: usize = 20;
    const start = state.scroll_offset;
    const end = @min(start + visible_height, filtered.items.len);

    for (filtered.items[start..end], start..) |idx, visible_idx| {
        const p = state.problems.items[idx];
        const is_selected = visible_idx == state.selected;

        if (is_selected) {
            try std.fs.File.stdout().writeAll(terminal.Color.bright_white.code());
            try std.fs.File.stdout().writeAll("► ");
        } else {
            try std.fs.File.stdout().writeAll("  ");
        }

        const status_icon = getStatusIcon(p.status);
        const status_color = getStatusColor(p.status);

        try std.fs.File.stdout().writeAll(status_color.code());
        try std.fs.File.stdout().writeAll(status_icon);
        try std.fs.File.stdout().writeAll(" ");

        const number_str = try std.fmt.allocPrint(allocator, "{:0>2}", .{p.number});
        defer allocator.free(number_str);

        try std.fs.File.stdout().writeAll(number_str);
        try std.fs.File.stdout().writeAll("_");
        try std.fs.File.stdout().writeAll(p.name);
        try std.fs.File.stdout().writeAll(terminal.Color.reset.code());

        try std.fs.File.stdout().writeAll(" ");
        try std.fs.File.stdout().writeAll(terminal.Color.bright_black.code());
        try std.fs.File.stdout().writeAll("(");
        try std.fs.File.stdout().writeAll(p.pattern);
        try std.fs.File.stdout().writeAll(" / ");
        try std.fs.File.stdout().writeAll(@tagName(p.difficulty));
        try std.fs.File.stdout().writeAll(")");
        try std.fs.File.stdout().writeAll(terminal.Color.reset.code());

        try std.fs.File.stdout().writeAll("\r\n");
    }

    try std.fs.File.stdout().writeAll("\r\n");
    try std.fs.File.stdout().writeAll(terminal.Color.bright_black.code());
    try std.fs.File.stdout().writeAll("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\r\n");
    try std.fs.File.stdout().writeAll(terminal.Color.reset.code());

    if (state.filter_mode) {
        try std.fs.File.stdout().writeAll("Filter: ");
        try std.fs.File.stdout().writeAll(state.filter.items);
        try std.fs.File.stdout().writeAll("_\r\n");
    } else {
        try std.fs.File.stdout().writeAll("[j/k] navigate • [enter] start • [t] test • [/] search • [q] quit\r\n");
    }
}

fn handleInput(allocator: std.mem.Allocator, state: *State, key: terminal.KeyPress, original_termios: std.posix.termios) !bool {
    if (state.filter_mode) {
        return try handleFilterInput(allocator, state, key);
    }

    // Build filtered list for navigation
    var filtered: std.ArrayList(usize) = .empty;
    defer filtered.deinit(allocator);

    for (state.problems.items, 0..) |p, idx| {
        if (matchesFilter(&p, state.filter.items)) {
            try filtered.append(allocator, idx);
        }
    }

    const filtered_count = filtered.items.len;

    switch (key.key) {
        .char => {
            const c = key.char;
            if (c == 'q' or c == 'Q') {
                return false;
            } else if (c == 'j' or c == 'J') {
                if (state.selected < filtered_count - 1) {
                    state.selected += 1;
                    if (state.selected >= state.scroll_offset + 20) {
                        state.scroll_offset += 1;
                    }
                }
            } else if (c == 'k' or c == 'K') {
                if (state.selected > 0) {
                    state.selected -= 1;
                    if (state.selected < state.scroll_offset) {
                        state.scroll_offset = state.selected;
                    }
                }
            } else if (c == '/') {
                state.filter_mode = true;
                state.filter.clearRetainingCapacity();
                state.selected = 0;
                state.scroll_offset = 0;
            }
        },
        .up => {
            if (state.selected > 0) {
                state.selected -= 1;
                if (state.selected < state.scroll_offset) {
                    state.scroll_offset = state.selected;
                }
            }
        },
        .down => {
            if (state.selected < filtered_count - 1) {
                state.selected += 1;
                if (state.selected >= state.scroll_offset + 20) {
                    state.scroll_offset += 1;
                }
            }
        },
        .enter => {
            if (filtered_count == 0) return true;

            const problem_idx = filtered.items[state.selected];
            const problem = state.problems.items[problem_idx];

            try terminal.showCursor();
            try terminal.disableRawMode(original_termios);
            try terminal.clearScreen();
            try terminal.moveCursor(1, 1);

            try openInEditor(allocator, &problem);

            try progress_module.setStatus(&state.progress, allocator, problem.id, .in_progress);
            try progress_module.saveProgress(&state.progress, allocator);

            _ = try terminal.enableRawMode();
            try terminal.hideCursor();
        },
        else => {},
    }

    return true;
}

fn handleFilterInput(allocator: std.mem.Allocator, state: *State, key: terminal.KeyPress) !bool {
    switch (key.key) {
        .char => {
            try state.filter.append(allocator, key.char);
        },
        .backspace => {
            if (state.filter.items.len > 0) {
                _ = state.filter.pop();
            }
        },
        .escape => {
            state.filter_mode = false;
            state.filter.clearRetainingCapacity();
        },
        .enter => {
            state.filter_mode = false;
        },
        else => {},
    }
    return true;
}

fn openInEditor(allocator: std.mem.Allocator, problem: *const Problem) !void {
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

fn matchesFilter(problem: *const Problem, filter: []const u8) bool {
    if (filter.len == 0) return true;

    // Check name (case-insensitive)
    if (std.ascii.indexOfIgnoreCase(problem.name, filter) != null) {
        return true;
    }

    // Check pattern (case-insensitive)
    if (std.ascii.indexOfIgnoreCase(problem.pattern, filter) != null) {
        return true;
    }

    // Check difficulty (case-insensitive)
    const difficulty_str = @tagName(problem.difficulty);
    if (std.ascii.indexOfIgnoreCase(difficulty_str, filter) != null) {
        return true;
    }

    return false;
}

fn getStatusIcon(status: ProblemStatus) []const u8 {
    return switch (status) {
        .not_started => "[ ]",
        .in_progress => "[~]",
        .completed => "[✓]",
    };
}

fn getStatusColor(status: ProblemStatus) terminal.Color {
    return switch (status) {
        .not_started => .white,
        .in_progress => .yellow,
        .completed => .green,
    };
}