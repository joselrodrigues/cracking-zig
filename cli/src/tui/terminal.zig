const std = @import("std");

pub const Color = enum {
    reset,
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    bright_black,
    bright_red,
    bright_green,
    bright_yellow,
    bright_blue,
    bright_magenta,
    bright_cyan,
    bright_white,

    pub fn code(self: Color) []const u8 {
        return switch (self) {
            .reset => "\x1b[0m",
            .black => "\x1b[30m",
            .red => "\x1b[31m",
            .green => "\x1b[32m",
            .yellow => "\x1b[33m",
            .blue => "\x1b[34m",
            .magenta => "\x1b[35m",
            .cyan => "\x1b[36m",
            .white => "\x1b[37m",
            .bright_black => "\x1b[90m",
            .bright_red => "\x1b[91m",
            .bright_green => "\x1b[92m",
            .bright_yellow => "\x1b[93m",
            .bright_blue => "\x1b[94m",
            .bright_magenta => "\x1b[95m",
            .bright_cyan => "\x1b[96m",
            .bright_white => "\x1b[97m",
        };
    }
};

pub fn clearScreen() !void {
    try std.fs.File.stdout().writeAll("\x1b[2J");
}

pub fn moveCursor(row: usize, col: usize) !void {
    const stdout = std.fs.File.stdout();
    var buf: [32]u8 = undefined;
    const str = try std.fmt.bufPrint(&buf, "\x1b[{};{}H", .{ row, col });
    try stdout.writeAll(str);
}

pub fn hideCursor() !void {
    try std.fs.File.stdout().writeAll("\x1b[?25l");
}

pub fn showCursor() !void {
    try std.fs.File.stdout().writeAll("\x1b[?25h");
}

pub fn enableRawMode() !std.posix.termios {
    const stdin_fd = std.fs.File.stdin().handle;
    const original = try std.posix.tcgetattr(stdin_fd);

    var raw = original;
    raw.lflag.ECHO = false;
    raw.lflag.ICANON = false;
    raw.lflag.ISIG = false;
    raw.lflag.IEXTEN = false;
    raw.iflag.IXON = false;
    raw.iflag.ICRNL = false;
    raw.iflag.BRKINT = false;
    raw.iflag.INPCK = false;
    raw.iflag.ISTRIP = false;
    raw.oflag.OPOST = false;
    raw.cflag.CSIZE = .CS8;
    raw.cc[@intFromEnum(std.posix.V.TIME)] = 0;
    raw.cc[@intFromEnum(std.posix.V.MIN)] = 1;

    try std.posix.tcsetattr(stdin_fd, .FLUSH, raw);

    return original;
}

pub fn disableRawMode(original: std.posix.termios) !void {
    const stdin_fd = std.fs.File.stdin().handle;
    try std.posix.tcsetattr(stdin_fd, .FLUSH, original);
}

pub const Key = enum {
    char,
    up,
    down,
    left,
    right,
    enter,
    escape,
    backspace,
    delete,
    unknown,
};

pub const KeyPress = struct {
    key: Key,
    char: u8,
};

pub fn readKey() !KeyPress {
    const stdin = std.fs.File.stdin();
    var buf: [3]u8 = undefined;

    const n = try stdin.read(buf[0..1]);
    if (n == 0) return KeyPress{ .key = .unknown, .char = 0 };

    const c = buf[0];

    if (c == 27) {
        const n2 = try stdin.read(buf[1..2]);
        if (n2 == 0) return KeyPress{ .key = .escape, .char = 27 };

        if (buf[1] == '[') {
            const n3 = try stdin.read(buf[2..3]);
            if (n3 == 0) return KeyPress{ .key = .unknown, .char = 0 };

            return switch (buf[2]) {
                'A' => KeyPress{ .key = .up, .char = 0 },
                'B' => KeyPress{ .key = .down, .char = 0 },
                'C' => KeyPress{ .key = .right, .char = 0 },
                'D' => KeyPress{ .key = .left, .char = 0 },
                else => KeyPress{ .key = .unknown, .char = buf[2] },
            };
        }

        return KeyPress{ .key = .escape, .char = 27 };
    }

    return switch (c) {
        '\r', '\n' => KeyPress{ .key = .enter, .char = c },
        127, 8 => KeyPress{ .key = .backspace, .char = c },
        else => KeyPress{ .key = .char, .char = c },
    };
}