#define R_NO_REMAP

void max_c(
    double *input,    // Input vector
    int *n,           // Length of 'input'
    double *na_flag,  // 'NA' flag 
    double *result    // Result (length 1)
    ) {
    
    int i;
    int any_valid = 0;
    result[0] = *na_flag;

    for(i = 0; i < *n; i++) {
        if(input[i] != *na_flag) {
            if(any_valid == 0) {
                result[0] = input[i];
                any_valid = 1;
            } else {
                if(input[i] > result[0]) {
                    result[0] = input[i];
                }
            }
        }
    }

}
