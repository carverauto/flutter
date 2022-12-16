// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

#define POINT_COUNT 3

uniform float width;
uniform float height;
uniform float u_time;
uniform float point1x;
uniform float point1y;
uniform float point2x;
uniform float point2y;
uniform float point3x;
uniform float point3y;

vec2 points[POINT_COUNT];
const float speed=-.5;
const float len=.25;
const float scale=.012;
float intensity=1.3;
float radius=.002;

vec2 u_resolution=vec2(width,height);
vec2 point1=vec2(point1x,point1y);
vec2 point2=vec2(point2x,point2y);
vec2 point3=vec2(point3x,point3y);

out vec4 fragColor;

//https://www.shadertoy.com/view/MlKcDD
//Signed distance to a quadratic bezier
float sdBezier(vec2 pos,vec2 A,vec2 B,vec2 C){
    vec2 a=B-A;
    vec2 b=A-2.*B+C;
    vec2 c=a*2.;
    vec2 d=A-pos;
    
    float kk=1./dot(b,b);
    float kx=kk*dot(a,b);
    float ky=kk*(2.*dot(a,a)+dot(d,b))/3.;
    float kz=kk*dot(d,a);
    
    float res=0.;
    
    float p=ky-kx*kx;
    float p3=p*p*p;
    float q=kx*(2.*kx*kx-3.*ky)+kz;
    float h=q*q+4.*p3;
    
    if(h>=0.){
        h=sqrt(h);
        vec2 x=(vec2(h,-h)-q)/2.;
        vec2 uv=sign(x)*pow(abs(x),vec2(1./3.));
        float t=uv.x+uv.y-kx;
        t=clamp(t,0.,1.);
        
        // 1 root
        vec2 qos=d+(c+b*t)*t;
        res=length(qos);
    }else{
        float z=sqrt(-p);
        float v=acos(q/(p*z*2.))/3.;
        float m=cos(v);
        float n=sin(v)*1.732050808;
        vec3 t=vec3(m+m,-n-m,n-m)*z-kx;
        t=clamp(t,0.,1.);
        
        // 3 roots
        vec2 qos=d+(c+b*t.x)*t.x;
        float dis=dot(qos,qos);
        
        res=dis;
        
        qos=d+(c+b*t.y)*t.y;
        dis=dot(qos,qos);
        res=min(res,dis);
        
        qos=d+(c+b*t.z)*t.z;
        dis=dot(qos,qos);
        res=min(res,dis);
        
        res=sqrt(res);
    }
    
    return res;
}

//http://mathworld.wolfram.com/HeartCurve.html
vec2 getHeartPosition(float t){
    return vec2(16.*sin(t)*sin(t)*sin(t),
    -(13.*cos(t)-5.*cos(2.*t)
    -2.*cos(3.*t)-cos(4.*t)));
}

//https://www.shadertoy.com/view/3s3GDn
float getGlow(float dist,float radius,float intensity){
    return pow(radius/dist,intensity);
}

float getSegment(float t,vec2 pos,float offset){
    //for(int i = 0; i < POINT_COUNT; i++){
        //      points[i] = getHeartPosition(offset + float(i)*len + fract(speed * t) * 6.28);
    // }
    
    // vec2 c = (points[0] + points[1]) / 2.0;
    // vec2 c_prev;
    float dist=10000.;
    
    // for(int i = 0; i < POINT_COUNT-1; i++){
        //https://tinyurl.com/y2htbwkm
        // c_prev = c;
        // c = (points[i] + points[i+1]) / 2.0;
        dist=sdBezier(pos,point1,point2,point3);//vec2(.1,.1),vec2(.4,.05),vec2(.9,.9));
    // }
    return dist;
}

void main(){
    vec2 uv=gl_FragCoord.xy/u_resolution.xy;
    float widthHeightRatio=u_resolution.x/u_resolution.y;
    vec2 centre=vec2(.5,.5);
    vec2 pos=uv;
    // pos.y /= widthHeightRatio;
    //Shift upwards to centre heart
    //  pos.y += 0.03;
    
    float t=u_time;
    
    //Get first segment
    float dist=getSegment(t,pos,0.);
    float glow=getGlow(dist,radius,intensity)*uv.x;
    
    vec3 col=vec3(0.);
    
    //White core
    col+=1.*vec3(smoothstep(.00001,0.,dist));
    //Pink glow
    col+=glow*vec3(1.,.1,.58);
    
    col+=glow*vec3(1.,.899,0.);
    
    //Tone mapping
    col=1.-exp(-col);
    
    //Gamma
    col=pow(col,vec3(.4545));
    // float factorvalue=1.-smoothstep(0.,dot(uv,col.xy)/15.,dist);
    float factorvalue=1.-smoothstep(0.,dot(uv,col.xy)*1.+.5,dist);
    
    //Output to screen
    fragColor=vec4(col*factorvalue,0.);
}