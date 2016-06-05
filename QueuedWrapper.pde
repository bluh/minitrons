class QueuedWrapper{
    double time;
    QueuedEvent evt;
    
    public QueuedWrapper(QueuedEvent evt){
        this.evt = evt;
        this.time = 0;
    }
    
    public boolean tick(double dt){
        time += dt;
        if(time >= evt.getDelay()){
            evt.invoke();
            return true;
        }
        return false;
    }
}