export const Board = {
  mounted() {
    const board = this;
    let arrows = [];

    this.handleEvent("arrow_start", data => {
      arrows.push({
        start_square: data.square,
        start: LeaderLine.pointAnchor(board.el.querySelector(`#square-${data.square}`)),
        end_square: data.square,
        end: undefined,
        leaderLine: undefined
      });
    });

    this.handleEvent("arrow_update", data => {
      const arrow = arrows[arrows.length - 1]

      if (data.square !== arrow.start_square) {
        arrow.end_square = data.square;
        arrow.end = LeaderLine.pointAnchor(board.el.querySelector(`#square-${data.square}`));

        if (arrow.leaderLine === undefined) {
          arrow.leaderLine = new LeaderLine({ start: arrow.start, end: arrow.end, size: 8, dropShadow: true, path: "straight" });
        }
        else {
          arrow.leaderLine.setOptions({ end: arrow.end });
        }
      }
    });

    this.handleEvent("arrow_end", data => {
      const arrow = arrows[arrows.length - 1]
      const existingArrows = arrows.filter(a => a.start_square === arrow.start_square && a.end_square === arrow.end_square);

      if (existingArrows.length === 2) {
        existingArrows.forEach(a => a.leaderLine.remove());
        arrows = arrows.filter(a => a.start_square !== arrow.start_square || a.end_square !== arrow.end_square);
      }
    })

    this.handleEvent("arrow_clear", data => {
      arrows.forEach(arrow => arrow.leaderLine.remove());
      arrows = []
    })

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
