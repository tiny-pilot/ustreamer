const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const a: [:0]u8 = try allocator.allocSentinel(u8, 100, 0);
    std.debug.print("type(a)={}, size(a)={d}\n", .{ @typeInfo(@TypeOf(a)), @sizeOf(@TypeOf(a)) });
    defer allocator.free(a);

    const b: [:0]u8 = try allocator.allocSentinel(u8, 2, 0);
    std.debug.print("size(b)={d}\n", .{@sizeOf(@TypeOf(b))});
    defer allocator.free(b);
}
