#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .C calls */
extern void aspect_c(void *, void *, void *, void *, void *, void *);
extern void CI_c(void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void focal2_c(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void slope_c(void *, void *, void *, void *, void *, void *, void *, void *);
extern void mode_c(void *, void *, void *, void *);

static const R_CMethodDef CEntries[] = {
    {"aspect_c", (DL_FUNC) &aspect_c,  6},
    {"CI_c",     (DL_FUNC) &CI_c,      9},
    {"focal2_c", (DL_FUNC) &focal2_c, 12},
    {"slope_c",  (DL_FUNC) &slope_c,   8},
    {"mode_c",   (DL_FUNC) &mode_c,    4},
    {NULL, NULL, 0}
};

void R_init_starsExtra(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
