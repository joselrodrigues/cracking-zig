# Longest Palindromic Substring

**Difficulty:** Medium
**Pattern:** Two Pointers (Expand Around Center)

## Problem Description

Given a string s, return the longest palindromic substring in s.

## Requirements

- Find the longest substring that reads the same forward and backward
- If multiple palindromes have the same max length, return any one of them
- Must handle both odd-length palindromes (like "aba") and even-length palindromes (like "abba")
- Should run in O(n²) time with O(1) space

## Examples

**Case 1:**
```
Input:  s = "babad"
Output: "bab"
Reason: "aba" is also valid, both have length 3
```

**Case 2:**
```
Input:  s = "cbbd"
Output: "bb"
Reason: "bb" is the longest palindrome
```

**Case 3:**
```
Input:  s = "a"
Output: "a"
Reason: Single character is always a palindrome
```

**Case 4:**
```
Input:  s = "ac"
Output: "a" or "c"
Reason: No palindrome longer than 1 character
```

## Constraints

- 1 <= s.length <= 1000
- s consists of only digits and English letters

## Key Insight

Instead of checking every substring, expand around each possible center. For each position, use two pointers to expand outward while characters match. Consider both odd-length palindromes (single character center) and even-length palindromes (two character center).

## Hints

- A palindrome mirrors around its center
- For odd-length palindromes, the center is a single character
- For even-length palindromes, the center is between two characters
- For each position i, try both: expand(i, i) and expand(i, i+1)
- Use two pointers moving outward from center while characters match
- Keep track of the longest palindrome found so far

## Function Signature

```zig
pub fn longestPalindrome(s: []const u8, allocator: std.mem.Allocator) ![]u8
```

Returns a newly allocated string containing the longest palindrome. Caller owns the memory.