const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

fn strlen(str: [*:0]const u8) usize {
    return cString.strlen(str);
}

fn printInfo(comptime S: type, s: S) void {
    std.debug.print("s is type {s}\n", .{@typeName(@TypeOf(s))});
    std.debug.print("len={d}\n", .{s.len});
    //std.debug.print("strlen={d}\n", .{strlen(s)});
    std.debug.print("@sizeOf={d}\n", .{@sizeOf(@TypeOf(s))});
}

pub fn main() !void {
    const s = "hi";
    printInfo(@TypeOf(s.*), s.*);
    const notNullTerminated = [_:0]u8{ 'h', 'i' };
    printInfo(@TypeOf(notNullTerminated), notNullTerminated);
}
