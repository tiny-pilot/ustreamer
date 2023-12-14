#include <stdio.h>
#include <string.h>

void print_string_info(char* value) {
  printf("len=%lu\n", strlen(value));
  printf("value=[%s]\n", value);
}

void main(void) {
  char s[] = "hi";
  printf("%s=[%c, %c, %d]\n", s, s[0], s[1], s[2]);
  printf("bytes=%lu\n", sizeof("hello"));
  printf("strlen=%lu\n", strlen("hello"));
  print_string_info(s);
  //print_string_info("rumplestiltskin");
}
