const std = @import("std");

const base64 = @cImport({
    @cInclude("libs/base64.h");
});

fn base64_encode(data: []const u8) ![]const u8 {
    const dataSize = data.len;

    // Allocate memory for the encoded data and size

    var encoded: [*c]u8 = null;
    var encodedPtr: [*c][*c]u8 = &encoded;
    var allocatedSize: usize = 0;
    var allocatedPtr: [*c]usize = &allocatedSize;

    base64.us_base64_encode("yhi", dataSize, encodedPtr, allocatedPtr);

    const ex = "hello";
    return ex;
}


pub fn main() !void {
    const ex = "hello";
    const result = try base64_encode(ex);

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
