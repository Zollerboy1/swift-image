#include "stb.h"


#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "./stb/stb_image_write.h"


int writePNG(char const * filename, int width, int height, int channels, const void * data, int stride_in_bytes) {
    return stbi_write_png(filename, width, height, channels, data, stride_in_bytes);
}

int writeBMP(char const * filename, int width, int height, int channels, const void * data) {
    return stbi_write_bmp(filename, width, height, channels, data);
}

int writeTGA(char const * filename, int width, int height, int channels, const void * data) {
    return stbi_write_tga(filename, width, height, channels, data);
}

int writeJPG(char const * filename, int width, int height, int channels, const void * data, int quality) {
    return stbi_write_jpg(filename, width, height, channels, data, quality);
}
