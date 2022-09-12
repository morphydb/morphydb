"use strict";

export class SvgContainer extends HTMLElement {
  constructor() {
    super();

    this.addEventListener("slotchange", (e) => console.log(e));

    const shadow = this.attachShadow({ mode: "open" });

    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "100%");
    shadow.appendChild(svg);

    this.svg = svg;

    window.addEventListener("resize", () => this.renderAllArrows(svg));
    this.addEventListener("arrow-changed", e => this.renderArrow(e.target));
  }

  onArrowAdded(arrow) {
    const line = document.createElementNS("http://www.w3.org/2000/svg", "path");

    line.setAttribute("stroke", "rgba(255, 127, 80, 100)");
    line.setAttribute("fill", "rgba(255, 127, 80, 100)");
    line.setAttribute("stroke-width", "5");
    line.setAttribute("data-arrow-id", arrow.arrow_id);

    this.svg.appendChild(line);

    this.renderArrow(arrow);
  }

  onArrowRemoved(arrow) {
    const line = this.svg.querySelector(`[data-arrow-id="${arrow.arrow_id}"]`);
    this.svg.removeChild(line);
  }

  static get observedAttributes() {
    return ["orientation"];
  }
  connectedCallback() {
    customElements.whenDefined("svg-arrow").then(() => {
      this.querySelectorAll("svg-arrow").forEach(arrow => this.onArrowAdded(arrow));

      const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          mutation.addedNodes.forEach(node => {
            if (node.nodeType === 1) {
              this.onArrowAdded(node);
            }
          });

          mutation.removedNodes.forEach(node => {
            if (node.nodeType === 1) {
              this.onArrowRemoved(node);
            }
          });
        });
      });

      observer.observe(this, { childList: true });
    });
  }

  attributeChangedCallback() {
    this.renderAllArrows();
  }

  renderAllArrows() {
    const arrows = this.querySelectorAll("svg-arrow");
    arrows.forEach((arrow) => this.renderArrow(arrow));
  }

  renderArrow(arrow) {
    const line = this.svg.querySelector(`[data-arrow-id="${arrow.arrow_id}"]`);
    const position = arrow.position;

    if (!position || !line) {
      return;
    }

    line.setAttribute("data-from", arrow.getAttribute("from"));
    line.setAttribute("data-to", arrow.getAttribute("to"));

    const lineWidth = this.offsetWidth / 80;
    const arrowheadWidth = lineWidth * 5;
    const arrowheadLength = lineWidth * 4;

    const dx = position.toX - position.fromX;
    const dy = position.toY - position.fromY;
    const length = Math.sqrt(dx * dx + dy * dy);
    const angle = (Math.atan2(dy, dx) * 180) / Math.PI;
    const dW = arrowheadWidth - lineWidth;

    const d = [
      "M",
      0,
      -lineWidth / 2,
      "h",
      length - arrowheadLength,
      "v",
      -dW / 2,
      "L",
      length,
      0,
      "L",
      length - arrowheadLength,
      arrowheadWidth / 2,
      "v",
      -dW / 2,
      "H",
      0,
      "Z",
    ];

    line.setAttribute("d", d.join(" "));
    line.setAttribute(
      "transform",
      "translate(" +
      position.fromX +
      "," +
      position.fromY +
      ") rotate(" +
      angle +
      ")"
    );

    arrow.setAttribute("has-rendered", true);
  }
}
