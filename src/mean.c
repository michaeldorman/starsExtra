#define R_NO_REMAP

void mean_c(
    double *input,    // Input vector
    int *n,           // Length of 'input'
    double *na_flag,  // 'NA' flag 
    double *result    // Result (length 1)
    ) {
    
    int i;
    int n_valid = 0;    // Number of non-'NA' elements
    result[0] = 0;

    for(i = 0; i < *n; i++) {
        if(input[i] != *na_flag) {
            result[0] += input[i];
            n_valid++;
        }
    }
    if(n_valid == 0) {
        result[0] = *na_flag; 
    } else  {
        result[0] = result[0] / n_valid;
    }

}
