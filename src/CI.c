#define R_NO_REMAP
#include <math.h>

void CI_c(
    double *input,
    int *nrows,
    int *ncols,
    double *weights,
    int *steps,
    int *kindex,
    int *na_rm,
    double *na_flag,
    double *output
    ) {

    int ksize = (*steps * 2 + 1) * (*steps * 2 + 1) - 1;  // Size of weight matrix
    int i, j, q;       // Counters
    long index;        // Index of the cell to be processed
    double current;    // Current value
    int ksize_valid;   // Number of non-missing
    double dat;        // Data for current neighborhood
    int any_na;        // Flag for 'NA' in neighborhood

    // Loop over columns
    for(i = *steps; i < *ncols - *steps; i++) {

        // Loop over rows
        for(j = *steps; j < *nrows - *steps; j++) {

            dat = 0;
            ksize_valid = 0;
            index = j * *ncols + i;
            any_na = 0;

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
                    current = current - weights[q];
                    current = fmod(current + 360, 360);
                    if(current > 180) { current = 360 - current; }

                    // Update sum
                    dat = dat + current;

                }

            }

            // If any non-'NA' value, calculate mean minus 90
            if(ksize_valid > 0) {
                output[index] = (dat / ksize_valid) - 90;
            }

            // Entire neighborhood is 'NA' -> set 'NA'
            if(ksize_valid == 0) {
                output[index] = *na_flag;
            }

            // 'na.rm=FALSE' and at least one 'NA' value in neighborhood -> set 'NA'
            if(*na_rm == 0 && any_na == 1) {
                output[index] = *na_flag;
            }

            // Focal cell is -1 -> set 0
            if(input[index] == -1) {
                output[index] = 0;
            }

        }

    }

}

