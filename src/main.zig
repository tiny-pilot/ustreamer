const std = @import("std");

// Import the base64 implementation from uStreamer's C source file.
const ustreamer = @cImport({
    @cInclude("libs/base64.c");
});

pub fn main() !void {
    // Create a standard Zig string.
    const input = "hello, world!";

    // Create variables to store the ouput parameters of us_base64_encode.
    var cEncoded: [*c]u8 = null;
    var allocatedSize: usize = 0;

    // Call the uStreamer C function from Zig.
    ustreamer.us_base64_encode(input.ptr, input.len, &cEncoded, &allocatedSize);

    // Free the memory that the C function allocated when this function exits.
    defer std.c.free(cEncoded);

    // Print the input and output of the base64 encode operation.
    std.debug.print("input:       {s}\n", .{input});
    std.debug.print("output:      {s}\n", .{cEncoded});
    std.debug.print("output size: {d}\n", .{allocatedSize});
}
