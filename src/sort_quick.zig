const std = @import("std");
const swap = std.mem.swap;
const math = std.math;

pub fn sort(
    comptime T: type, 
    vs: []T, 
    cmp: fn (lhs: T, rhs: T) math.Order,
) void {
    if (vs.len < 2) {
        return;
    }
    sort1(T, vs, 0, vs.len - 1, cmp);
}

fn sort1(
    comptime T: type, 
    vs: []T, 
    start: usize, 
    stop: usize, 
    cmp: fn (lhs: T, rhs: T) math.Order,
) void {
    if (start >= stop) {
        return; 
    }
    var mid = start + ((stop - start) >> 1);
    if (vs[mid] < vs[start]) {
        swap(T, &vs[mid], &vs[start]);
    }
    if (vs[stop] < vs[start]) {
        swap(T, &vs[stop], &vs[start]);
    }
    if (vs[mid] < vs[stop]) {
        swap(T, &vs[mid], &vs[stop]);
    }
    const pivot = vs[stop];
    var i = start;
    var k = start;
    var j = stop;
    while (k <= j) {
        switch (cmp(vs[k], pivot)) {
            .lt => {
                swap(T, &vs[i], &vs[k]);
                i += 1;
                k += 1;
            },
            .eq => k += 1,
            .gt => {
                swap(T, &vs[k], &vs[j]);
                j -= 1;
            },
        }
    }
    sort1(T, vs, start, i - 1, cmp);
    sort1(T, vs, j + 1, stop, cmp);
}

test "sort quick" {
    const expectEqual = std.testing.expectEqual;

    const h = struct {
        fn asc(a: i32, b: i32) math.Order {
            return math.order(a, b);
        }

        fn desc(a: i32, b: i32) math.Order {
            return math.order(b, a);
        }
    };
    
    var vs = [_]i32{5, 2, -8, 0, 7, 1, -4, 6, -9};
    sort(i32, vs[0..], h.asc);

    expectEqual(vs[0], -9);
    expectEqual(vs[1], -8);
    expectEqual(vs[2], -4);
    expectEqual(vs[3], 0);
    expectEqual(vs[4], 1);
    expectEqual(vs[5], 2);
    expectEqual(vs[6], 5);
    expectEqual(vs[7], 6);
    expectEqual(vs[8], 7);

    vs = [_]i32{5, 2, -8, 0, 7, 1, -4, 6, -9};
    sort(i32, vs[0..], h.desc);

    expectEqual(vs[8], -9);
    expectEqual(vs[7], -8);
    expectEqual(vs[6], -4);
    expectEqual(vs[5], 0);
    expectEqual(vs[4], 1);
    expectEqual(vs[3], 2);
    expectEqual(vs[2], 5);
    expectEqual(vs[1], 6);
    expectEqual(vs[0], 7);
}
