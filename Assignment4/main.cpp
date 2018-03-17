#include <stdio.h>
#include <stdlib.h>
#include "glew\include\GL\glew.h"
#include "glut\glut.h"
#include <memory.h>
#include <math.h>
#include "mymath.h"
 
#define PI       3.14159265358979323846

#define NOLIGHT 0
#define GOURAUD 1
#define PHONG	2

#define SPINNER		0
#define REVOLVER	1

void setTransMatrix(float *mat, float x, float y, float z);
void multiplyMatrix(float *a, float *b);
void xProduct( float *a, float *b, float *res);
void normalize(float *a);
void setIdentMatrix( float *mat, int size);
void placeCam(float posX, float posY, float posZ, float lookX, float lookY, float lookZ);
float * rotationMatrix(float x, float y, float z, float angle);
void init();
GLuint loadBMP_custom(const char * imagepath);

struct vec3
{
	float x;
	float y;
	float z;
};

// vertices for triangle
float vertices1[] = {       -1.0f,-1.0f,-1.0f, // triangle 1 : begin
							-1.0f,-1.0f, 1.0f,
							-1.0f, 1.0f, 1.0f, // triangle 1 : end

							1.0f, 1.0f,-1.0f, // triangle 2 : begin
							-1.0f,-1.0f,-1.0f,
							-1.0f, 1.0f,-1.0f, // triangle 2 : end

							1.0f,-1.0f, 1.0f,
							-1.0f,-1.0f,-1.0f,
							1.0f,-1.0f,-1.0f,

							1.0f, 1.0f,-1.0f,
							1.0f,-1.0f,-1.0f,
							-1.0f,-1.0f,-1.0f,

							-1.0f,-1.0f,-1.0f,
							-1.0f, 1.0f, 1.0f,
							-1.0f, 1.0f,-1.0f,

							1.0f,-1.0f, 1.0f,
							-1.0f,-1.0f, 1.0f,
							-1.0f,-1.0f,-1.0f,

							-1.0f, 1.0f, 1.0f,
							-1.0f,-1.0f, 1.0f,
							1.0f,-1.0f, 1.0f,

							1.0f, 1.0f, 1.0f,
							1.0f,-1.0f,-1.0f,
							1.0f, 1.0f,-1.0f,

							1.0f,-1.0f,-1.0f,
							1.0f, 1.0f, 1.0f,
							1.0f,-1.0f, 1.0f,

							1.0f, 1.0f, 1.0f,
							1.0f, 1.0f,-1.0f,
							-1.0f, 1.0f,-1.0f,

							1.0f, 1.0f, 1.0f,
							-1.0f, 1.0f,-1.0f,
							-1.0f, 1.0f, 1.0f,

							1.0f, 1.0f, 1.0f,
							-1.0f, 1.0f, 1.0f,
							1.0f,-1.0f, 1.0f
						};

float normals1[] = {     -1.0f,0.0f,0.0f, // triangle 1 : begin
						-1.0f,0.0f,0.0f,
						-1.0f,0.0f,0.0f, // triangle 1 : end

						0.0f,0.0f,-1.0f, // triangle 2 : begin
						0.0f,0.0f,-1.0f,
						0.0f,0.0f,-1.0f, // triangle 2 : end

						0.0f,-1.0f,0.0f,
						0.0f,-1.0f,0.0f,
						0.0f,-1.0f,0.0f,

						0.0f,0.0f,-1.0f,
						0.0f,0.0f,-1.0f,
						0.0f,0.0f,-1.0f,

						-1.0f,0.0f,0.0f,
						-1.0f,0.0f,0.0f,
						-1.0f,0.0f,0.0f,

						0.0f,-1.0f,0.0f,
						0.0f,-1.0f,0.0f,
						0.0f,-1.0f,0.0f,

						0.0f,0.0f, 1.0f,
						0.0f,0.0f, 1.0f,
						0.0f,0.0f, 1.0f,

						1.0f,0.0f,0.0f,
						1.0f,0.0f,0.0f,
						1.0f,0.0f,0.0f,

						1.0f,0.0f,0.0f,
						1.0f,0.0f,0.0f,
						1.0f,0.0f,0.0f,

						0.0f, 1.0f,0.0f,
						0.0f, 1.0f,0.0f,
						0.0f, 1.0f,0.0f,

						0.0f, 1.0f,0.0f,
						0.0f, 1.0f,0.0f,
						0.0f, 1.0f,0.0f,

						0.0f,0.0f, 1.0f,
						0.0f,0.0f, 1.0f,
						0.0f,0.0f, 1.0f
						};

