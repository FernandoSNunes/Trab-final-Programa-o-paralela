__kernel void bilateral_filter(
            const unsigned int    x_img,
            const unsigned int    y_img,
            const float    radius,
            const float    sigma_dist,
            __global       float* dist_weights)
{
    int i = get_global_id(0);
    int j = get_global_id(1);
    if ((i < x_img) && (j < y_img)){
        dist_weights[i*x_img + j] = exp(0-((i - radius) * (i-radius) + (j-radius) * (j - radius)) / 2 * (sigma_dist*sigma_dist));
    }
}
    
