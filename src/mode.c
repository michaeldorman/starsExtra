#define R_NO_REMAP

void mode_c(
    double *input,    // Input vector
    int *n,           // Length of 'input'
    double *na_flag,  // 'NA' flag 
    double *result    // Result (length 1)
    ) {

    int i, j;
    int max_count = 0;

    // Find mode
    for(i = 0; i < *n; i++) {
        int count = 0;
        for(j = 0; j < *n; ++j) {
            if(input[j] != *na_flag && input[j] == input[i]) count++;
        }
        if(count > max_count) {
            max_count = count;
            result[0] = input[i];
        }
    }

    // Find all values sharing same 'max_count'
    // ...

    // Select final result
    // ...

}
