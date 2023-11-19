const std = @import("std");

const base64 = @cImport({
    @cInclude("libs/base64.h");
});

fn base64_encode(allocator: std.mem.Allocator, data: []const u8) ![]const u8 {
    var input: [*c]const u8 = &data[0];

    var encoded: [*c]u8 = null;
    var allocatedSize: usize = 0;

    base64.us_base64_encode(input, data.len, &encoded, &allocatedSize);
    defer _  = &std.c.free(encoded);

    // The C-function returns a null-terminated string. Strings in Zig are not
    // null-terminated, so we need to allocate one fewer byte.
    const zEncodedSize = allocatedSize - 1;

    const z_encoded = try allocator.alloc(u8, zEncodedSize);
    errdefer allocator.free(z_encoded);
    for (0..zEncodedSize) |i| {
        z_encoded[i] = encoded[i];
    }

    return z_encoded;
}


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    const result = try base64_encode(allocator, "hello, world!");
    defer allocator.free(result);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    const expected = [_]u8{ 'a', 'G', 'V', 's', 'b', 'G', '8', 's', 'I', 'H', 'd', 'v', 'c', 'm', 'x', 'k', 'I', 'Q', '=', '=' };
    try stdout.print("expected: {any} (len={d})\n", .{ expected, expected.len });
    try stdout.print("result  : {any} (len={d})\n", .{result, result.len});
    try stdout.print("result  : {s}\n", .{result});
    try bw.flush();
}

test "test base64 encode" {
    const allocator = std.testing.allocator;
    const actual = try base64_encode(allocator, "hello, world!");
    defer allocator.free(actual);
    const expected = "aGVsbG8sIHdvcmxkIQ==";
    try std.testing.expectEqualStrings(@as([]const u8, expected), actual);
}
