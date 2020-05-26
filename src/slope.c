#define R_NO_REMAP
#include <math.h>

void slope_c(
    double *input, 
    int *nrows, 
    int *ncols, 
    int *kindex, 
    double *na_flag, 
    double *cellsize_x, 
    double *cellsize_y, 
    double *output
    ) {
    
    int i, j, q;           // Counters
    long index;            // Index of the cell to be processed
    double current;        // Current value
    double dat[9];         // Data for current neighborhood
    int any_na;            // Flag for 'NA' in neighborhood
    double dzdx, dzdy, s;  // For slope calculation

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

            // If all values are valid, calculate slope
            if(any_na == 0) {

                dzdx = ((dat[2] + 2*dat[5] + dat[8]) - (dat[0] + 2*dat[3] + dat[6])) / (8 * *cellsize_x);
                dzdy = ((dat[6] + 2*dat[7] + dat[8]) - (dat[0] + 2*dat[1] + dat[2])) / (8 * *cellsize_y);
                s = atan(sqrt((dzdx * dzdx) + (dzdy * dzdy))) * (180 / M_PI);
                output[index] = s;

            }

            // Any 'NA' -> set 'NA'
            if(any_na == 1) {
                output[index] = *na_flag;
            }
            
        }

    }

}
