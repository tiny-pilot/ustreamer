const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

fn strlen(str: [:0]const u8) usize {
    return cString.strlen(str);
}

pub fn main() !void {
    const notNullTerminated = [_]u8{ 'h', 'i' };
    std.debug.print("strlen({s})={d}\n", .{ notNullTerminated, strlen(&notNullTerminated) });
}
