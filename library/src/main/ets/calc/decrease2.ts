export function decrease2(a: number): number {
  // not support eval()
  // return eval(`minus(${a}, 2)`);
  // compile error:  Cannot find name 'minus'.
  // return minus(a, 2);
  return a - 2;
}