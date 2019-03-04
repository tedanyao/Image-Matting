# Matting
* This program can evaluate 
  * Closed-form matting
  * KNN matting
  * Information-flow matting

# Note
1. All images should be .png files.  
2. If a trimap or scribble image is provided, the program will use them directly. Otherwise, a salient map is required to generate a rough version of trimap and scribble image.  

# Formats
Input:  
RGB image: data/\<your image dir\>/\<original images\>/\<num\>.png  
salient map: data/\<your image dir\>/\<salient dir\>/\<num\>.png  
trimap: data/\<your image dir\>/\<trimap dir\>/\<num\>.png  
scribble: data/\<your image dir\>/\<scribble dir\>/\<num\>.png  

Output:  
data/\<your image dir\>/result_tmp/\<cf\>.png  
data/\<your image dir\>/result_tmp/\<knn\>.png  
data/\<your image dir\>/result_tmp/\<info\>.png  
data/\<your image dir\>/result_tmp/\<compare\>.png  
