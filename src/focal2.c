#define R_NO_REMAP

void focal2_c(
    double *input, 
    int *nrows, 
    int *ncols, 
    double *weights, 
    int *steps, 
    int *kindex, 
    int *na_rm, 
    double *na_flag, 
    int *fun,
    int *weight_fun,
    double *output
    ) {
    
    int ksize = (*steps * 2 + 1) * (*steps * 2 + 1);  // Size of weight matrix
    int i, j, q;       // Counters
    long index;        // Index of the cell to be processed
    double current;    // Current value
    int ksize_valid;   // Number of non-missing
    double dat;        // Data for current neighborhood
    int any_na;        // Flag for 'NA' in neighborhood
    double min_value;  // Minimum value in neighborhood
    double max_value;  // Maximum value in neighborhood
    
    // Loop over columns
    for(i = *steps; i < *ncols - *steps; i++) {

        // Loop over rows
        for(j = *steps; j < *nrows - *steps; j++) {
            
            dat = 0;
            ksize_valid = 0;
            index = j * *ncols + i;
            any_na = 0;
            min_value = *na_flag;
            max_value = *na_flag;

            // Loop over weights matrix
            for(q = 0; q < ksize; q++) {
            
                current = input[index + kindex[q]];
            
                // If current value is 'NA'
                if(current == *na_flag) {
                    any_na = 1;
                }
            
                // If current value is not 'NA'
                if(current != *na_flag) {
                    
                    // Increment valid values count
                    ksize_valid++;
                    
                    // Calculate *weighted* current value
                    if(*weight_fun == 1) { current = current + weights[q]; }
                    if(*weight_fun == 2) { current = current - weights[q]; }
                    if(*weight_fun == 3) { current = current * weights[q]; }
                    if(*weight_fun == 4) { current = current / weights[q]; }

                    // Update mean / sum
                    if(*fun == 1 || *fun == 2) { dat = dat + current; }
                    
                    // Update minimum / maximum
                    if(*fun == 3 && min_value == *na_flag) { min_value = current; }
                    if(*fun == 3 && min_value != *na_flag && current < min_value) { min_value = current; }
                    if(*fun == 4 && max_value == *na_flag) { max_value = current; }
                    if(*fun == 4 && max_value != *na_flag && current > max_value) { max_value = current; }
                    
                }
            
            }

            // If any non-'NA' value, calculate mean / sum / min / max
            if(ksize_valid > 0) {
                if(*fun == 1) { output[index] = dat / ksize_valid; }
                if(*fun == 2) { output[index] = dat; }
                if(*fun == 3) { output[index] = min_value; }
                if(*fun == 4) { output[index] = max_value; }
            }

            // Entire neighborhood is 'NA' -> set 'NA'
            if(ksize_valid == 0) {
                output[index] = *na_flag;
            }

            // 'na.rm=FALSE' and at least one 'NA' value in neighborhood -> set 'NA'
            if(*na_rm == 0 && any_na == 1) {
                output[index] = *na_flag;
            }
            
        }

    }

}

