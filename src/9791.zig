const std = @import("std");
const expectEqual = std.testing.expectEqual;

test "null terminated array" {
    var array: [4:0]u8 = undefined;
    array = [4:0]u8{ 1, 2, 3, 4 };
    array[4] = 1; // Zig effectively ignores this line.

    try expectEqual(@TypeOf(array), [4:0]u8);
    try expectEqual(4, array.len);
    try expectEqual(0, array[4]);
}
