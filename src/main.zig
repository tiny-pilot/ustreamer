const std = @import("std");

const base64 = @cImport({
    @cInclude("libs/base64.c");
});

fn base64Encode(allocator: std.mem.Allocator, data: []const u8) ![:0]u8 {
    var cEncoded: [*c]u8 = null;
    var allocatedSize: usize = 0;

    base64.us_base64_encode(data.ptr, data.len, &cEncoded, &allocatedSize);
    defer std.c.free(cEncoded);

    return cStringToZigString(allocator, cEncoded, allocatedSize);
}

fn cStringToZigString(allocator: std.mem.Allocator, cString: [*c]const u8, cStringSize: usize) ![:0]u8 {
    // cStringSize includes the null terminator, but allocSentinel takes an
    // element count excluding the null terminator.
    const zigStringLength = cStringSize - 1;
    const zigString = try allocator.allocSentinel(u8, zigStringLength, 0);

    // If we can't return the result, free the memory we allocated.
    errdefer allocator.free(zigString);

    // Create a Zig slice of cString, and declare to Zig that the slice ends
    // with a null terminator.
    @memcpy(zigString.ptr, cString[0..cStringSize :0]);

    return zigString;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const maxBytesToRead = 100000;
    const input = try std.io.getStdIn().readToEndAlloc(allocator, maxBytesToRead);
    defer allocator.free(input);

    const result = try base64Encode(allocator, input);
    defer allocator.free(result);

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
    const allocator = std.testing.allocator;
    const actual = try base64Encode(allocator, input);
    defer allocator.free(actual);
    try std.testing.expectEqualStrings(expected, actual);
}

test "encode simple string" {
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
