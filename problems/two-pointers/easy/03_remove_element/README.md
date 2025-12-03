# Filter Out Specific Value From Array

**Difficulty:** Easy
**Pattern:** Two Pointers (Opposite Directions)

## Problem Description

Given an array of integers and a target value, modify the array in-place to remove all instances of the target value. Return the count of remaining elements.

The operation must be done in-place with O(1) extra space. The elements beyond the count of remaining values don't matter and can contain any values. The order of remaining elements doesn't need to be preserved.

## Requirements

- Modify the array in-place
- Remove all occurrences of the target value
- Return the count of remaining elements
- Do not use extra space for another array
- Elements after position k (count) can be ignored
- Order of remaining elements can be in any arrangement

## Examples

**Case 1:**
```
Input:  nums = [3, 2, 2, 3], val = 3
Output: k = 2
Result: nums = [2, 2, _, _]
Reason: Two elements remain after removing all 3s
```

**Case 2:**
```
Input:  nums = [0, 1, 2, 2, 3, 0, 4, 2], val = 2
Output: k = 5
Result: nums = [0, 1, 4, 0, 3, _, _, _]
Reason: Five elements remain. They can be in any order.
```

## Constraints

- Array length: 0 to 100 elements
- Element values: 0 to 50
- Target value: 0 to 100
- Must use O(1) extra space
- Order of remaining elements doesn't matter

## Key Insight

Since the order of remaining elements doesn't matter, you can use the opposite directions strategy to avoid unnecessary copies. Fill "holes" from the end of the array.

## Hints

- Use two pointers: one at the start, one at the end
- When you find a value to remove at the start, replace it with a valid value from the end
- This is more efficient than same direction because you avoid copying elements already in correct positions
- The key advantage: order doesn't need to be preserved

## Function Signature

```zig
pub fn removeElement(nums: []i32, val: i32) usize
```

The function receives a mutable slice and the value to remove, returns the count of remaining elements.
