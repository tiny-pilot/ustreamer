const std = @import("std");

pub fn main() !void {
    const s = [_:q]u8{ 'h', 'i' };
    std.debug.print("s[{d}]={d}\n", .{ s.len, s[s.len] });
}
