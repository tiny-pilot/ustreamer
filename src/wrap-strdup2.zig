const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

fn strdup(allocator: std.mem.Allocator, str: [:0]const u8) ![:0]u8 {
    const cCopy: [*:0]u8 = cString.strdup(str) orelse return error.OutOfMemory;
    defer std.c.free(cCopy);

    const zCopy: [:0]u8 = std.mem.span(cCopy);
    const copy: [:0]u8 = try allocator.allocSentinel(u8, zCopy.len, 0);
    @memcpy(copy, zCopy);

    return copy;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const s = "hi";
    std.debug.print("s    = [{s}] (type={}, size={d}, len={d})\n", .{ s, @TypeOf(s), @sizeOf(@TypeOf(s.*)), s.len });
    const sCopy = try strdup(allocator, s);
    defer allocator.free(sCopy);
    std.debug.print("sCopy= [{s}] (type={}, size={d}, len={d})\n", .{ sCopy, @TypeOf(sCopy), @sizeOf(@TypeOf(sCopy)), sCopy.len });
}
