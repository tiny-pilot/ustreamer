const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

const StrdupError = error{
    StrdupFailure,
};

fn strdup(allocator: std.mem.Allocator, str: [:0]const u8) ![:0]u8 {
    const copy = cString.strdup(str);
    if (copy == null) {
        // Maybe we can return a better error by calling std.os.errno(), but for
        // now, return a generic error.
        return error.StrdupFailure;
    }
    defer std.c.free(copy);
    const length = std.mem.len(copy);
    allocator.
    // TODO: Copy copy into a Zig-allocated buffer.
    return copy;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const s = "hi";
    std.debug.print("s={s}\n", .{s});
    const sCopy = try strdup(s);
    defer allocator.free(sCopy);
    std.debug.print("sCopy={s}\n", .{sCopy});
}
