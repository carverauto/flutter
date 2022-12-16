//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
//

uniform float width;
uniform float height;
uniform float iTime;

uniform sampler2D iChannel0;

vec2 iResolution=vec2(width,height);
out vec4 fragColor;

vec3 mod289(vec3 x){
    return x-floor(x*(1./289.))*289.;
}

vec2 mod289(vec2 x){
    return x-floor(x*(1./289.))*289.;
}

vec3 permute(vec3 x){
    return mod289(((x*34.)+1.)*x);
}

float snoise(vec2 v)
{
    const vec4 C=vec4(.211324865405187,// (3.0-sqrt(3.0))/6.0
    .366025403784439,// 0.5*(sqrt(3.0)-1.0)
    -.577350269189626,// -1.0 + 2.0 * C.x
.024390243902439);// 1.0 / 41.0
// First corner
vec2 i=floor(v+dot(v,C.yy));
vec2 x0=v-i+dot(i,C.xx);

// Other corners
vec2 i1;
//i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
//i1.y = 1.0 - i1.x;
i1=(x0.x>x0.y)?vec2(1.,0.):vec2(0.,1.);
// x0 = x0 - 0.0 + 0.0 * C.xx ;
// x1 = x0 - i1 + 1.0 * C.xx ;
// x2 = x0 - 1.0 + 2.0 * C.xx ;
vec4 x12=x0.xyxy+C.xxzz;
x12.xy-=i1;

// Permutations
i=mod289(i);// Avoid truncation effects in permutation
vec3 p=permute(permute(i.y+vec3(0.,i1.y,1.))
+i.x+vec3(0.,i1.x,1.));

vec3 m=max(.5-vec3(dot(x0,x0),dot(x12.xy,x12.xy),dot(x12.zw,x12.zw)),0.);
m=m*m;
m=m*m;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

vec3 x=2.*fract(p*C.www)-1.;
vec3 h=abs(x)-.5;
vec3 ox=floor(x+.5);
vec3 a0=x-ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
m*=1.79284291400159-.85373472095314*(a0*a0+h*h);

// Compute final noise value at P
vec3 g;
g.x=a0.x*x0.x+h.x*x0.y;
g.yz=a0.yz*x12.xz+h.yz*x12.yw;
return 130.*dot(m,g);
}

float rand(vec2 co)
{
return fract(sin(dot(co.xy,vec2(12.9898,78.233)))*43758.5453);
}

void main(){
vec2 uv=gl_FragCoord.xy/iResolution.xy;
float time=iTime;

// Create large, incidental noise waves
float noise=max(0.,snoise(vec2(time,uv.y*.3))-.3)*(1./.7);

// Offset by smaller, constant noise waves
noise=noise+(snoise(vec2(time*10.,uv.y*2.4))-.5)*.15;

// Apply the noise as x displacement for every line
float xpos=uv.x-noise*noise*.01;
fragColor=texture(iChannel0,vec2(xpos,uv.y));

// Mix in some random interference for lines
fragColor.rgb=mix(fragColor.rgb,vec3(rand(vec2(uv.y*time))),noise*.3).rgb;

// Apply a line pattern every 4 pixels
if(floor(mod(gl_FragCoord.y*.25,2.))==0.)
{
    fragColor.rgb*=1.-(.15*noise);
}

// Shift green/blue channels (using the red channel)
fragColor.g=mix(fragColor.r,texture(iChannel0,vec2(xpos+noise*.05,uv.y)).g,.25);
fragColor.b=mix(fragColor.r,texture(iChannel0,vec2(xpos-noise*.05,uv.y)).b,.25);
}