const std = @import("std");

// Import the base64 implementation from uStreamer's C source file.
const ustreamer = @cImport({
    @cInclude("libs/base64.c");
});

fn base64Encode(allocator: std.mem.Allocator, data: []const u8) ![:0]u8 {
    var cEncodedOptional: ?[*:0]u8 = null;
    var allocatedSize: usize = 0;

    ustreamer.us_base64_encode(data.ptr, data.len, &cEncodedOptional, &allocatedSize);
    const cEncoded: [*:0]u8 = cEncodedOptional orelse return error.UnexpectedNull;
    defer std.c.free(cEncodedOptional);

    // The allocatedSize includes the null terminator, so subtract 1 to get the
    // number of non-null characters in the string.
    const cEncodedLength = allocatedSize - 1;
    return allocator.dupeZ(u8, cEncoded[0..cEncodedLength :0]);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = "hello, world!";
    const output = try base64Encode(allocator, input);
    defer allocator.free(output);

    // Print the input and output of the base64 encode operation.
    std.debug.print("input:       {s}\n", .{input});
    std.debug.print("output:      {s}\n", .{output});
    std.debug.print("output size: {d}\n", .{output.len});
}

fn testBase64Encode(
    input: []const u8,
    expected: [:0]const u8,
) !void {
    const allocator = std.testing.allocator;
    const actual = try base64Encode(allocator, input);
    defer allocator.free(actual);
    try std.testing.expectEqualStrings(expected, actual);
}

test "encode simple data as base64" {
    try testBase64Encode("", "");
    try testBase64Encode("h", "aA==");
    try testBase64Encode("he", "aGU=");
    try testBase64Encode("hel", "aGVs");
    try testBase64Encode("hell", "aGVsbA==");
    try testBase64Encode("hello, world!", "aGVsbG8sIHdvcmxkIQ==");
    try testBase64Encode(&[_]u8{0}, "AA==");
    try testBase64Encode(&[_]u8{ 0, 0 }, "AAA=");
    try testBase64Encode(&[_]u8{ 0, 0, 0 }, "AAAA");
    try testBase64Encode(&[_]u8{255}, "/w==");
    try testBase64Encode(&[_]u8{ 255, 255 }, "//8=");
    try testBase64Encode(&[_]u8{ 255, 255, 255 }, "////");
}
