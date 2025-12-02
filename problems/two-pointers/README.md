# Two Pointers

## 📋 Definition

A two-pointer pattern refers to an algorithm that utilizes two pointers. A pointer is a variable that represents an index or position within a data structure, like an array or linked list.

Introducing a second pointer opens a new world of possibilities. Most importantly, we can make comparisons. With pointers at two different positions, we can compare the elements at the respective positions, and then make decisions based on the comparison.

## 🎯 When to Use It?

Two-pointer algorithms usually require a **linear data structure**, such as an array or linked list.

This pattern is especially powerful when:
- Working with **sorted arrays** (most common use case)
- You need to find a set of elements that fulfill certain constraints
- We can predict what happens with a pair of values or a result generated from two values

## ⚡ Complexity Analysis

### Time Complexity: O(n)
**Why?** Each element is visited at most once. Even though we have two pointers, they traverse the array in a single pass. In the worst case, both pointers together visit all n elements exactly once.

**Comparison to nested loops:** Nested loops would require O(n²) because for each element (outer loop), we compare it with every other element (inner loop).

### Space Complexity: O(1)
**Why?** We only use two pointer variables (left/right or slow/fast) regardless of the input size. No additional data structures are needed - we work directly on the input array.

## ⚡ Why Two Pointers? (vs Nested Loops)

**Without optimization (O(n²)):**
```zig
for (nums, 0..) |_, i| {
    for (nums[i + 1..], i + 1..) |_, j| {
        compare(nums[i], nums[j]);
    }
}
```

This approach does not take advantage of **predictable dynamics** that might exist in a data structure.

**With predictable dynamics (sorted array):**

An example of a data structure with predictable dynamics is a **sorted array**: when we move a pointer to the right in an ascending array, we can predict the value being moved to is greater than or equal to the current one.

```
[1  2  3  4]  sorted array
    ↑
    i

prediction: if nums[i] == 2, then nums[i + 1] ≥ 2
```

Moving a pointer to the right guarantees we're moving to a value greater than or equal to the current one.

## 🔑 Two-Pointer Strategies

### Strategy 1: Start at Opposite Ends (most common with sorted arrays)

The pointers start at opposite ends of the data structure and move toward each other based on comparisons, until a pointer crosses to the other side, usually the beginning.

```
[... 1  2  3  4 ...]
     ↑           ↑
    left       right
```

These pointers generally serve two different (or complementary) purposes. The pointers move based on comparisons at different ends of the structure.

### Strategy 2: Both Pointers Move in Same Direction

Both pointers move in the same direction, but at different speeds (or even backwards at times).

```
[... 1  2  3  4 ...]
     ↑  ↑
   slow fast
```

Similar to sliding window, but pointers generally move at different speeds.

## 📝 Key Concept: Predictable Dynamics

The power of two pointers comes from **predictable dynamics**:

- **Sorted arrays** are the most common example
- When we can predict how moving a pointer affects the values or results
- When we can make logical decisions about which pointer to move based on comparisons

---

**Last updated:** 2025-11-30