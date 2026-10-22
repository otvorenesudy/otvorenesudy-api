import { Controller } from '@hotwired/stimulus';

// A link that scrolls smoothly to a part of the page (the selector), leaving offset pixels above it, and puts the cursor
// in a field there (focus). Without the part, the link does what its href says.
export default class extends Controller {
  static values = { selector: String, offset: Number, focus: String };

  go(event) {
    const section = document.querySelector(this.selectorValue);
    if (!section) return;

    event.preventDefault();

    const top = section.getBoundingClientRect().top + window.scrollY - this.offsetValue;
    window.scrollTo({ top, behavior: 'smooth' });

    if (this.hasFocusValue) document.querySelector(this.focusValue)?.focus({ preventScroll: true });
  }
}
