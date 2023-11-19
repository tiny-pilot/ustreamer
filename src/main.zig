const std = @import("std");

const base64 = @cImport({
    @cInclude("libs/base64.h");
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
    for (0..zigStringLength) |i| {
        zigString[i] = cString[i];
    }

    return zigString;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const maxBytesToRead = 100000;
    const input =  try std.io.getStdIn().readToEndAlloc(allocator, maxBytesToRead);
    defer allocator.free(input);

    std.debug.print("input: {s}\n", .{input});

    const result = try base64_encode(allocator, input);
    defer allocator.free(result);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("{s}\n", .{result});
    try bw.flush();
}

test "encode simple string" {
    const allocator = std.testing.allocator;
    const actual = try base64_encode(allocator, "hello, world!");
    defer allocator.free(actual);
    const expected = "aGVsbG8sIHdvcmxkIQ==";
    try std.testing.expectEqualStrings(@as([]const u8, expected), actual);
}

test "encode empty string" {
    const allocator = std.testing.allocator;
    const actual = try base64_encode(allocator, "");
    defer allocator.free(actual);
    const expected = "";
    try std.testing.expectEqualStrings(@as([]const u8, expected), actual);
}
