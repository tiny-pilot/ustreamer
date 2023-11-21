const std = @import("std");

const base64 = @cImport({
    @cInclude("libs/base64.c");
});

fn base64_encode(allocator: std.mem.Allocator, data: []const u8) ![]const u8 {
    var input: [*c]const u8 = data.ptr;

    var cEncoded: [*c]u8 = null;
    var allocatedSize: usize = 0;

    base64.us_base64_encode(input, data.len, &cEncoded, &allocatedSize);
    defer _  = &std.c.free(cEncoded);

    return c_string_to_zig_string(allocator, cEncoded, allocatedSize);
}

fn c_string_to_zig_string(allocator: std.mem.Allocator, cString: [*c]const u8, cStringLength: usize) ![]const u8 {
    // The C-function returns a null-terminated string. Strings in Zig are not
    // null-terminated, so we need to allocate one fewer byte.
    const zigStringLength = cStringLength - 1;

    const zigString = try allocator.alloc(u8, zigStringLength);
    errdefer allocator.free(zigString);

    // TODO: Avoid iterating the whole string.
    const cStringSlice: []const u8 = std.mem.span(cString);
    @memcpy(zigString.ptr, cStringSlice);

    return zigString;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const maxBytesToRead = 100000;
    const input =  try std.io.getStdIn().readToEndAlloc(allocator, maxBytesToRead);
    defer allocator.free(input);

    const result = try base64_encode(allocator, input);
    defer allocator.free(result);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("{s}\n", .{result});
    try bw.flush();
}

// based on Zig's test helpers in std/base64.zig
fn testBase64Encode(input: []const u8, expected: []const u8, ) !void {
    const allocator = std.testing.allocator;
    const actual = try base64_encode(allocator, input);
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
}
