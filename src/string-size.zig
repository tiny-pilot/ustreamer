const std = @import("std");

pub fn main() !void {
    const s = "hi";
    std.debug.print("@sizeOf={d}\n", .{@sizeOf(@TypeOf(s.*))});
}
