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
    const zCopy: [:0]u8 = std.mem.span(cCopy);
    //const length = std.mem.len(cCopy);
    const copy = try allocator.alloc(u8, @sizeOf(@TypeOf(zCopy)));
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
