#include <stdio.h>

#include "libs/base64.h"

void main(void) {
  char *input = "hello, world!";
  char *encoded = NULL;
  size_t encoded_bytes = 0;
  us_base64_encode((uint8_t *)input, strlen(input), &encoded, &encoded_bytes);
  printf("input:        %s\n", input);
  printf("output:       %s\n", encoded);
  printf("output bytes: %lu\n", encoded_bytes);
  free(encoded);
}
