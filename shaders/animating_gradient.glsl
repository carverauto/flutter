
uniform float u_time;
// uniform vec2 u_resolution;
uniform float width;
uniform float height;
out vec4 fragColor;
vec2 u_resolution=vec2(width,height);

vec4 fragment(vec2 uv,vec2 fragCoord){
    vec2 st=fragCoord.xy/u_resolution.xy;
    st.x*=u_resolution.x/u_resolution.y;
    
    vec3 color=vec3(0.);
    color=.5+.5*cos(u_time*1.2+st.xyy+vec3(0,2,4));
    color.g=0.;
    
    return vec4(color,1.);
}
void main(){
    vec2 pos=gl_FragCoord.xy;
    vec2 uv=pos/vec2(width,height);
    fragColor=fragment(uv,pos);
}
