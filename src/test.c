#include <stdio.h>
#include <string.h>

// INSECURE: Don't do any of this in production code.
void print_rules(char* name) {
  // Create a buffer for our full string that can hold 14 characters plus a null
  // terminator.
  char str[15] = {'\0'};

  // Copy the name into the buffer.
  strcpy(str, name);

  // Copy the end of the string into the buffer.
  strcat(str, " rules!");

  // Print the contents of the full string.
  printf("%s\n", str);
}

void main(void) {
  print_rules("michael");
  print_rules("rumplestiltskin");
}
