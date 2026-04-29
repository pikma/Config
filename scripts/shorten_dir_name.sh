#!/bin/bash

# This script replicates the behavior of the provided C program using `awk`,
# a standard Unix tool for stateful text processing.
#
# The C program processes text from standard input line by line, creating
# 3-letter abbreviations of "terms" while preserving certain characters
# and respecting boundaries like '/'. This awk script implements the same
# character-by-character state machine.
#
# To use it, make the script executable:
#   chmod +x bash_program.sh
#
# Then, pipe data to it, for example:
#   echo "this is a Long sentence / and another one" | ./bash_program.sh
#   ./bash_program.sh < some_file.txt

awk '
{
  # For each new line of input, reset the state variables, just as the
  # C program does inside its main `while` loop.
  output = ""
  nbTermsInDirSoFar = 0
  remainingForDir = 3    # Corresponds to MIN_DIR_SIZE
  remainingForTerm = 3   # Corresponds to TERM_SIZE

  line = $0
  len = length(line)

  # Process the entire line character by character, mimicking the `for` loop.
  for (i = 1; i <= len; i++) {
    c = substr(line, i, 1)
    prev_c = (i > 1) ? substr(line, i-1, 1) : ""

    # Define character classes using regex matching.
    # This is equivalent to the isDeleted(), isKept(), etc. functions.
    is_deleted = (c ~ /[[:space:]]/)
    is_alpha = (c ~ /[[:alpha:]]/)
    is_upper = (c ~ /[[:upper:]]/)
    is_kept = (!is_deleted && !is_alpha)

    # Determine if the character marks the beginning of a new term.
    # The logic here directly mirrors the series of `if` statements in the C code.
    beginningOfTerm = is_upper

    # A slash ("/") signals a new directory/segment.
    if (i > 1 && prev_c == "/") {
      nbTermsInDirSoFar = 0
      remainingForDir = 3
      beginningOfTerm = 1
    }

    # A letter after a non-alphanumeric character (for ex. the "b" in "f_bar").
    if (i > 1 && prev_c ~ /[^[:space:][:alpha:]]/ && is_alpha) {
      beginningOfTerm = 1
    }

    # A letter after whitespace is a new term and should be capitalized.
    if (i > 1 && prev_c ~ /[[:space:]]/ && is_alpha) {
      beginningOfTerm = 1
      c = toupper(c)
    }

    # The very first alphabetic character in a segment is a new term.
    if (nbTermsInDirSoFar == 0 && is_alpha) {
      beginningOfTerm = 1
    }

    # --- Action Logic ---
    # Decide whether to append the character to the output string or drop it.

    if (beginningOfTerm) {
      remainingForTerm = 3 # A new term gets a budget of 3 characters.
      output = output c
      remainingForDir--
      remainingForTerm--
      nbTermsInDirSoFar++
    } else if (is_kept) {
      # "Kept" characters like numbers and punctuation are always included.
      output = output c
      remainingForDir--
      remainingForTerm--
    } else if (!is_deleted && (remainingForDir > 0 || remainingForTerm > 0)) {
      # Append other characters (lowercase letters) if budget remains.
      output = output c
      remainingForDir--
      remainingForTerm--
    }
    # If none of the above conditions are met, the character is dropped.
  }

  # Use printf without a trailing newline to exactly match the C programs
  # `printf("%s", output)` behavior for each line.
  printf "%s", output
}

# The C program prints one final newline after the main loop finishes.
# The END block in awk executes once after all input has been processed.
END {
  printf "\n"
}
'
