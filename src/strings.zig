const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

fn strlen(str: [*:0]const u8) usize {
    return cString.strlen(str);
}

pub fn main() !void {
    var s = "hello";
    std.debug.print("s is type {s}\n", .{@typeName(@TypeOf(s))});
    std.debug.print("len={d}\n", .{s.len});
    std.debug.print("strlen={d}\n", .{strlen(s)});
    std.debug.print("@sizeOf={d}\n", .{@sizeOf(@TypeOf(s))});
    const notNullTerminated = [_]u8{ 'h', 'i' };
    std.debug.print("notNullTerminated is type {s}\n", .{@typeName(@TypeOf(notNullTerminated))});
    //std.debug.print("strlen={d}\n", .{strlen(&notNullTerminated)});
    std.debug.print("len={d}\n", .{notNullTerminated.len});
    std.debug.print("@sizeOf={d}\n", .{@sizeOf(@TypeOf(notNullTerminated))});
    std.debug.print("val={c}\n", .{notNullTerminated[1]});
}
