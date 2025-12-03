const std = @import("std");

pub fn removeElement(nums: []i32, val: i32) usize {
    var left: usize = 0;
    var right: usize = nums.len;

    while (left < right) {
        if (nums[left] == val) {
            right -= 1;
            nums[left] = nums[right];
        } else {
            left += 1;
        }
    }

    return left;
}

