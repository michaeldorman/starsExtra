#define R_NO_REMAP
#include <math.h>

void aspect_c(
    double *input, 
    int *nrows, 
    int *ncols, 
    int *kindex, 
    double *na_flag, 
    double *output
    ) {
    
    int i, j, q;           // Counters
    long index;            // Index of the cell to be processed
    double current;        // Current value
    double dat[9];         // Data for current neighborhood
    int any_na;            // Flag for 'NA' in neighborhood
    double dzdx, dzdy, a;  // For aspect calculation

    // Loop over columns
    for(i = 1; i < *ncols - 1; i++) {

        // Loop over rows
        for(j = 1; j < *nrows - 1; j++) {

            for(q = 0; q < 9; q++) { dat[q] = *na_flag; }
            index = j * *ncols + i;
            any_na = 0;

            // Loop over weights matrix
            for(q = 0; q < 9; q++) {

                current = input[index + kindex[q]];

                // If current value is 'NA'
                if(current == *na_flag) {
                    any_na = 1;
                    continue;
                }

                // If current value is not 'NA'
                if(current != *na_flag) {
                    dat[q] = current;
                }

            }

            // If all values are valid, calculate aspect
            if(any_na == 0) {

                // Check flatness
                int equal = 0;
                for(q = 0; q < 8; q++) { 
                    if(dat[q] == dat[q+1]) { equal++; } 
                }

                // Flat terrain
                if(equal == 8) { 

                    output[index] = -1; 
                
                } else {

                    // Non-flat terrain
                    dzdx = ((dat[2] + 2*dat[5] + dat[8]) - (dat[0] + 2*dat[3] + dat[6])) / 8;
                    dzdy = ((dat[6] + 2*dat[7] + dat[8]) - (dat[0] + 2*dat[1] + dat[2])) / 8;
                    a = (180 / M_PI) * atan2(dzdy, -dzdx);
                    if (a < 0) { 
                        a = 90 - a;
                    } else {
                        if (a > 90) {
                            a = 360 - a + 90;
                        } else {
                            a = 90 - a;
                        }
                    }
                    output[index] = a;

                }

            }

            // Any 'NA' -> set 'NA'
            if(any_na == 1) {
                output[index] = *na_flag;
            }
            
        }

    }

}

