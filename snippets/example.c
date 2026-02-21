#include <stdio.h>
#include <string.h>

#define MAX_HERBS 64

typedef struct {
  char name[32];
  double weight;
  int dried;
} Herb;

static Herb garden[MAX_HERBS];
static int count = 0;

/* Add a new herb to the garden. Returns 0 on success, -1 if full. */
int garden_add(const char *name, double weight, int dried) {
  if (count >= MAX_HERBS) {
    fprintf(stderr, "error: garden is full\n");
    return -1;
  }

  Herb *h = &garden[count++];
  strncpy(h->name, name, sizeof(h->name) - 1);
  h->name[sizeof(h->name) - 1] = '\0';
  h->weight = weight;
  h->dried = dried;
  return 0;
}

double total_weight(void) {
  double sum = 0.0;
  for (int i = 0; i < count; i++) {
    sum += garden[i].weight;
  }
  return sum;
}

void garden_print(void) {
  printf("%-20s %8s %6s\n", "Name", "Weight", "Dried");
  printf("%-20s %8s %6s\n", "----", "------", "-----");

  for (int i = 0; i < count; i++) {
    Herb *h = &garden[i];
    printf("%-20s %8.2f %6s\n", h->name, h->weight, h->dried ? "yes" : "no");
  }

  printf("\ntotal: %.2f g across %d herbs\n", total_weight(), count);
}

int main(int argc, char **argv) {
  garden_add("yerba mate", 50.0, 1);
  garden_add("mint", 12.5, 0);
  garden_add("chamomile", 8.75, 1);
  garden_add("rosemary", 22.3, 0);

  if (argc > 1 && strcmp(argv[1], "--quiet") == 0) {
    printf("%.2f\n", total_weight());
    return 0;
  }

  garden_print();
  return 0;
}
