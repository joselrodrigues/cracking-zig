# Valid Palindrome

**Difficulty:** Easy
**Pattern:** Two Pointers (Opposite Directions)

## Problem Description

A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string s, return true if it is a palindrome, or false otherwise.

## Requirements

- Convert uppercase to lowercase for comparison
- Ignore all non-alphanumeric characters
- Empty string (after filtering) is considered a palindrome
- Must handle strings with mixed characters (letters, numbers, symbols, spaces)
- Should run in O(n) time with O(1) space

## Examples

**Case 1:**
```
Input:  s = "A man, a plan, a canal: Panama"
Output: true
Reason: After filtering: "amanaplanacanalpanama" reads same forward and backward
```

**Case 2:**
```
Input:  s = "race a car"
Output: false
Reason: After filtering: "raceacar" is not the same reversed
```

**Case 3:**
```
Input:  s = " "
Output: true
Reason: Empty string after removing non-alphanumeric characters is a palindrome
```

## Constraints

- 1 <= s.length <= 2 * 10^5
- s consists only of printable ASCII characters

## Key Insight

Use two pointers from opposite ends. Skip non-alphanumeric characters and compare the valid characters in a case-insensitive manner. If all comparisons match, it's a palindrome.

## Hints

- Start with one pointer at the beginning and one at the end
- Move each pointer inward, skipping non-alphanumeric characters
- When both pointers point to valid characters, compare them (case-insensitive)
- If any comparison fails, return false immediately
- If pointers meet or cross, all characters matched, return true
- How do you check if a character is alphanumeric in Zig?
- How do you convert to lowercase for comparison?

## Function Signature

```zig
pub fn isPalindrome(s: []const u8) bool
```

Returns true if s is a palindrome (after filtering), false otherwise.