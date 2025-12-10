# 3Sum

**Difficulty:** Medium
**Pattern:** Two Pointers (with Sorting)

## Problem Description

Given an integer array `nums`, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, and `j != k`, and `nums[i] + nums[j] + nums[k] == 0`.

**Notice:** The solution set must not contain duplicate triplets.

## Requirements

- Find all unique triplets that sum to zero
- Each triplet must have three different indices
- No duplicate triplets in the result
- Should run in O(n²) time

## Examples

**Case 1:**
```
Input:  nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
Reason: nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0
        nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0
        nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0
        The distinct triplets are [-1,0,1] and [-1,-1,2]
```

**Case 2:**
```
Input:  nums = [0,1,1]
Output: []
Reason: The only possible triplet does not sum up to 0
```

**Case 3:**
```
Input:  nums = [0,0,0]
Output: [[0,0,0]]
Reason: The only possible triplet sums up to 0
```

## Constraints

- 3 <= nums.length <= 3000
- -10^5 <= nums[i] <= 10^5

## Key Insight

Sort the array first, then for each element, use two-pointers to find pairs that sum to the negative of that element. Skip duplicates to avoid duplicate triplets.

## Hints

- Sort the array first: this allows you to use two-pointers and skip duplicates easily
- For each index i, fix nums[i] as the first element
- Use two pointers (left = i+1, right = n-1) to find pairs that sum to -nums[i]
- Skip duplicate values to avoid duplicate triplets
- If nums[i] > 0, you can break early (since array is sorted, no triplet can sum to 0)

## Algorithm Steps

1. Sort the array
2. For each index i from 0 to n-3:
   - Skip if nums[i] == nums[i-1] (avoid duplicates)
   - Set target = -nums[i]
   - Use two pointers: left = i+1, right = n-1
   - While left < right:
     - If sum == target: found triplet, skip duplicates, move both pointers
     - If sum < target: move left pointer right
     - If sum > target: move right pointer left

## Function Signature

```zig
pub fn threeSum(nums: []i32, allocator: std.mem.Allocator) ![]const []const i32
```

Returns a 2D array of all unique triplets. Caller is responsible for freeing memory.

**Note:** You'll need to:
1. Sort the input array first (you can modify it)
2. Allocate memory for the result array and each triplet
3. Return the result with all triplets found