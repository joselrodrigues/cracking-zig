# Eliminate Repeated Values in Sorted Array

**Difficulty:** Easy
**Pattern:** Two Pointers (Same Direction)

## Problem Description

Given a sorted array containing duplicate values, modify the array in-place so that each unique value appears only once at the beginning of the array. Return the count of unique elements.

The operation must be done in-place with O(1) extra space. The elements beyond the count of unique values don't matter and can contain any values.

## Requirements

- Modify the array in-place
- Move all unique values to the front of the array
- Return the total count of unique elements
- Do not use extra space for another array
- Elements after position k (count) can be ignored

## Examples

**Case 1:**
```
Input:  nums = [1, 1, 2]
Output: k = 2
Result: nums = [1, 2, _]
Reason: Two unique values (1 and 2). The underscore represents that the value doesn't matter.
```

**Case 2:**
```
Input:  nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]
Output: k = 5
Result: nums = [0, 1, 2, 3, 4, _, _, _, _, _]
Reason: Five unique values. Everything after index 5 is irrelevant.
```

## Constraints

- Array length: 1 to 30,000 elements
- Values range: -100 to 100
- Input array is sorted in non-decreasing order
- Must use O(1) extra space

## Hints

- The array is already sorted, use this to your advantage
- Think about two pointers moving in the same direction
- One pointer explores the array, another marks where to place the next unique value
- When do you know you found a new unique value?

## Function Signature

```zig
pub fn removeDuplicates(nums: []i32) usize
```

The function receives a mutable slice and returns the count of unique elements.