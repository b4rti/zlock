const std = @import("std");
const ray = @import("raylib.zig");
const lua = @import("ziglua");

const Lua = lua.Lua;

fn registerAsset(ctx: *lua.Lua) i32 {
    _ = ctx.getField(-1, "name");
    const name = ctx.toString(-1) catch return -1;
    ctx.pop(1);
    _ = ctx.getField(-1, "description");
    const description = ctx.toString(-1) catch return -2;
    ctx.pop(1);
    _ = ctx.getField(-1, "version");
    const version = ctx.toString(-1) catch return -3;
    ctx.pop(1);

    std.debug.print("ASSET: {s} ver.{s}\n", .{ name, version });
    std.debug.print("   {s}\n", .{description});

    return 0;
}

fn registerHandler(ctx: *lua.Lua) i32 {
    std.debug.print("HANDLER:\n", .{});

    _ = ctx.getField(-1, "events");
    const event_count = ctx.rawLen(-1);

    std.debug.print("   Events({}):\n", .{event_count});
    for (0..event_count) |i| {
        const lua_index: i32 = @as(i32, @intCast(i)) + 1;
        ctx.pushInteger(lua_index);
        _ = ctx.getTable(-2);
        const event_name = ctx.toString(-1) catch return -1;
        ctx.pop(1);
        std.debug.print("       {s}\n", .{event_name});
    }

    return 0;
}

fn registerBlock(ctx: *lua.Lua) i32 {
    _ = ctx.getField(-1, "name");
    const name = ctx.toString(-1) catch return -1;
    std.debug.print("BLOCK: {s}\n", .{name});
    ctx.pop(1);

    _ = ctx.getField(-1, "description");
    const description = ctx.toString(-1) catch return -2;
    std.debug.print("   {s}\n", .{description});
    ctx.pop(1);

    _ = ctx.getField(-1, "duribility");
    const duribility = ctx.toNumber(-1) catch return -3;
    std.debug.print("   Duribility: {d}\n", .{duribility});
    ctx.pop(1);

    _ = ctx.getField(-1, "textures");
    std.debug.print("   Textures:\n", .{});

    _ = ctx.getField(-1, "all");
    const texture_all = ctx.toString(-1) catch return -4;
    std.debug.print("       all -> {s}\n", .{texture_all});
    ctx.pop(1);

    _ = ctx.getField(-1, "left");
    const texture_left = ctx.toString(-1) catch return -5;
    std.debug.print("       left -> {s}\n", .{texture_left});
    ctx.pop(1);

    _ = ctx.getField(-1, "right");
    const texture_right = ctx.toString(-1) catch return -6;
    std.debug.print("       right -> {s}\n", .{texture_right});
    ctx.pop(1);

    _ = ctx.getField(-1, "front");
    const texture_front = ctx.toString(-1) catch return -7;
    std.debug.print("       front -> {s}\n", .{texture_front});
    ctx.pop(1);

    _ = ctx.getField(-1, "back");
    const texture_back = ctx.toString(-1) catch return -8;
    std.debug.print("       back -> {s}\n", .{texture_back});
    ctx.pop(1);

    _ = ctx.getField(-1, "top");
    const texture_top = ctx.toString(-1) catch return -9;
    std.debug.print("       top -> {s}\n", .{texture_top});
    ctx.pop(1);

    _ = ctx.getField(-1, "bottom");
    const texture_bottom = ctx.toString(-1) catch return -10;
    std.debug.print("       bottom -> {s}\n", .{texture_bottom});
    ctx.pop(1);

    ctx.pop(1);

    _ = ctx.getField(-1, "events");
    const event_count = ctx.rawLen(-1);

    std.debug.print("   Events({}):\n", .{event_count});
    for (0..event_count) |i| {
        const lua_index: i32 = @as(i32, @intCast(i)) + 1;
        ctx.pushInteger(lua_index);
        _ = ctx.getTable(-2);
        const event_name = ctx.toString(-1) catch return -1;
        ctx.pop(1);
        std.debug.print("       {s}\n", .{event_name});
    }

    return 0;
}

fn registerStructure(ctx: *lua.Lua) i32 {
    _ = ctx.getField(-1, "name");
    const name = ctx.toString(-1) catch return -1;
    std.debug.print("STRUCTURE: {s}\n", .{name});
    ctx.pop(1);

    _ = ctx.getField(-1, "description");
    const description = ctx.toString(-1) catch return -2;
    std.debug.print("   {s}\n", .{description});
    ctx.pop(1);

    _ = ctx.getField(-1, "mappings");
    const mapping_count = ctx.rawLen(-1);
    const table_index = ctx.absIndex(-1);
    ctx.pushNil();

    std.debug.print("   Mappings({}):\n", .{mapping_count});
    while (ctx.next(table_index)) {
        const key = ctx.toString(-2) catch return -1;
        const val = ctx.toString(-1) catch return -1;
        std.debug.print("       {s} --> {s}\n", .{ key, val });
        ctx.pop(1);
    }
    ctx.pop(1);

    _ = ctx.getField(-1, "events");
    const event_count = ctx.rawLen(-1);

    std.debug.print("   Events({}):\n", .{event_count});
    for (0..event_count) |i| {
        const lua_index: i32 = @as(i32, @intCast(i)) + 1;
        ctx.pushInteger(lua_index);
        _ = ctx.getTable(-2);
        const event_name = ctx.toString(-1) catch return -1;
        ctx.pop(1);
        std.debug.print("       {s}\n", .{event_name});
    }

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
    instance.pushFunction(lua.wrap(registerHandler));
    instance.setGlobal("registerHandler");
    instance.pushFunction(lua.wrap(registerBlock));
    instance.setGlobal("registerBlock");
    instance.pushFunction(lua.wrap(registerStructure));
    instance.setGlobal("registerStructure");

    try instance.doFile("assets/core/asset.lua");

    _ = instance.pop(1);

    ray.InitWindow(1024, 768, "Zlock 0.0.1");
    var camera = ray.Camera{
        .projection = ray.CAMERA_PERSPECTIVE,
        .position = .{ .x = 3.0, .y = 3.0, .z = 3.0 },
        .target = .{ .x = 0.0, .y = 0.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 60.0,
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
