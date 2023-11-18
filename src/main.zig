const std = @import("std");

const base64 = @cImport({
    @cInclude("libs/base64.h");
});

fn base64_encode(data: []const u8) ![]const u8 {
    var input: [*c]const u8 = &data[0];

    var encoded: [*c]u8 = null;
    var allocatedSize: usize = 0;

    base64.us_base64_encode(input, data.len, &encoded, &allocatedSize);

    defer _  = &std.c.free(encoded);

    //var result: []const u8 = encoded;
    //return result;
    const ex = "hello";
    return ex;
}


pub fn main() !void {
    const result = try base64_encode("hello, world!");

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    // Print value of result to stdout
    try stdout.print("result: {any}\n", .{result});
    try bw.flush();
}



test "test base64 encode" {
    const ex = "hello";
    const result = try base64_encode(ex);
    try std.testing.expectEqual(@as([]const u8, ex), result);

    //var expected = "aGVsbG8=";
    //try std.testing.expectEqual(@as([]u8, ex), base64_encode([_]u8{ 'h', 'e', 'l', 'l', 'o' }));
}
