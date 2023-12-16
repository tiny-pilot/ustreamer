const std = @import("std");

// Import the base64 implementation from uStreamer's C source file.
const ustreamer = @cImport({
    @cInclude("libs/base64.c");
});

fn base64Encode(allocator: std.mem.Allocator, data: []const u8) ![:0]u8 {
    var cEncoded: [*c]u8 = null;
    var allocatedSize: usize = 0;

    ustreamer.us_base64_encode(data.ptr, data.len, &cEncoded, &allocatedSize);
    defer std.c.free(cEncoded);

    // The length of the string excludes the null-terminator, so subtract 1.
    const cEncodedLength = allocatedSize - 1;
    return cStringToZigString(allocator, cEncoded, cEncodedLength);
}

fn cStringToZigString(allocator: std.mem.Allocator, cString: [*c]const u8, cStringLength: usize) ![:0]u8 {
    // Allocate a Zig-managed buffer to contain the contents of cString.
    const zigString = try allocator.allocSentinel(u8, cStringLength, 0);

    // If we can't return the result, free the memory we allocated.
    errdefer allocator.free(zigString);

    // Create a Zig slice of cString, and declare to Zig that the slice ends
    // with a null terminator.
    const cStringSlice = cString[0..cStringLength :0];

    // Copy the contents of the C string into the Zig slice.
    @memcpy(zigString.ptr, cStringSlice);

    return zigString;
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

test "encode simple string as base64" {
    const allocator = std.testing.allocator;
    const actual = try base64Encode(allocator, "hello, world!");
    defer allocator.free(actual);
    try std.testing.expectEqualStrings("aGVsbG8sIHdvcmxkIQ==", actual);
}
