class Circle{
    color thisColor;
    float x;
    float y;
    float transparency;
    int radius;
    
    Circle(color val, int x, int y){
        this(val, x, y, 300);
    }
    
    Circle(color val, int x, int y, int radius){
        this.thisColor = val;
        this.transparency = 100;
        this.x = x;
        this.y = y;
        this.radius = radius;
    }
    
    boolean render(){
        transparency -= 5;
        pushStyle();
        stroke(thisColor);
        fill(thisColor, transparency);
        ellipse(x/zoom, y/zoom, radius, radius);
        popStyle();
        return transparency > 0;
    }
}