float colors1[] = { 0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
			0.0f, 0.0f, 1.0f, 0.3f,
            0.0f, 0.0f, 1.0f, 0.3f,
            0.0f,0.0f, 1.0f, 0.3f,
};

float colors2[] = { 1.0f, 0.0f, 0.0f, 1.0f,
					0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
	0.0f, 1.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 1.0f, 1.0f,
};

float uv[] = 
{
	0.0f, 0.0f, 
	0.0f, 1.0f,
	0.17f, 1.0f, 
	
	0.0f, 0.0f,
	0.17f, 1.0f,
	0.17f, 0.0f,
	
	0.17f, 0.0f,
	0.17f, 1.0f,
	0.34f, 1.0f,

	0.17f, 0.0f,
	0.34f, 0.0f,
	0.34f, 1.0f,

	0.34f, 0.0f,
	0.34f, 1.0f,
	0.51f, 1.0f,

	0.34f, 0.0f,
	0.51f, 0.0f,
	0.51f, 1.0f,

	0.51f, 0.0f,
	0.51f, 1.0f,
	0.67f, 1.0f,

	0.51f, 0.0f,
	0.67f, 0.0f,
	0.67f, 1.0f,

	0.67f, 0.0f,
	0.67f, 1.0f,
	0.83f, 1.0f,

	0.67f, 0.0f,
	0.83f, 0.0f,
	0.83f, 1.0f,

	0.83f, 0.0f,
	0.83f, 1.0f,
	1.0f, 1.0f,

	0.83f, 0.0f,
	1.0f, 0.0f,
	1.0f, 1.0f,
};

// shader names
char *vertexFileName = "vertex.txt";
char *fragmentFileName = "frag.txt";
 
// program and shader Id
GLuint p,v,f;
 
// vert attrib locations
GLuint vertexLoc, colorLoc, normalLoc;
 
// uniform var locations
GLuint projMatrixLoc, viewMatrixLoc, normalMatrixLoc, modelMatrixLoc;

GLuint ambientColorLoc,lightColorLoc, lightPositionLoc, ShininessLoc, StrengthLoc, EyeDirectionLoc;

GLuint matEmissiveLoc, matAmbientLoc, matDiffuseLoc, matSpecularLoc, lightDiffuseLoc, lightSpecularLoc;

GLuint textureLoc,samplerLoc;

GLuint shaderLoc;

GLuint objectIDLoc;
 
// vert array obj Id
GLuint vert[3];
 
// storage for matrices
float projMatrix[16];
float viewMatrix[16];
float normalMatrix[9];
float modelMatrix[16];

float matEmissive[] = { 0.3f, 0.3f, 0.3f };
float matAmbient[] = { 0.0f, 0.0f, 0.0f };
float matDiffuse[] = { 1.0f, 1.0f, 1.0f };
float matSpecular[] = { 0.0f, 0.0f, 0.0f };

float lightAmbient[3] = { 0.5f, 0.5f, 0.5f };
float lightDiffuse[3] = { 1.0f, 1.0f, 1.0f };
float lightSpecular[3] = { 1.0f, 1.0f, 1.0f };
GLfloat lightGlobal[] = { 0.2f, 0.2f, 0.2f };

