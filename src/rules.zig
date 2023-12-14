const std = @import("std");

fn printRules(name: [:0]const u8) void {
    var buf: [15:0]u8 = undefined;
    std.mem.copyForwards(u8, &buf, name);
    std.mem.copyForwards(u8, buf[name.len..], " rules!");

    std.debug.print("{s}", .{buf});
}

pub fn main() !void {
    comptime printRules("michael");
    comptime printRules("rumplestiltskin");
}
