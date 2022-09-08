export const Board = {
  mounted() {
    function createLeaderLine(arrow) {
      arrow.leaderLine = new LeaderLine({
        start: arrow.start,
        end: arrow.end,
        size: 16,
        dropShadow: { opacity: 0.5 },
        path: arrow.path_type,
        color: "rgba(255, 127, 80, 0.7)",
      });
    }

    const board = this;
    let arrows = [];

    this.handleEvent("arrow_start", (data) => {
      const element = board.el.querySelector(`#square-${data.square}`)
      const piece = element.getAttribute('data-piece');

      arrows.push({
        start_square: data.square,
        start: LeaderLine.pointAnchor(element),
        end_square: data.square,
        end: undefined,
        leaderLine: undefined,
        path_type:  piece === "n" ? "grid" : "straight"
      });
    });

    this.handleEvent("arrow_update", (data) => {
      const arrow = arrows[arrows.length - 1];

      if (data.square !== arrow.start_square) {
        arrow.end_square = data.square;
        arrow.end = LeaderLine.pointAnchor(
          board.el.querySelector(`#square-${data.square}`)
        );

        if (arrow.leaderLine === undefined) {
          createLeaderLine(arrow);
        } else {
          arrow.leaderLine.setOptions({ end: arrow.end });
        }
      }
    });

    this.handleEvent("arrow_end", () => {
      const arrow = arrows[arrows.length - 1];
      const existingArrows = arrows.filter(
        a =>
          a.start_square === arrow.start_square &&
          a.end_square === arrow.end_square
      );

      if (existingArrows.length === 2) {
        existingArrows.filter(a => a.leaderLine).forEach((a) => a.leaderLine.remove());
        arrows = arrows.filter(
          (a) =>
            a.start_square !== arrow.start_square ||
            a.end_square !== arrow.end_square
        );
      }
    });

    this.handleEvent("arrow_clear", (data) => {
      arrows.filter(a => a.leaderLine).forEach((arrow) => arrow.leaderLine.remove());
      arrows = [];
    });

    this.handleEvent("arrow_redraw", () => {
      arrows.filter(a => a.leaderLine).forEach((arrow) => {
        arrow.leaderLine.remove();
        createLeaderLine(arrow);
      });
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