float ambientColor[] = { 0.2f, 0.2f, 0.2f, 1.0f };
float lightColor[] = {0.9f, 0.9f, 0.9f};
float lightPosition[] = { 4.0f, 4.0f, 4.0f};
float Shininess = 20.0;
float Strength = 1.1f;
float EyeDirection[] = {0 , 0 , -5};

int shader = NOLIGHT;

int objectID;

int frame=0,time,timebase=0;
char s[50];

int viewPosition[3];
float spinnerAngle = 0.0f;
float revolverAngle = 0.0f;
float angle2 = 0.0f;
int startX;
int startY;

int selectX;
int selectY;
int window_width;
int window_height;
GLuint texID;
 
GLuint loadBMP_custom(const char * imagepath) {

	printf("Reading image %s\n", imagepath);

	// Data read from the header of the BMP file
	unsigned char header[54];
	unsigned int dataPos;
	unsigned int imageSize;
	unsigned int width, height;
	// Actual RGB data
	unsigned char * data;

	// Open the file
	FILE * file = fopen(imagepath, "rb");
	if (!file) {
		printf("%s could not be opened. Are you in the right directory ? Don't forget to read the FAQ !\n", imagepath);
		getchar();
		return 0;
	}

	// Read the header, i.e. the 54 first bytes

	// If less than 54 bytes are read, problem
	if (fread(header, 1, 54, file) != 54) {
		printf("Not a correct BMP file\n");
		fclose(file);
		return 0;
	}
	// A BMP files always begins with "BM"
	if (header[0] != 'B' || header[1] != 'M') {
		printf("Not a correct BMP file\n");
		fclose(file);
		return 0;
	}
	// Make sure this is a 24bpp file
	if (*(int*)&(header[0x1E]) != 0) { printf("Not a correct BMP file\n");    fclose(file); return 0; }
	if (*(int*)&(header[0x1C]) != 24) { printf("Not a correct BMP file\n");    fclose(file); return 0; }

	// Read the information about the image
	dataPos = *(int*)&(header[0x0A]);
	imageSize = *(int*)&(header[0x22]);
	width = *(int*)&(header[0x12]);
	height = *(int*)&(header[0x16]);

	// Some BMP files are misformatted, guess missing information
	if (imageSize == 0)    imageSize = width * height * 3; // 3 : one byte for each Red, Green and Blue component
	if (dataPos == 0)      dataPos = 54; // The BMP header is done that way

										 // Create a buffer
	data = new unsigned char[imageSize];

	// Read the actual data from the file into the buffer
	fread(data, 1, imageSize, file);

	// Everything is in memory now, the file can be closed.
	fclose(file);

	// Create one OpenGL texture
	GLuint textureID;
	glGenTextures(1, &textureID);

	// "Bind" the newly created texture : all future texture functions will modify this texture
	glBindTexture(GL_TEXTURE_2D, textureID);

	// Give the image to OpenGL
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_BGR, GL_UNSIGNED_BYTE, data);

	// OpenGL has now copied the data. Free our own version
	delete[] data;

	// Poor filtering, or ...
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 

	// ... nice trilinear filtering ...
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
	// ... which requires mipmaps. Generate them automatically.
	glGenerateMipmap(GL_TEXTURE_2D);

	// Return the ID of the texture we just created
	printf("Finish reading image %s\n", imagepath);
	return textureID;
}

// vector opt
// res = a cross b;
void xProduct( float *a, float *b, float *res) 
{
 
    res[0] = a[1] * b[2]  -  b[1] * a[2];
    res[1] = a[2] * b[0]  -  b[2] * a[0];
    res[2] = a[0] * b[1]  -  b[0] * a[1];
}
 
// normalize a vec3
void normalize(float *a) 
{
 
    float mag = sqrt(a[0] * a[0]  +  a[1] * a[1]  +  a[2] * a[2]);
    a[0] /= mag;
    a[1] /= mag;
    a[2] /= mag;
}

