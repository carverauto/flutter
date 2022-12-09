#define PI 3.14159265359

uniform float height;
uniform float width;
uniform float u_time;
uniform float tiles;
uniform float speed;
uniform float direction;
uniform float warpScale;
uniform float warpTiling;
uniform float c1r;
uniform float c1g;
uniform float c1b;
uniform float c2r;
uniform float c2g;
uniform float c2b;
vec3 color1=vec3(c1r,c1g,c1b);
vec3 color2=vec3(c2r,c2g,c2b);

vec2 rotatePoint(vec2 pt,vec2 center,float angle){
    float sinAngle=sin(angle);
    float cosAngle=cos(angle);
    pt-=center;
    vec2 r=vec2(1.);
    r.x=pt.x*cosAngle-pt.y*sinAngle;
    r.y=pt.x*sinAngle+pt.y*cosAngle;
    r+=center;
    return r;
}

vec4 fragment(vec2 uv,vec2 fragCoord){
    
    vec2 uv2=rotatePoint(uv.xy,vec2(.5,.5),direction*2.*PI);
    
    uv2.x+=sin(uv2.y*warpTiling*PI*2.)*warpScale+speed;
    uv2.x*=tiles;
    
    float st=floor(fract(uv2.x)+.5);
    
    vec3 color=mix(color1,color2,st);
    
    return vec4(color,1.);
}

void main(){
    vec2 pos=gl_FragCoord.xy;
    vec2 uv=pos/vec2(width,height);
    fragColor=fragment(uv,pos);
}