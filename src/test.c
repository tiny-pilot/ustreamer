#include <stdio.h>

#include "libs/base64.h"

void main(void) {
  char *raw = "hello, world!";
  char *encoded = NULL;
  size_t encoded_bytes = 0;
  us_base64_encode((uint8_t *)raw, strlen(raw), &encoded, &encoded_bytes);
  printf("encoded=%s\n", encoded);
  printf("encoded_bytes=%u\n", encoded_bytes);
  free(encoded);
}