// Matrix Opt. - In Opengl 3 we need to handle our own matrix.
 
// In this form : a = a * b; 
void multiplyMatrix(float *a, float *b) 
{
    float res[16];
 
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            res[j*4 + i] = 0.0f;
            for (int k = 0; k < 4; ++k) {
                res[j*4 + i] += a[k*4 + i] * b[j*4 + k];
            }
        }
    }
    memcpy(a, res, 16 * sizeof(float));
}

// sets the square matrix mat to the ID matrix,
void setIdentMatrix( float *mat, int size) 
{
	// input: size: size of the matrix (for example size=4 means 4 by 4 matrix)
	// output: mat: Identity matrix
	float *result = new float[size * size];
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			if (i == j)
				result[size * i + j] = 1;
			else
				result[size * i + j] = 0;
		}
	}
	memcpy(mat, result, size * size * sizeof(float));
	delete[] result;
}
 
// View Matrix
// just like glulookat
void placeCam(float posX, float posY, float posZ, float lookX, float lookY, float lookZ) 
{
 
    float dir[3], right[3], up[3];
 
    up[0] = 0.0f;   up[1] = 1.0f;   up[2] = 0.0f;
 
    dir[0] =  (lookX - posX);
    dir[1] =  (lookY - posY);
    dir[2] =  (lookZ - posZ);
    normalize(dir);
 
	// this order matters
    xProduct(dir,up,right);
    normalize(right);
 
    xProduct(right,dir,up);
    normalize(up);
 
    float aux[16];
 
    viewMatrix[0]  = right[0];
	viewMatrix[1]  = up[0];
	viewMatrix[2]  = -dir[0];
	viewMatrix[3]  = 0.0f;
    viewMatrix[4]  = right[1];
	viewMatrix[5]  = up[1];
	viewMatrix[6]  = -dir[1];
	viewMatrix[7]  = 0.0f;
    viewMatrix[8]  = right[2];
	viewMatrix[9]  = up[2];
	viewMatrix[10] = -dir[2];
	viewMatrix[11] = 0.0f;
    viewMatrix[12] = 0.0f;
    viewMatrix[13] = 0.0f;
    viewMatrix[14] =  0.0f;
    viewMatrix[15] = 1.0f;

	normalMatrix[0] = viewMatrix[0];
	normalMatrix[1] = viewMatrix[1];
	normalMatrix[2] = viewMatrix[2];
	normalMatrix[3] = viewMatrix[4];
	normalMatrix[4] = viewMatrix[5];
	normalMatrix[5] = viewMatrix[6];
	normalMatrix[6] = viewMatrix[8];
	normalMatrix[7] = viewMatrix[9];
	normalMatrix[8] = viewMatrix[10];

    setTransMatrix(aux, -posX, -posY, -posZ);
    multiplyMatrix(viewMatrix, aux);
	
}

// Generates a rotation matrix.  Angle is in radian.
float * rotationMatrix(float x, float y, float z, float angle)
{
	// inputs:  x,y,z: rotation vector
	//          angle:  angle of rotation arount vector(x,y,z)
	// output:  returns rotation matrix 
	float matrix[16] = {
		cos(angle) + x * x * (1 - cos(angle)), x * y * (1 - cos(angle)) + z * sin(angle), x * z * (1 - cos(angle)) - y * sin(angle), 0, 
		x * y * (1 - cos(angle)) - z * sin(angle), cos(angle) + y * y * (1 - cos(angle)), y * z * (1 - cos(angle)) + x * sin(angle), 0, 
		z * x * (1 - cos(angle)) + y * sin(angle), z * y * (1 - cos(angle)) - x * sin(angle), cos(angle) + z * z * (1 - cos(angle)), 0,
		0, 0, 0, 1
	};
	float *result = new float[16];
	memcpy(result, matrix, sizeof(float) * 16);
	return result;
}
 
