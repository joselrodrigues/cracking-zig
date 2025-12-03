# Sliding Window

## 📋 Definition

A sliding window refers to a contiguous subarray or substring within a larger data structure. The window is defined by two boundary indices (left and right) that mark its limits and must satisfy certain requirements.

This pattern optimizes problems by maintaining a window that slides across the data structure, avoiding the need to recalculate everything from scratch at each position.

## 🎯 When to Use It?

Sliding window is particularly useful when:
- Finding a subarray or substring that satisfies a specific objective
- Working with contiguous sequences
- The problem involves finding optimal subarrays (max, min, longest, shortest)
- You need to track something across a range of elements

## ⚡ Complexity Analysis

### Time Complexity: O(n)
**Why?** Each element is visited at most twice (once when the right pointer passes it, once when the left pointer passes it). Unlike nested loops that would be O(n²), sliding window processes elements efficiently.

### Space Complexity: O(1) to O(k)
**Why?** Depends on what you track inside the window. Often just a few variables (O(1)), sometimes a hashmap or array for counting (O(k) where k is the alphabet size or unique elements).

## 🔑 Two Types of Sliding Windows

### Type 1: Fixed Size Window

The window maintains a constant size as it traverses the data structure.

**When to use:** When the problem specifies finding something within a subarray/substring of exact length k.

**Key operations:**
- Expand window to the right
- When window reaches fixed size, slide entire window (move both left and right)

**Pattern:**
```
arr = [1, 2, 3, 4, 5], window_size = 3

[1, 2, 3] 4  5  → window at positions 0-2
 1 [2, 3, 4] 5  → slide: left++, right++
 1  2 [3, 4, 5] → slide: left++, right++
```

### Type 2: Dynamic Size Window

The window can expand or shrink as it traverses the data structure.

**When to use:** When finding the longest/shortest subarray that satisfies a condition, or when the valid window size isn't known beforehand.

**Key operations:**
- Expand window when condition allows
- Shrink window when condition is violated
- Process window when valid

**Pattern:**
```
Find longest subarray with sum ≤ target

Expand right → [1, 2, 3] → sum too large
Shrink left →  [2, 3] → valid, process
Expand right → [2, 3, 4] → continue...
```

## 📝 Basic Templates

### Fixed Window Template

```zig
pub fn fixedWindow(arr: []const i32, window_size: usize) !i32 {
    if (arr.len < window_size) return error.WindowTooLarge;

    var left: usize = 0;
    var right: usize = 0;

    while (right < arr.len) {
        // Process current element at right
        // result = process(arr[right])

        right += 1;

        // Once window reaches fixed size, slide it
        if (right - left == window_size) {
            // Process window or update result
            left += 1;
        }
    }

    return result;
}
```

### Dynamic Window Template

```zig
pub fn dynamicWindow(arr: []const i32, target: i32) i32 {
    var left: usize = 0;
    var right: usize = 0;

    while (right < arr.len) {
        // Expand window by including arr[right]
        // current_sum += arr[right]

        // Shrink window while condition is violated
        while (condition_violated) {
            // Remove arr[left] from window
            left += 1;
        }

        // Process valid window
        // Update result if needed

        right += 1;
    }

    return result;
}
```

## 💡 Common Window Operations

1. **Expand right:** Add element at right pointer to window
2. **Shrink left:** Remove element at left pointer from window
3. **Shrink right:** Remove element at right pointer (less common)
4. **Shrink both:** Remove from both ends simultaneously

**Note:** Sliding is equivalent to expanding and shrinking at the same time (moving both pointers forward).

## 📝 Key Concept: Why It Works

The power of sliding window comes from avoiding redundant work:

**Without sliding window (O(n²)):**
```zig
for (arr, 0..) |_, i| {
    for (arr[i..], i..) |_, j| {
        // Check subarray from i to j
        // Recalculate everything each time
    }
}
```

**With sliding window (O(n)):**
- Maintain state as window moves
- Only update what changed (add new element, remove old element)
- Each element processed at most twice

## ⚠️ Important Notes

- The templates emphasize pointer movement more than the specific logic of updating the window
- Window validity logic is highly problem-dependent
- Always consider what state needs to be tracked (sum, count, frequency, etc.)
- Fixed windows are simpler but less flexible than dynamic windows

---

**Last updated:** 2025-12-03