export class Arrow extends HTMLElement {
  static current_id = 0;

  static nextId() {
    return ++this.current_id;
  }

  constructor() {
    super();

    this.arrow_id = Arrow.nextId();
  }

  get position() {
    const from = document.getElementById(this.getAttribute("from"));
    const to = document.getElementById(this.getAttribute("to"));

    if (from == null || to == null || from === to) {
      return null;
    }

    return {
      fromX: from.offsetLeft + from.offsetWidth / 2,
      fromY: from.offsetTop + from.offsetHeight / 2,
      toX: to.offsetLeft + to.offsetWidth / 2,
      toY: to.offsetTop + to.offsetHeight / 2,
    };
  }

  static get observedAttributes() {
    return ["from", "to"];
  }

  attributeChangedCallback() {
    if (this.position) {
      this.dispatchEvent(
        new CustomEvent("arrow-changed", {
          bubbles: true
        })
      );
    }
  }
}