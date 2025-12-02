const std = @import("std");

pub fn removeDuplicates(nums: []i32) usize {
    if (nums.len == 0) {
        return 0;
    }

    var slow_point: usize = 0;
    var fast_point: usize = slow_point + 1;

    while (fast_point < nums.len) {
        if (nums[slow_point] != nums[fast_point]) {
            slow_point += 1;
            nums[slow_point] = nums[fast_point];
        }
        fast_point += 1;
    }

    return slow_point + 1;
}

