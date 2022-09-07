export const Board = {
  mounted() {
    const board = this;

    const arrows = [];

    const onMousedown = (e, element) => {
      e.preventDefault();
      
      arrows.push({ start: LeaderLine.pointAnchor(element), end: undefined, leaderLine: undefined });
    };

    const onMouseover = (e, element) => {
      e.preventDefault();
      const arrow = arrows[arrows.length - 1]

      if (e.buttons != 2 || arrow === undefined) {
        return;
      }

      if (element !== arrow.start) {
        arrow.end = element;

        if (arrow.leaderLine === undefined) {
          arrow.leaderLine = new LeaderLine({start: arrow.start, end: LeaderLine.pointAnchor(arrow.end), size: 8, dropShadow: true, path: "straight"});
        }
        else {
          arrow.leaderLine.setOptions({ end: LeaderLine.pointAnchor(arrow.end) });
        }
      }
    };

    const squareElements = this.el.querySelectorAll(".square");

    squareElements.forEach(element => {
      element.addEventListener("contextmenu", e => onMousedown(e, element));
      element.addEventListener("mouseover", e => onMouseover(e, element));
    });

    window.addEventListener("keyup", (e) => {
      if (e.code === "Escape") {
        this.pushEventTo(board.el, "deselect", {});
      }

      if (e.code === "KeyF") {
        this.pushEventTo(board.el, "flip", {});
      }
    });
  },
};
