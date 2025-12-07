const std = @import("std");

pub fn mergeSortedArrays(nums1: []i32, m: usize, nums2: []const i32, n: usize) void {
    var p1: usize = m;
    var p2: usize = n;
    var p: usize = m + n;
    while (p2 > 0) {
        p -= 1;
        if (p1 > 0 and nums1[p1 - 1] > nums2[p2 - 1]) {
            p1 -= 1;
            nums1[p] = nums1[p1];
        } else {
            p2 -= 1;
            nums1[p] = nums2[p2];
        }
    }
}

