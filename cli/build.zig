const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "cz",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .optimize = optimize,
            .target = target,
        }),
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the CLI");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .optimize = optimize,
            .target = target,
        }),
    });

    const problem_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/core/problem_test.zig"),
            .optimize = optimize,
            .target = target,
        }),
    });

    const progress_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/core/progress_test.zig"),
            .optimize = optimize,
            .target = target,
        }),
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const run_problem_tests = b.addRunArtifact(problem_tests);
    const run_progress_tests = b.addRunArtifact(progress_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
    test_step.dependOn(&run_problem_tests.step);
    test_step.dependOn(&run_progress_tests.step);
}