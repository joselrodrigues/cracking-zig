# Find Two Numbers That Add Up to Target

**Difficulty:** Easy
**Pattern:** Two Pointers

## Problem Description

You are given an array of integers arranged in ascending order and a target sum. Your task is to find the indices of two numbers in this array that add up to the target value.

**Requirements:**

- Return the indices (positions) of the two numbers
- The order of indices in your answer doesn't matter
- If multiple valid pairs exist, return any one of them
- If no valid pair exists, return null

## Examples

**Case 1:**

```
Input:  nums = [-5, -2, 3, 4, 6], target = 7
Output: [2, 3]
Reason: The numbers at index 2 and 3 are 3 and 4, which sum to 7
```

**Case 2:**

```
Input:  nums = [1, 1, 1], target = 2
Output: [0, 1]
Note:   Other acceptable answers include [1, 0], [0, 2], [2, 0], [1, 2], or [2, 1]
```

## Constraints

- The input array is sorted in ascending order
- Array length >= 2
- Solution must use the two-pointer pattern

## Hints

- Since the array is sorted, you can use predictable dynamics
- Think about starting pointers at opposite ends
- What happens to the sum when you move the left pointer right?
- What happens to the sum when you move the right pointer left?

## Function Signature

```zig
pub fn pairSum(nums: []const i32, target: i32) ?[2]usize
```

