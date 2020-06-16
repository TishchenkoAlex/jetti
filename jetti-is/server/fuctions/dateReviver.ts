export function dateReviverUTC(_key: any, value: string) {
  if (typeof value === 'string' && value.length < 25) {
    const a = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)Z$/.exec(value);
    if (a) { return new Date(Date.UTC(+a[1], +a[2] - 1, +a[3], +a[4], +a[5], +a[6])); }
    const b = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})/.exec(value);
    if (b) { return new Date(Date.UTC(+b[1], +b[2] - 1, +b[3], +b[4], +b[5])); }
    const c = /^(\d{4})-(\d{2})-(\d{2})/.exec(value);
    if (c) { return new Date(Date.UTC(+c[1], +c[2] - 1, +c[3])); }
  }
  return value;
}

