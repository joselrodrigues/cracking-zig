# Combine Two Sorted Arrays

**Difficulty:** Easy
**Pattern:** Two Pointers (Opposite Directions)

## Problem Description

Given two integer arrays sorted in ascending order, merge them into a single sorted array. The first array has enough space at the end to hold all elements from both arrays. The merge must be done in-place within the first array.

## Requirements

- Merge both arrays in-place into the first array
- Maintain sorted order (non-decreasing)
- Do not allocate additional array space
- First array has extra capacity to fit all elements
- Must run in O(m + n) time

## Examples

**Case 1:**
```
Input:  nums1 = [1, 2, 3, 0, 0, 0], m = 3
        nums2 = [2, 5, 6], n = 3
Output: [1, 2, 2, 3, 5, 6]
Reason: Merging [1,2,3] and [2,5,6] produces sorted result
```

**Case 2:**
```
Input:  nums1 = [1], m = 1
        nums2 = [], n = 0
Output: [1]
Reason: nums2 is empty, nums1 stays unchanged
```

**Case 3:**
```
Input:  nums1 = [0], m = 0
        nums2 = [1], n = 1
Output: [1]
Reason: nums1 is empty (m=0), only nums2 elements remain
```

## Constraints

- nums1.length == m + n
- nums2.length == n
- 0 <= m, n <= 200
- 1 <= m + n <= 200
- -10^9 <= nums1[i], nums2[j] <= 10^9
- Both arrays are sorted in non-decreasing order

## Key Insight

Since nums1 has extra space at the END and both arrays are sorted, you can fill nums1 from the BACK to avoid overwriting unprocessed elements. Use two pointers starting from the last valid elements of each array.

## Hints

- Start from the end of both arrays, not the beginning
- Compare the largest unprocessed elements
- Place the larger element at the current write position (from the back)
- Why from the back? The extra space is at the end, so you won't overwrite needed data
- What happens when one array runs out of elements?

## Function Signature

```zig
pub fn mergeSortedArrays(nums1: []i32, m: usize, nums2: []const i32, n: usize) void
```

Merges nums2 into nums1 in-place. nums1 is modified, nothing is returned.