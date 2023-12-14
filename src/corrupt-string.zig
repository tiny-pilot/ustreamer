const std = @import("std");

pub fn main() !void {
    var s = "hi";
    std.debug.print("s[{d}]={d}\n", .{ s.len + 1, s[s.len + 1] });
    //var s = [_:0]u8{ 'h', 'e', 'l', 'l', 'o' };
    //s[s.len] = 'A';
    //std.debug.print("s[{d}]={d}\n", .{ s.len, s[s.len] });*
}
