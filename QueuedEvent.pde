interface QueuedEvent{
    public double getDelay();
    public void invoke();
}