// Projection Matrix
void buildProjMatrix(float fov, float ratio, float nearP, float farP) {
 
    float f = 1.0f / tan (fov * (PI / 360.0));
    setIdentMatrix(projMatrix,4);
    projMatrix[0] = f / ratio;
    projMatrix[1 * 4 + 1] = f;
    projMatrix[2 * 4 + 2] = (farP + nearP) / (nearP - farP);
    projMatrix[3 * 4 + 2] = (2.0f * farP * nearP) / (nearP - farP);
    projMatrix[2 * 4 + 3] = -1.0f;
    projMatrix[3 * 4 + 3] = 0.0f;
}

void buildModelMatrix() {
	setIdentMatrix(modelMatrix, 4);
}

// Transformation matrix mat with a translation
void setTransMatrix(float *mat, float x, float y, float z) {
	// inputs:  x: translation in x direction 
	//          y: translation in y direction
	//          z: translation in z direction
	// output:  mat : translation matrix 
	//float result[16] = {
	//	1, 0, 0, 0,
	//	0, 1, 0, 0,
	//	0, 0, 1, 0,
	//	x, y, z, 1
	//};
	//memcpy(mat, result, sizeof(float) * 16);

	setIdentMatrix(mat, 4);
	mat[12] = x;
	mat[13] = y;
	mat[14] = z;
}

//Transformation matrix mat with a scaling
void setScale(float *mat, float xScale, float yScale, float zScale) 
{
    // inputs:  xScale: scale in x direction 
	//          yScale: scale in y direction
	//          zScale: scale in z direction
	// output:  mat : Scale matrix
	//float result[16] = { 
	//	xScale, 0, 0, 0,
	//	0, yScale, 0, 0,
	//	0, 0, zScale, 0,
	//	0, 0, 0, 1 
	//};
	//memcpy(mat, result, sizeof(float) * 16);

	setIdentMatrix(mat, 4);
	mat[0] = xScale;
	mat[5] = yScale;
	mat[10] = zScale;
}

void changeSize(int w, int h) {
 
    float ratio;

    // place viewport to be the entire window
    glViewport(0, 0, w, h);
    ratio = (1.0f * w) / h;
    buildProjMatrix(53.13f, ratio, 1.0f, 30.0f);
}
 
void setupBuffers() {
 
    GLuint buffers[4];
 
    glGenVertexArrays(2, vert);

    // first triangle
	glBindVertexArray(vert[0]);
    // generate 2 buffers for vert and color
    glGenBuffers(4, buffers);
    // bind buffer for vertices and copy data into buffer
    glBindBuffer(GL_ARRAY_BUFFER, buffers[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices1), vertices1, GL_STATIC_DRAW);
    glEnableVertexAttribArray(vertexLoc);
    glVertexAttribPointer(vertexLoc, 3, GL_FLOAT, 0, 0, 0);
 
    // bind buffer for colors and copy data into buffer
    glBindBuffer(GL_ARRAY_BUFFER, buffers[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(colors1), colors1, GL_STATIC_DRAW);
    glEnableVertexAttribArray(colorLoc);
    glVertexAttribPointer(colorLoc, 4, GL_FLOAT, 0, 0, 0);

	// bind buffer for normals and copy data into buffer
    glBindBuffer(GL_ARRAY_BUFFER, buffers[2]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(normals1), normals1, GL_STATIC_DRAW);
    glEnableVertexAttribArray(normalLoc);
    glVertexAttribPointer(normalLoc, 3, GL_FLOAT, 0, 0, 0);

	//Cube 2

	glBindVertexArray(vert[1]);
	glGenBuffers(4, buffers);
	// bind buffer for vertices and copy data into buffer
	glBindBuffer(GL_ARRAY_BUFFER, buffers[0]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices1), vertices1, GL_STATIC_DRAW);
	glEnableVertexAttribArray(vertexLoc);
	glVertexAttribPointer(vertexLoc, 3, GL_FLOAT, 0, 0, 0);

	//// bind buffer for colors and copy data into buffer
	//glBindBuffer(GL_ARRAY_BUFFER, buffers[1]);
	//glBufferData(GL_ARRAY_BUFFER, sizeof(colors2), colors2, GL_STATIC_DRAW);
	//glEnableVertexAttribArray(colorLoc);
	//glVertexAttribPointer(colorLoc, 4, GL_FLOAT, 0, 0, 0);

	GLuint Texture = loadBMP_custom("texture.bmp");
	// Get a handle for our "myTextureSampler" uniform
	GLuint TextureID = glGetUniformLocation(p, "myTextureSampler");
	// Bind our texture in Texture Unit 0
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, Texture);
	// Set our "myTextureSampler" sampler to use Texture Unit 0
	glUniform1i(TextureID, 0);
	// bind buffer for texture and copy data into buffer
	glBindBuffer(GL_ARRAY_BUFFER, buffers[1]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(uv), uv, GL_STATIC_DRAW);
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, 0);

	// bind buffer for normals and copy data into buffer
	glBindBuffer(GL_ARRAY_BUFFER, buffers[2]);
	glBufferData(GL_ARRAY_BUFFER, sizeof(normals1), normals1, GL_STATIC_DRAW);
	glEnableVertexAttribArray(normalLoc);
	glVertexAttribPointer(normalLoc, 3, GL_FLOAT, 0, 0, 0);
}
 
