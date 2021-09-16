#include "stb.h"


#define STB_IMAGE_IMPLEMENTATION
#include "./stb/stb_image.h"


unsigned char * loadImage(const char * filename, int * width, int * height, int * channels_in_file, int desired_channels) {
    return stbi_load(filename, width, height, channels_in_file, desired_channels);
}

void freeImage(unsigned char * data) {
    stbi_image_free(data);
}


const char * getFailureReason() {
    return stbi_failure_reason();
}
