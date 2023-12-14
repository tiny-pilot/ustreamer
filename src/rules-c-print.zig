const std = @import("std");

const cStdio = @cImport({
    @cInclude("stdio.h");
});

fn cPrint(str: [:0]const u8) void {
    _ = cStdio.printf("%s\n", str.ptr);
}

fn printRules(name: [:0]const u8) void {
    var buf: [15:0]u8 = undefined;
    std.mem.copyForwards(u8, &buf, name);
    std.mem.copyForwards(u8, buf[name.len..], " rules!");

    cPrint(&buf);
}

pub fn main() !void {
    printRules("michael");
    //printRules("rumplestiltskin");
}
