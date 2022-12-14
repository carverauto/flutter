const vec4 redLaser=vec4(1.,.1,.1,1.);
const vec4 blueLaser=vec4(.1,.75,1,1);
const float centerIntensity=16.;
const float laserStartPercentage=.01;

uniform float width;
uniform float height;
uniform float iTime;

vec2 iResolution=vec2(width,height);
out vec4 fragColor;
void main(){
    //Define the laser effect and center color (these can be tuned to produce any color laser)
    vec4 laserColor=blueLaser;
    vec4 white=vec4(1.,1.,1.,1.);
    
    // Normalize pixel coordinates (from 0 to 1)
    vec2 uv=gl_FragCoord.xy/iResolution.xy;
    
    //Comment out for solid color laser:
    laserColor.rgb=.5+.5*cos(iTime*1.+uv.xyx+vec3(0,2,4));
    
    //Get the background color for this pixel
    vec4 baseColor=vec4(0.);//texture(iChannel1, uv);
    
    //Calculate how close the current pixel is to the center line of the screen
    float intensity=1.-abs(uv.y-.5);
    
    //Raise it to the power of 4, resulting in sharply increased intensity at the center that trails off smoothly
    intensity=pow(intensity,4.);
    
    //Make the laser trail off at the start
    if(uv.x<laserStartPercentage){
        intensity=mix(0.,intensity,pow(uv.x/laserStartPercentage,.5));
    }
    
    //Pick where to sample the texture used for the flowing effect
    vec2 samplePoint=uv;
    //Stretch it horizontally and then shift it over time to make it appear to be flowing
    samplePoint.x=samplePoint.x*.1-iTime;
    //Compress it vertically
    samplePoint.y=samplePoint.y*2.;
    //Get the texture at that point
    float sampleIntensity=1.-uv.x;//texture(imageTexture,samplePoint).r;
    vec4 sampleColor;
    sampleColor.r=sampleIntensity*laserColor.r;
    sampleColor.b=sampleIntensity*laserColor.b;
    sampleColor.g=sampleIntensity*laserColor.g;
    
    //Mix it with 'intensity' to make it more intense near the center
    vec4 effectColor=sampleColor*intensity*2.;
    
    //Mix it with the color white raised to a higher exponent to make the center white beam
    effectColor=effectColor+white*centerIntensity*(pow(intensity,4.)*sampleIntensity);
    
    //Mix the laser color with the center beam
    laserColor=mix(laserColor,effectColor,.8);
    
    //Reduce the brightness of the background to emphacize the laser
    baseColor*=pow(1.-intensity,3.);
    
    //Add the laser to the background scene
    baseColor=mix(baseColor,laserColor,intensity*2.);
    
    // Output to screen
    fragColor=baseColor;
}