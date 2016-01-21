class Circle{
    color thisColor;
    float x;
    float y;
    float transparency;
    
    Circle(color val, int x, int y){
        this.thisColor = val;
        this.transparency = 100;
        this.x = x;
        this.y = y;
    }
    
    boolean render(float zoom){
        transparency -= 5;
        pushStyle();
        stroke(thisColor);
        fill(thisColor, transparency);
        ellipse(x/zoom, y/zoom, 300, 300);
        popStyle();
        return transparency > 0;
    }
}