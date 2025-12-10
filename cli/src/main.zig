const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try printHelp();
        return;
    }

    const command = args[1];

    if (std.mem.eql(u8, command, "list")) {
        std.debug.print("TODO: implement list command\n", .{});
    } else if (std.mem.eql(u8, command, "start")) {
        std.debug.print("TODO: implement start command\n", .{});
    } else if (std.mem.eql(u8, command, "test")) {
        std.debug.print("TODO: implement test command\n", .{});
    } else if (std.mem.eql(u8, command, "--help") or std.mem.eql(u8, command, "-h")) {
        try printHelp();
    } else {
        std.debug.print("Unknown command: {s}\n\n", .{command});
        try printHelp();
        std.process.exit(1);
    }
}

fn printHelp() !void {
    try std.fs.File.stdout().writeAll(
        \\Cracking Zig - Algorithm Practice CLI
        \\
        \\Usage: cz <command> [options]
        \\
        \\Commands:
        \\  list              List all problems with status
        \\  start <problem>   Open problem in editor
        \\  test [problem]    Run tests for problem
        \\  --help, -h        Show this help message
        \\
        \\Examples:
        \\  cz list
        \\  cz start 01_pair_sum
        \\  cz test
        \\
    );
}