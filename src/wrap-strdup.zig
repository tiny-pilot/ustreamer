const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

fn strdup(str: [:0]const u8) ![*:0]u8 {
    return cString.strdup(str) orelse error.OutOfMemory;
}

pub fn main() !void {
    const s = "hi";
    std.debug.print("s    = [{s}] (type={}, size={d}, len={d})\n", .{ s, @TypeOf(s), @sizeOf(@TypeOf(s.*)), s.len });
    const sCopy = try strdup(s);
    defer std.c.free(sCopy);
    std.debug.print("sCopy= [{s}] (type={}, size={d}, len={d})\n", .{ sCopy, @TypeOf(sCopy), @sizeOf(@TypeOf(sCopy)), std.mem.len(sCopy) });
}
