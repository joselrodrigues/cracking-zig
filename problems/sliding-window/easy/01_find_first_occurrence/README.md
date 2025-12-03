# Locate Substring Position

**Difficulty:** Easy
**Pattern:** String Matching / Sliding Window

## Problem Description

Given two strings, find the starting position of the first occurrence of the second string (needle) within the first string (haystack). If the needle is not found, return -1.

## Requirements

- Return the index (0-based) of the first match
- If no match exists, return -1
- Case-sensitive matching
- Must find complete substring match

## Examples

**Case 1:**
```
Input:  haystack = "sadbutsad", needle = "sad"
Output: 0
Reason: "sad" appears at index 0 and index 6. First occurrence is at index 0.
```

**Case 2:**
```
Input:  haystack = "leetcode", needle = "leeto"
Output: -1
Reason: "leeto" does not appear anywhere in "leetcode".
```

**Case 3:**
```
Input:  haystack = "hello", needle = "ll"
Output: 2
Reason: "ll" starts at index 2.
```

## Constraints

- Haystack length: 1 to 10,000 characters
- Needle length: 1 to 10,000 characters
- Both strings contain only lowercase English letters (a-z)
- Needle will always have at least 1 character

## Hints

- Think of sliding a window of needle's length across the haystack
- For each position, check if the substring matches
- What happens when you find the first character match?
- Can you optimize by skipping positions when a mismatch occurs?

## Function Signature

```zig
pub fn findFirstOccurrence(haystack: []const u8, needle: []const u8) i32
```

Returns the starting index of the first occurrence, or -1 if not found.