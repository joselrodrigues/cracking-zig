# Container With Most Water

**Difficulty:** Medium
**Pattern:** Two Pointers (Opposite Directions)

## Problem Description

You are given an integer array `height` of length n. There are n vertical lines drawn such that the two endpoints of the ith line are `(i, 0)` and `(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the maximum amount of water a container can store.

**Notice:** You may not slant the container.

## Requirements

- Find the two lines that form the largest container
- Area is calculated as: `min(height[left], height[right]) * distance`
- The container cannot be slanted (vertical walls only)
- Must run in O(n) time with O(1) space

## Examples

**Case 1:**
```
Input:  height = [1,8,6,2,5,4,8,3,7]
Output: 49
Reason: Lines at index 1 (height 8) and index 8 (height 7)
        Area = min(8, 7) * (8 - 1) = 7 * 7 = 49
```

**Case 2:**
```
Input:  height = [1,1]
Output: 1
Reason: Only two lines available
        Area = min(1, 1) * (1 - 0) = 1 * 1 = 1
```

**Case 3:**
```
Input:  height = [4,3,2,1,4]
Output: 16
Reason: Lines at index 0 and 4 (both height 4)
        Area = min(4, 4) * (4 - 0) = 4 * 4 = 16
```

## Constraints

- n == height.length
- 2 <= n <= 10^5
- 0 <= height[i] <= 10^4

## Key Insight

Start with two pointers at opposite ends (widest possible container). The area is limited by the shorter line. Moving the taller line inward can only decrease the area (width decreases, height can't improve). Therefore, always move the pointer pointing to the shorter line inward, as this is the only way to potentially find a taller line that could compensate for the decreased width.

## Hints

- Start with the widest possible container (left=0, right=n-1)
- Area = min(height[left], height[right]) * (right - left)
- Which pointer should you move? The one pointing to the shorter line
- Why? Moving the taller line can only make things worse (width decreases, height can't increase)
- Continue until pointers meet

## Function Signature

```zig
pub fn maxArea(height: []const i32) i32
```

Returns the maximum amount of water a container can store.