static void intercala (int p, int q, int r, float v[], float w[])
{
   int i, j;
   //w = malloc ((r-p) * sizeof (float));

   for (i = p; i < q; ++i) w[i] = v[i];
   for (j = q; j < r; ++j) w[r+q-j-1] = v[j];
   i = p; j = r-1;
   for (int k = p; k < r; ++k)
      if (w[i] <= w[j]) v[k] = w[i++];
      else v[k] = w[j--];
}

void mergesort (int n, float v[], float w[])
{
   int b = 1;
   while (b < n) {
      int p = 0;
      while (p + b < n) {
         int r = p + 2*b;
         if (r > n) r = n;
         intercala (p, p+b, r, v, w);
         p = p + 2*b; 
      }
      b = 2*b;
   }
}

__kernel void merge_sort_gpu(
			 const int    N,
    __global       float* R,
	__global       float* w,
	__global       float* V,
			 const int num_threads)
{
    int p = get_global_id(0);
	//escreve em v os valores de R
	V[p] = R[p];
	barrier(CLK_LOCAL_MEM_FENCE);
	
	if (p < num_threads) {
		int N_local = N/(num_threads);										
		if (p == num_threads-1)
			N_local = N - (num_threads -1) * N_local;
		if (N_local > 1)															
			mergesort(N_local, &V[p*N/num_threads], &w[p*N/num_threads]);			//nao da para usar N_local pois a ultima thread pode ter valor diferente
		
		barrier(CLK_LOCAL_MEM_FENCE);
		
		int current_size;
		if (N_local <= 1)
			 current_size = 1;
		else {
			current_size = N/(num_threads);
			p *= current_size;
		}
		while (current_size < N) {
		  if (p + current_size < N && (p)%(2*current_size) == 0) {
			 int r = p + 2*current_size;
			 if (r > N) r = N;
			 intercala (p, p+current_size, r, V, w);
			}
			barrier(CLK_LOCAL_MEM_FENCE);
			current_size = 2*current_size;
		}
		
	
	}
}
   
