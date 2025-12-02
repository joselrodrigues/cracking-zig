pub fn pairSum(nums: []const i32, target: i32) ?[2]usize {
    var left: usize = 0;
    var right: usize = nums.len - 1;

    while (left < right) {
        const sum = nums[left] + nums[right];
        if (sum > target) {
            right -= 1;
        } else if (sum < target) {
            left += 1;
        } else {
            return [_]usize{ left, right };
        }
    }

    return null;
}
