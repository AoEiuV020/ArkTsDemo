import { Counter } from 'library1/src/main/ets/counter/counter';

export function increase(a: number): number {
  const counter = new Counter();
  counter.increment();
  return a + counter.getCurrentCount();
}