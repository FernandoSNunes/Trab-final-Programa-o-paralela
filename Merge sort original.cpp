/*
	Fernando Sassi Nunes
	Codigo orinal do merge sort obtido em :	https://www.ime.usp.br/~pf/algoritmos/aulas/mrgsrt.html
	primeira implementação do Merge Sort paralela
*/
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include<time.h> 
#include <sys/time.h>


//modificado via git
static void intercala (int p, int q, int r, float v[])
{
   int i, j;
   float *w;
   w =(float*) malloc ((r-p) * sizeof (float));

   for (i = p; i < q; ++i) w[i-p] = v[i];
   for (j = q; j < r; ++j) w[r-p+q-j-1] = v[j];
   i = 0; j = r-p-1;
   for (int k = p; k < r; ++k)
      if (w[i] <= w[j]) v[k] = w[i++];
      else v[k] = w[j--];
   free (w);
}

void mergesort_i (int n, float v[])
{
   int b = 1;
   while (b < n) {
      int p = 0;
      while (p + b < n) {
         int r = p + 2*b;
         if (r > n) r = n;
         intercala (p, p+b, r, v);
         p = p + 2*b; 
      }
      b = 2*b;
   }
}

int main (){
	
	srand(time(0)); 
	float V[32768];
	int N = 32768;
	
    struct timeval stop, start;
	gettimeofday(&start, NULL);
	mergesort_i(N, V);
	gettimeofday(&stop, NULL);
	printf("took %lu us\n", (stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec); 
    return 0;

}

