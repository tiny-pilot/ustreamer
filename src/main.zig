const std = @import("std");

const base64 = @cImport({
    @cInclude("libs/base64.c");
});

fn base64Encode(data: []const u8) ![:0]const u8 {
    var cEncoded: [*c]u8 = null;
    var allocatedSize: usize = 0;

    base64.us_base64_encode(data.ptr, data.len, &cEncoded, &allocatedSize);
    const cEncodedLength = allocatedSize - 1;
    return cEncoded[0..cEncodedLength :0];
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const maxBytesToRead = 100000;
    const input = try std.io.getStdIn().readToEndAlloc(allocator, maxBytesToRead);
    defer allocator.free(input);

    const result = try base64Encode(input);
    defer std.c.free(result);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("{s}\n", .{result});
    try bw.flush();
}

// based on Zig's test helpers in std/base64.zig
fn testBase64Encode(
    input: []const u8,
    expected: [:0]const u8,
) !void {
    const actual = try base64Encode(input);
    defer std.c.free(actual.*);
    try std.testing.expectEqualStrings(expected, actual);
}

test "encode simple string" {
    try testBase64Encode("", "");
    try testBase64Encode("h", "aA==");
    try testBase64Encode("he", "aGU=");
    try testBase64Encode("hel", "aGVs");
    try testBase64Encode("hell", "aGVsbA==");
    try testBase64Encode("hello, world!", "aGVsbG8sIHdvcmxkIQ==");
}
