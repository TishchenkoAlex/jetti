export function scrollIntoViewIfNeeded(type, style, direction = false) {
  let target;
  let highlight = document.getElementsByClassName(`scrollTo-${type} ${style}`);
  if (highlight.length) target = highlight[highlight.length - 1];
  else {
    highlight = document.getElementsByClassName(`scrollTo-${type}`);
    if (highlight.length) target = highlight[0];
  }
  const table = document.getElementById(type);
  const scrollEl = table ? table.getElementsByClassName('ui-table-scrollable-body') : [];
  if (!(target && scrollEl.length)) return;

  const targetRect = target.getBoundingClientRect();
  const scrollRect = scrollEl[0].getBoundingClientRect();
  if (targetRect.bottom > scrollRect.bottom) return target.scrollIntoView(direction ? true : false);
  if (targetRect.top <= scrollRect.top) return target.scrollIntoView(direction ? false : true);
  if (direction) return target.scrollIntoView(false);
}

export function MaxTextWidth(text: string[], fontsize: number) {
  return text.map(e => e.split('').length).sort()[0] * fontsize;
}

export function isEqualObjects(object1: Object, object2: Object): boolean {
  const keysObject1 = Object.keys(object1);
  const keysObject2 = Object.keys(object2);
  if (keysObject1.length !== keysObject2.length ||
    keysObject1.join().length !== keysObject2.join().length)
    return false;
  keysObject1.forEach(keyObj1 => {
    if (!keysObject2.includes(keyObj1) ||
      object1[keyObj1] !== object2[keyObj1]) return false;
  });
  return true;
}

// export function newGUID() {
//   return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
//     const r = Math.random() * 16 | 0;
//     const v = (c == 'x') ? r : (r & 0x3 | 0x8);
//     return v.toString(16);
//   });
// }
