#define R_NO_REMAP

void mean_c(double *input, int *n, double *na_flag, double *output);
void sum_c(double *input, int *n, double *na_flag, double *output);
void min_c(double *input, int *n, double *na_flag, double *output);
void max_c(double *input, int *n, double *na_flag, double *output);
void mode_c(double *input, int *n, double *na_flag, double *output);

void focal2_c(
    double *input,    // Values of input raster
    int *nrows,       // 'nrow' of input raster
    int *ncols,       // 'nrow' of input raster
    double *weights,  // Values of weight matrix 'w'
    double *dat,      // Values of current neighborhood
    int *steps,       // Number of extra lines around raster borders '(nrow(w) - 1) / 2
    int *kindex,      // Vector of index offsets of raster values by 'w'
    int *na_rm,       // Whether to remove 'NA'
    double *na_flag,  // 'NA' flag
    int *fun,         // Function to summarize neighborhood
    int *weight_fun,  // Function to apply on each value in neighborhood
    double *output    // Values of output (filtered) raster
    ) {
    
    int ksize = (*steps * 2 + 1) * (*steps * 2 + 1);  // Size of weight matrix
    int i, j, q;        // Counters
    long index;         // Index of the cell to be processed
    double current;     // Current value
    int ksize_valid;    // Number of non-missing
    int any_na;         // Flag for 'NA' in neighborhood
    
    // Loop over columns
    for(i = *steps; i < *ncols - *steps; i++) {

        // Loop over rows
        for(j = *steps; j < *nrows - *steps; j++) {
            
            ksize_valid = 0;
            index = j * *ncols + i;
            any_na = 0;

            // Loop over weights matrix
            for(q = 0; q < ksize; q++) {
            
                current = input[index + kindex[q]];
            
                // If current value is 'NA'
                if(current == *na_flag) {
                    any_na = 1;
                } else {
                    ksize_valid++;
                    // Calculate *weighted* current value
                    switch(*weight_fun) {
                        case 1: current = current + weights[q]; break;
                        case 2: current = current - weights[q]; break;
                        case 3: current = current * weights[q]; break;
                        case 4: current = current / weights[q]; break;
                    }
                }
            
                // Collect weighted value
                dat[q] = current;

            }

            // If any non-'NA' value, calculate mean / sum / min / max / mode
            if(ksize_valid > 0) {
                switch(*fun) {
                    case 1: mean_c(dat, &ksize, na_flag, &output[index]); break;
                    case 2: sum_c(dat, &ksize, na_flag, &output[index]); break;
                    case 3: min_c(dat, &ksize, na_flag, &output[index]);  break;
                    case 4: max_c(dat, &ksize, na_flag, &output[index]);  break;
                    case 5: mode_c(dat, &ksize, na_flag, &output[index]); break;
                }
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