void setUniforms() {
 
    // must be called after glUseProgram
	// set the variables for the shader
    glUniformMatrix4fv(projMatrixLoc,  1, false, projMatrix);
    glUniformMatrix4fv(viewMatrixLoc,  1, false, viewMatrix);
	glUniformMatrix3fv(normalMatrixLoc, 1, false, normalMatrix);
	glUniformMatrix4fv(modelMatrixLoc, 1, false, modelMatrix);
	glUniform4fv(ambientColorLoc, 1, ambientColor);
	glUniform3fv(lightColorLoc, 1, lightColor);
	glUniform3fv(lightPositionLoc, 1, lightPosition);
	glUniform1f(ShininessLoc,Shininess);
	glUniform1f(StrengthLoc, Strength);
	glUniform3fv(EyeDirectionLoc,1,EyeDirection);

	glUniform3fv(matEmissiveLoc, 1, matEmissive);
	glUniform3fv(matAmbientLoc, 1, matAmbient);
	glUniform3fv(matDiffuseLoc, 1, matDiffuse);
	glUniform3fv(matSpecularLoc, 1, matSpecular);
	glUniform3fv(lightDiffuseLoc, 1, lightDiffuse);
	glUniform3fv(lightSpecularLoc, 1, lightSpecular);

	glUniform1i(shaderLoc, shader);

	glUniform1i(objectIDLoc, objectID);
}
 
void renderScene(void) {
	frame++;
	time=glutGet(GLUT_ELAPSED_TIME);
	double fps = frame * 1000.0 / (time - timebase);
	if (time - timebase > 1000) {
		sprintf(s,"FPS:%4.2f", fps);
		timebase = time;
		frame = 0;
	}
    glutSetWindowTitle(s);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 
	placeCam(10, 2, 10, 0, 2, -5);
	//placeCam(viewPosition[0], viewPosition[1], viewPosition[2], 0, 0, -5);

	objectID = SPINNER;
	//glPushMatrix();
	buildModelMatrix();
	multiplyMatrix(modelMatrix, rotationMatrix(0.0, 1.0, 0.0, spinnerAngle += 30 / fps * PI / 180));
	multiplyMatrix(modelMatrix, rotationMatrix(1.0, 0.0, 0.0, angle2));
    glUseProgram(p);
    setUniforms();

    glBindVertexArray(vert[0]);
	glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices1));
	//glPopMatrix();

	//glPushMatrix();
	objectID = REVOLVER;
	float T[16];
	buildModelMatrix();

	multiplyMatrix(modelMatrix, rotationMatrix(0.0, 1.0, 0.0, revolverAngle += 30 / fps * PI / 180));

	setTransMatrix(T, 4, 0, 0);
	multiplyMatrix(modelMatrix, T);

	setScale(T, 0.5, 0.5, 0.5);
	multiplyMatrix(modelMatrix, T);

    setUniforms();

    glBindVertexArray(vert[1]);
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices1));
	//glPopMatrix();

	//lightPosition[0] = 10.0f * cos(revolverAngle);
	//lightPosition[1] = -5.0f;
	//lightPosition[2] = 4.0f * sin(revolverAngle);
	//setUniforms();

   glutSwapBuffers();
}
 

