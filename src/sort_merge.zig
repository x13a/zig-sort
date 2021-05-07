const assert = @import("std").debug.assert;

pub fn sort(
    comptime T: type, 
    vs: []T, 
    tmp: []T, 
    cmp: fn (lhs: T, rhs: T) bool,
) void {
    assert(vs.len == tmp.len);
    sort1(T, vs, tmp, 0, vs.len, cmp);
}

fn sort1(
    comptime T: type, 
    vs: []T, 
    tmp: []T, 
    start: usize, 
    stop: usize, 
    cmp: fn (lhs: T, rhs: T) bool,
) void {
    if (stop - start < 2) {
        return;
    }
    const mid = start + ((stop - start) >> 1);
    sort1(T, vs, tmp, start, mid, cmp);
    sort1(T, vs, tmp, mid, stop, cmp);
    var i = start;
    var j = mid;
    var k = i;
    while (i < mid and j < stop) : (k += 1) {
        if (cmp(vs[i], vs[j])) {
            tmp[k] = vs[i];
            i += 1;
        } else {
            tmp[k] = vs[j];
            j += 1;
        }
    }
    while (i < mid) : (i += 1) {
        tmp[k] = vs[i];
        k += 1;
    }
    while (j < stop) : (j += 1) {
        tmp[k] = vs[j];
        k += 1;
    }
    k = start;
    while (k < stop) : (k += 1) {
        vs[k] = tmp[k];
    }
}

test "sort merge" {
    const expectEqual = @import("std").testing.expectEqual;

    const h = struct {
        fn asc(a: i32, b: i32) bool {
            return a < b;
        }

        fn desc(a: i32, b: i32) bool {
            return a > b;
        }
    };

    var vs = [_]i32{5, 2, -8, 0, 7, 1, -4, 6, -9};
    var tmp: [vs.len]i32 = undefined;
    sort(i32, vs[0..], tmp[0..], h.asc);

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
    tmp = undefined;
    sort(i32, vs[0..], tmp[0..], h.desc);
    
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
