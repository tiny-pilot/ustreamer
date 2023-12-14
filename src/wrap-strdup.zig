const std = @import("std");

const cString = @cImport({
    @cInclude("string.h");
});

const StrdupError = error{
    StrdupFailure,
};

fn strdup(str: [:0]const u8) ![*:0]u8 {
    const copy = cString.strdup(str);
    if (copy == null) {
        // Maybe we can return a better error by calling std.os.errno(), but for
        // now, return a generic error.
        return error.StrdupFailure;
    }
    return copy;
}

pub fn main() !void {
    const s = "hi";
    std.debug.print("s={s}\n", .{s});
    const sCopy = try strdup(s);
    defer std.c.free(sCopy);
    std.debug.print("sCopy={s}\n", .{sCopy});
}
