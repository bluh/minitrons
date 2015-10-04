interface Tronic{
    int getX();
    int getY();
    int getWidth();
    int getHeight();
    void moveTronic(int x, int y);
    void renderTronic(int screenX, int screenY);
    void renderNodes(int mouseX, int mouseY, int screenX, int screenY, boolean highlight);
    Node[] getNodes();
}