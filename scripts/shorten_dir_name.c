#include <stdio.h>
#include <ctype.h>

#define LEN_INPUT (100)
#define MIN_DIR_SIZE (3)
#define TERM_SIZE (3)

int isDeleted(char c)
{
  return isspace(c) || c == '\n';
}

int isKept(char c)
{
  if (isDeleted(c)) {
    return 0;
  }

  return !isalpha(c);
}

int isBeginningOfTerm(char c)
{
  return isupper(c);
}

void copy(char c, char * outputChar, int * remainingForDir, int * remainingForTerm)
{
  * outputChar = c;
  (*remainingForDir)--;
  (*remainingForTerm)--;
}

int main(int argc, char ** argv)
{
  char input[LEN_INPUT];
  char output[LEN_INPUT];

  int j = 0;
  int i;
  int nbTermsInDirSoFar = 0;
  int nextTerm = 0;
  int remainingForDir = MIN_DIR_SIZE;
  int remainingForTerm = TERM_SIZE;

  output[LEN_INPUT-1] = 0;

  while(fgets(input, LEN_INPUT, stdin) != NULL) {
    j = 0;
    nbTermsInDirSoFar = 0;
    nextTerm = 0;
    remainingForDir = MIN_DIR_SIZE;
    remainingForTerm = TERM_SIZE;
    //printf("%s", input);
    for (i = 0; i < LEN_INPUT && input[i] != 0; i++)
    {
      char c = input[i];
      int beginningOfTerm = isBeginningOfTerm(c);

      if (i > 1 && input[i-1] == '/')
      {
        // new dir
        nbTermsInDirSoFar = 0;
        remainingForDir = MIN_DIR_SIZE;
        beginningOfTerm = 1;
      }

      if (i > 1 && isKept(input[i-1]) && isalpha(c))
      {
        beginningOfTerm = 1;
      }

      if (i > 1 && isspace(input[i-1]) && isalpha(c))
      {
        beginningOfTerm = 1;
        c = toupper(c);
      }

      if (nbTermsInDirSoFar == 0 && isalpha(c))
        beginningOfTerm = 1;

      if (beginningOfTerm)
      {
        /*            printf("beginningOfTerm\n");*/
        remainingForTerm = TERM_SIZE;
        if (j > nextTerm)
          j = nextTerm;
        nextTerm = j + TERM_SIZE;
        copy(c, output + j, & remainingForDir, & remainingForTerm);
        nbTermsInDirSoFar++;
        j++;

      }
      else if (isKept(c))
      {
        /*            printf("isKept\n");*/
        if (nextTerm < j + 1)
          nextTerm = j + 1;
        copy(c, output + j, & remainingForDir, & remainingForTerm);
        j++;
      }
      else if (!isDeleted(c) && (remainingForDir > 0 || remainingForTerm > 0))
      {
        /*            printf("copy (%d, %d) j=%d\n", remainingForDir, remainingForTerm, j);*/
        copy(c, output + j, & remainingForDir, & remainingForTerm);
        j++;
      }
    }

    output[j] = 0;

    printf("%s", output);

    for (i = 0; i < LEN_INPUT; i++)
    {
      input[i] = 0;
      output[i] = 0;
    }
  }
  printf("\n");
}
