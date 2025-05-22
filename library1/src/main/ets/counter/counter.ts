export class Counter {
  private count: number = 0;

  increment(): number {
    return ++this.count;
  }

  decrement(): number {
    return --this.count;
  }

  getCurrentCount(): number {
    return this.count;
  }

  reset(): void {
    this.count = 0;
  }
}
