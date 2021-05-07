const swap = @import("std").mem.swap;

// TODO add cmp fn

pub fn sort(comptime T: type, vs: []T) void {
    if (vs.len < 2) {
        return;
    }
    var i = vs.len >> 1;
    var j = vs.len - 1;
    while (true) : (i -= 1) {
        sift(T, vs, i, j);
        if (i == 0) {
            break;
        }
    }
    while (j > 0) : (j -= 1) {
        swap(T, &vs[0], &vs[j]);
        sift(T, vs, 0, j - 1);
    }
}

fn sift(comptime T: type, vs: []T, start: usize, stop: usize) void {
    var i = start;
    while (i << 1 <= stop) {
        var j = i << 1;
        if (j < stop and vs[j] < vs[j + 1]) {
            j += 1;
        }
        if (vs[i] >= vs[j]) {
            return;
        }
        swap(T, &vs[i], &vs[j]);
        i = j;
    }
}

test "sort heap" {
    const expectEqual = @import("std").testing.expectEqual;
    
    var vs = [_]i32{5, 2, -8, 0, 7, 1, -4, 6, -9};
    sort(i32, vs[0..]);

    expectEqual(vs[0], -9);
    expectEqual(vs[1], -8);
    expectEqual(vs[2], -4);
    expectEqual(vs[3], 0);
    expectEqual(vs[4], 1);
    expectEqual(vs[5], 2);
    expectEqual(vs[6], 5);
    expectEqual(vs[7], 6);
    expectEqual(vs[8], 7);
}
