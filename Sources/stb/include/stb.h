#ifndef STB_h
#define STB_h


#ifdef __cplusplus
extern "C" {
#endif


unsigned char * loadImage(const char * filename, int * width, int * height, int * channels_in_file, int desired_channels);
void freeImage(unsigned char * data);

const char * getFailureReason();


int writePNG(char const * filename, int width, int height, int channels, const void * data, int stride_in_bytes);
int writeBMP(char const * filename, int width, int height, int channels, const void * data);
int writeTGA(char const * filename, int width, int height, int channels, const void * data);
int writeJPG(char const * filename, int width, int height, int channels, const void * data, int quality);


#ifdef __cplusplus
}
#endif


#endif /* STB_h */
