// http://oeis.org/classic/A102549
const seq = [_]usize{
    1, 
    4, 
    10, 
    23, 
    57, 
    132, 
    301, 
    701, 
    1750,
};

pub fn sort(comptime T: type, vs: []T, cmp: fn (lhs: T, rhs: T) bool) void {
    if (vs.len < 2) {
        return;
    }
    var k: usize = 0;
    var gap: usize = 0;
    var gaps: [60]usize = undefined;
    while (k < gaps.len) : (k += 1) {
        var i = gap;
        if (k < seq.len) {
            i = seq[k];
        } else {
            i *= 2;
        }
        if (i > (vs.len >> 1)) {
            break;
        }
        gap = i;
        gaps[k] = gap;
    }
    k -= 1;
    while (true) {
        var i = gap;
        while (i < vs.len) : (i += 1) {
            const v = vs[i];
            var j = i;
            while (j >= gap and cmp(v, vs[j - gap])) : (j -= gap) {
                vs[j] = vs[j - gap];
            }
            vs[j] = v;
        }
        if (k == 0) {
            break;
        }
        k -= 1;
        gap = gaps[k];
    }
}

test "sort shell" {
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
