static void intercala (int p, int q, int r, float v[], float w[])
{
   int i, j;
   //w = malloc ((r-p) * sizeof (float));

   for (i = p; i < q; ++i) w[i-p] = v[i];
   for (j = q; j < r; ++j) w[r-p+q-j-1] = v[j];
   i = 0; j = r-p-1;
   for (int k = p; k < r; ++k)
      if (w[i] <= w[j]) v[k] = w[i++];
      else v[k] = w[j--];
}


__kernel void merge_sort_gpu(
			 const int    N,
    __global       float* R,
	__global       float* w,
	__global       float* V)
{
	
    int p = get_global_id(0);
	//escreve em v os valores de R
	V[p] = R[p];
	barrier(CLK_LOCAL_MEM_FENCE);
	
    int current_size = 1;
	while (current_size < N) {
      if (p + current_size < N && p == p + 2*current_size) {
         int r = p + 2*current_size;
         if (r > N) r = N;
         intercala (p, p+current_size, r, V, w);
        }
		barrier(CLK_LOCAL_MEM_FENCE);
		current_size = 2*current_size;
    }
}
   