void printShaderInfoLog(GLuint obj)
{
    int infologLength = 0;
    int charsWritten  = 0;
    char *infoLog;
 
    glGetShaderiv(obj, GL_INFO_LOG_LENGTH,&infologLength);
 
    if (infologLength > 0)
    {
        infoLog = (char *)malloc(infologLength);
        glGetShaderInfoLog(obj, infologLength, &charsWritten, infoLog);
        printf("%s\n",infoLog);
        free(infoLog);
    }
}
 
void printProgramInfoLog(GLuint obj)
{
    int infologLength = 0;
    int charsWritten  = 0;
    char *infoLog;
 
    glGetProgramiv(obj, GL_INFO_LOG_LENGTH,&infologLength);
 
    if (infologLength > 0)
    {
        infoLog = (char *)malloc(infologLength);
        glGetProgramInfoLog(obj, infologLength, &charsWritten, infoLog);
        printf("%s\n",infoLog);
        free(infoLog);
    }
}
 
GLuint initShaders() {
 
    char *vertShader = NULL,*fragShader = NULL;
 
    GLuint p,v,f;
 
    v = glCreateShader(GL_VERTEX_SHADER);
    f = glCreateShader(GL_FRAGMENT_SHADER);
    vertShader = getTxtFile(vertexFileName);
    fragShader = getTxtFile(fragmentFileName);
    const char * vv = vertShader;
    const char * ff = fragShader;
    glShaderSource(v, 1, &vv,NULL);
    glShaderSource(f, 1, &ff,NULL);
    free(vertShader);
	free(fragShader);
    glCompileShader(v);
    glCompileShader(f);
    printShaderInfoLog(v);
    printShaderInfoLog(f);
    p = glCreateProgram();
    glAttachShader(p,v);
    glAttachShader(p,f);
    glBindFragDataLocation(p, 0, "outputF");
	glBindFragDataLocation(p, 1, "textureColor");
    glLinkProgram(p);
    printProgramInfoLog(p);
    vertexLoc = glGetAttribLocation(p,"position");
    colorLoc = glGetAttribLocation(p, "color"); 
	normalLoc = glGetAttribLocation(p, "normal");
    projMatrixLoc = glGetUniformLocation(p, "projMatrix");
    viewMatrixLoc = glGetUniformLocation(p, "viewMatrix");
	normalMatrixLoc = glGetUniformLocation(p, "normalMatrix");
	modelMatrixLoc = glGetUniformLocation(p, "modelMatrix");
	ambientColorLoc = glGetUniformLocation(p,"Ambient");
	lightColorLoc = glGetUniformLocation(p,"LightColor");
	lightPositionLoc = glGetUniformLocation(p,"LightPosition");
	ShininessLoc = glGetUniformLocation(p,"Shininess");
	StrengthLoc = glGetUniformLocation(p,"Strength");
	EyeDirectionLoc = glGetUniformLocation(p,"EyeDirection");

	matEmissiveLoc = glGetUniformLocation(p, "mat_emissive");
	matAmbientLoc = glGetUniformLocation(p, "mat_ambient");
	matDiffuseLoc = glGetUniformLocation(p, "mat_diffuse");
	matSpecularLoc = glGetUniformLocation(p, "mat_specular");
	lightDiffuseLoc = glGetUniformLocation(p, "Diffuse");
	lightSpecularLoc = glGetUniformLocation(p, "Specular");

	shaderLoc = glGetUniformLocation(p, "shader");

	objectIDLoc = glGetUniformLocation(p, "objectID");
 
    return(p);
}

