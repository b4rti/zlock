const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zlock",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const raylib = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
    });

    const ziglua = b.dependency("ziglua", .{
        .target = target,
        .optimize = optimize,
        .lang = .lua54,
    });

    const zware = b.dependency("zware", .{
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    exe.linkLibrary(raylib.artifact("raylib"));
    exe.root_module.addImport("ziglua", ziglua.module("ziglua"));
    exe.linkLibrary(zware.artifact("zware"));
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
