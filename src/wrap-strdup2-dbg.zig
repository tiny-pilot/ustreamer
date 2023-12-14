const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

const StrdupError = error{
    StrdupFailure,
};

fn strdup(allocator: std.mem.Allocator, str: [:0]const u8) ![:0]u8 {
    const cCopy = cString.strdup(str);
    if (cCopy == null) {
        // Maybe we can return a better error by calling std.os.errno(), but for
        // now, return a generic error.
        return error.StrdupFailure;
    }
    defer std.c.free(cCopy);
    const zCopy = std.mem.span(cCopy);
    std.debug.print("type(zCopy)={}\n", .{@TypeOf(zCopy)});
    std.debug.print("size(zCopy)={d}\n", .{@sizeOf(@TypeOf(zCopy))});
    std.debug.print("zCopy.len={d}\n", .{zCopy.len});
    //const length = std.mem.len(cCopy);
    //const copy = try allocator.alloc(u8, @sizeOf(@TypeOf(zCopy)));
    const copy = try allocator.allocSentinel(u8, zCopy.len, 0);
    std.debug.print("type(copy)={}\n", .{@TypeOf(copy)});
    std.debug.print("size(copy)={d}\n", .{@sizeOf(@TypeOf(copy))});
    std.debug.print("copy.len={d}\n", .{copy.len});
    @memcpy(copy, zCopy);

    return copy;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const s = "hi";
    std.debug.print("s={s}\n", .{s});
    const sCopy = try strdup(allocator, s);
    defer allocator.free(sCopy);
    std.debug.print("sCopy={s}\n", .{sCopy});
}