float deltaAngle = 0.0f;
int xOrigin = -1;

//This event will trigger when you have a mouse button pressed down.
void mouseMove(int x, int y) 
{
	// x and y is the mouse position.
	//printf("%d ,  %d \n",x,y);
	int motionMode = 1;
	switch(motionMode){
  case 0:
    /* No mouse button is pressed... do nothing */
    /* return; */
    break;

  case 1:
    /* rotating the view*/
	spinnerAngle = spinnerAngle + (x - startX)/2;
    angle2 = angle2 + (y - startY)/2;
    startX = x;
    startY = y;
    break;

  case 2:

    break;

  case 3:

    break;
  }
	
}

//This event occur when you press a mouse button.
void mouseButton(int button, int state, int x, int y) 
{
	startX = x;
	startY = y;
	selectX = x;
	selectY = y;
	//printf("%d , %d",selectX,selectY);
	// only start motion if the left button is pressed
	if (button == GLUT_LEFT_BUTTON) 
	{
		// when the button is released
		if (state == GLUT_UP) 
		{
			  window_width = glutGet(GLUT_WINDOW_WIDTH);
			  window_height = glutGet(GLUT_WINDOW_HEIGHT);
 
			  GLbyte color[4];
			  GLfloat depth;
			  GLuint index;
 
			  glReadPixels(x, window_height - y - 1, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, color);
			  glReadPixels(x, window_height - y - 1, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &depth);
			  glReadPixels(x, window_height - y - 1, 1, 1, GL_STENCIL_INDEX, GL_UNSIGNED_INT, &index);
 
			  printf("Clicked on pixel %d, %d, color %02hhx%02hhx%02hhx%02hhx, depth %f, stencil index %u\n",
					 x, y, color[0], color[1], color[2], color[3], depth, index);
					}
		else  // state = GLUT_DOWN	
		{
		}
	}
}

void keyboard(unsigned char key, int x, int y)
{
	switch (key)
	{
	case 'a':
		shader = NOLIGHT;
		setUniforms();
		break;
	case 'p':
		shader = PHONG;
		setUniforms();
		break;
	case 'g':
		shader = GOURAUD;
		setUniforms();
		break;
	}
}

void init(){
	viewPosition[0] = 0;
	viewPosition[1] = 0;
	viewPosition[2] = 11;
}
 
int main(int argc, char **argv) 
{
	// sets up glut
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
    glutInitWindowPosition(100,100);
    glutInitWindowSize(640,480);
    glutCreateWindow("ICS Graphics");
    glutSetWindowTitle(s);
	// call back functions
    glutDisplayFunc(renderScene);
    glutIdleFunc(renderScene);
    glutReshapeFunc(changeSize);

	glutMouseFunc(mouseButton);
	glutMotionFunc(mouseMove);
	glutKeyboardFunc(keyboard);
 
	// check if a particular extension is available on your platform
    glewInit();
    if (glewIsSupported("GL_VERSION_3_3"))
        printf("OpenGL 3.3 is supported\n");
    else 
	{
        printf("OpenGL 3.3 not supported\n");
        exit(1);
    }
    glEnable(GL_DEPTH_TEST);

    glClearColor(1.0,1.0,1.0,1.0);
	//glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); 
	init();
    p = initShaders(); 
    setupBuffers(); 
    glutMainLoop();

    return(0); 
}
