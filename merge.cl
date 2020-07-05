/*
	Fernando Sassi Nunes
	Codigo orinal do merge sort obtido em :	https://www.ime.usp.br/~pf/algoritmos/aulas/mrgsrt.html
	primeira implementação do Merge Sort paralela
*/

static void intercala (int p, int q, int r, float v[], float w[])
{
   int i, j;
   for (i = p; i < q; ++i) w[i] = v[i];
   for (j = q; j < r; ++j) w[r+q-j-1] = v[j];				//escreve na ordem inversa
   i = p; j = r-1;
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
																//barreira para garantir que todo o vetor foi copiado
	barrier(CLK_LOCAL_MEM_FENCE);
	
    int current_size = 1;
	while (current_size < N) {
      if (p + current_size < N && (p)%(2*current_size) == 0) {	//mantem apenas as threads que são potencias de 2, 
         int r = p + 2*current_size;							//eliminando metade delas a cada iteração
         if (r > N) r = N;
         intercala (p, p+current_size, r, V, w);
        }
		barrier(CLK_LOCAL_MEM_FENCE);							//garante que todas as threads ordenaram a sua parte
		current_size = 2*current_size;
    }
}
   
