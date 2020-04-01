// import { Injectable, Inject } from '@angular/core';
// import { EventManager } from '@angular/platform-browser';
// import { Observable } from 'rxjs';
// import { DOCUMENT } from '@angular/common';

// type Options = {
//   element: any;
//   description: string | undefined;
//   keys: string;
// }

// @Injectable({
//   providedIn: 'root'
// })

// export class Hotkeys {
//   hotkeys = new Map();
//   constructor(private eventManager: EventManager) { }

//   addShortcut(options: Partial<Options>) {
//     const merged = { ...options };
//     const event = `keydown.${merged.keys}`;

//     this.hotkeys.set(merged.keys, merged.description);

//     return new Observable(observer => {
//       const handler = (e) => {
//         e.preventDefault();
//         observer.next(e);
//       };

//       const dispose = this.eventManager.addEventListener(merged.element, event, handler);

//       return () => {
//         dispose();
//         this.hotkeys.delete(merged.keys);
//       };
//     });
//   }

// }
