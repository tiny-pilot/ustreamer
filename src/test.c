#include <stdio.h>

#include "libs/base64.h"

int main(void)
{
  char *raw_token = "hello world";
  char *encoded_token = NULL;
  us_base64_encode((uint8_t *)raw_token, strlen(raw_token), &encoded_token, NULL);
  printf("encoded=%s\n", encoded_token);
  for (int i = 0; i < strlen(encoded_token); i++) {
    printf("%d, ", encoded_token[i]);
  }
  printf("\n");
  free(encoded_token);
  return 0;
}
