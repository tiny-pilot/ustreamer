const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

fn strlen(str: [:0]const u8) usize {
    return cString.strlen(str);
}

pub fn main() !void {
    var a = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    const s = a[0..2 :0];
    std.debug.print("strlen({s})={d}\n", .{ s, strlen(s) });
}
