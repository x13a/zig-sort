pub fn sort(comptime T: type, vs: []T, cmp: fn (lhs: T, rhs: T) bool) void {
    if (vs.len < 2) {
        return;
    }
    for (vs[1..]) | v, i | {
        var j = i + 1;
        while (j > 0 and cmp(v, vs[j - 1])) : (j -= 1) {
            vs[j] = vs[j - 1];
        }
        vs[j] = v;
    }
}

test "sort insertion" {
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
