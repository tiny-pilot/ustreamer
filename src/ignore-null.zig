const std = @import("std");

pub fn main() !void {
    const s = [_:0]u8{ 'h', 'e', 0, 'l', 'o' };
    std.debug.print("s={s}\n", .{s});
    std.debug.print("s.len={d}\n", .{s.len});
}
