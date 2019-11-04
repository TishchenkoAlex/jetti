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
