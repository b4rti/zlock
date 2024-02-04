const std = @import("std");
const ray = @import("raylib.zig");
const lua = @import("ziglua");

const Lua = lua.Lua;

fn registerAsset(ctx: *lua.Lua) i32 {
    if (!ctx.isTable(-1)) {
        std.debug.print("ERROR: non-table passed to registerAsset!\n", .{});
    }
    _ = ctx.getField(-1, "name");
    const name = ctx.toString(-1) catch return -1;
    ctx.pop(1);
    _ = ctx.getField(-1, "description");
    const description = ctx.toString(-1) catch return -2;
    ctx.pop(1);
    _ = ctx.getField(-1, "version");
    const version = ctx.toString(-1) catch return -3;
    ctx.pop(1);

    std.debug.print("Loading: {s} ver.{s}\n", .{ name, version });
    std.debug.print("Info: {s}\n", .{description});

    return 0;
}

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const ally = gpa.allocator();
    defer _ = gpa.deinit();
    var instance = try Lua.init(&ally);
    defer instance.deinit();

    instance.open(.{ .base = true });
    instance.pushFunction(lua.wrap(registerAsset));
    instance.setGlobal("registerAsset");

    try instance.doFile("assets/core/asset.lua");

    _ = instance.pop(1);

    ray.InitWindow(1024, 768, "Zlock 0.0.1");
    var camera = ray.Camera{
        .projection = ray.CAMERA_PERSPECTIVE,
        .position = .{ .x = 3.0, .y = 3.0, .z = 3.0 },
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
    };

    const mesh = ray.GenMeshCube(1.0, 1.0, 1.0);
    const model = ray.LoadModelFromMesh(mesh);
    const texture_glowstone = ray.LoadTexture("assets/minecraft/textures/block/glowstone.png");
    const texture_redstone_ore = ray.LoadTexture("assets/minecraft/textures/block/redstone_ore.png");
    const texture_lapis_ore = ray.LoadTexture("assets/minecraft/textures/block/lapis_ore.png");
    const texture_iron_ore = ray.LoadTexture("assets/minecraft/textures/block/iron_ore.png");
    const texture_copper_ore = ray.LoadTexture("assets/minecraft/textures/block/copper_ore.png");

    ray.SetTargetFPS(120.0);

    while (!ray.WindowShouldClose()) {
        ray.UpdateCamera(&camera, ray.CAMERA_ORBITAL);

        ray.BeginDrawing();
        ray.ClearBackground(ray.BLACK);
        ray.BeginMode3D(camera);

        model.materials[0].maps[ray.MATERIAL_MAP_DIFFUSE].texture = texture_glowstone;
        ray.DrawModel(model, .{ .x = 0.0, .y = 0.0, .z = 0.0 }, 1.0, ray.WHITE);
        model.materials[0].maps[ray.MATERIAL_MAP_DIFFUSE].texture = texture_redstone_ore;
        ray.DrawModel(model, .{ .x = 1.0, .y = 0.0, .z = 0.0 }, 1.0, ray.WHITE);
        model.materials[0].maps[ray.MATERIAL_MAP_DIFFUSE].texture = texture_lapis_ore;
        ray.DrawModel(model, .{ .x = -1.0, .y = 0.0, .z = 0.0 }, 1.0, ray.WHITE);
        model.materials[0].maps[ray.MATERIAL_MAP_DIFFUSE].texture = texture_iron_ore;
        ray.DrawModel(model, .{ .x = 0.0, .y = 0.0, .z = 1.0 }, 1.0, ray.WHITE);
        model.materials[0].maps[ray.MATERIAL_MAP_DIFFUSE].texture = texture_copper_ore;
        ray.DrawModel(model, .{ .x = 0.0, .y = 0.0, .z = -1.0 }, 1.0, ray.WHITE);

        ray.EndMode3D();
        ray.DrawFPS(5.0, 5.0);
        ray.EndDrawing();
    }

    ray.CloseWindow();
}

test "simple test" {}
