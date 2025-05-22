import { Calc } from '.';

export function increase(a: number): number {
  const counter = new Calc.Counter();
  counter.increment();
  return a + counter.getCurrentCount();
}