export const Board = {
  mounted() {
    function determinePath(start, end) {
      const start_rank = parseInt(start / 8);
      const end_rank = parseInt(end / 8);
      const start_file = start % 8;
      const end_file = end % 8;

      const d_file = Math.abs(end_file - start_file);
      const d_rank = Math.abs(end_rank - start_rank);

      const slope = d_rank === 0 ? 1 : d_file / d_rank;

      if (slope === 0 || slope === 1) {
        return "straight";
      }

      return "grid";
    }

    function createLeaderLine(arrow) {
      arrow.leaderLine = new LeaderLine({
        start: arrow.start,
        end: arrow.end,
        size: 8,
        dropShadow: { opacity: 0.5 },
        path: determinePath(arrow.start_square, arrow.end_square),
        color: "rgba(255, 127, 80, 0.8)",
      });
    }

    const board = this;
    let arrows = [];

    this.handleEvent("arrow_start", (data) => {
      arrows.push({
        start_square: data.square,
        start: LeaderLine.pointAnchor(
          board.el.querySelector(`#square-${data.square}`)
        ),
        end_square: data.square,
        end: undefined,
        leaderLine: undefined,
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
          arrow.leaderLine.setOptions({ end: arrow.end, path: determinePath(arrow.start_square, arrow.end_square) });
        }
      }
    });

    this.handleEvent("arrow_end", () => {
      const arrow = arrows[arrows.length - 1];
      const existingArrows = arrows.filter(
        (a) =>
          a.start_square === arrow.start_square &&
          a.end_square === arrow.end_square
      );

      if (existingArrows.length === 2) {
        existingArrows.forEach((a) => a.leaderLine.remove());
        arrows = arrows.filter(
          (a) =>
            a.start_square !== arrow.start_square ||
            a.end_square !== arrow.end_square
        );
      }
    });

    this.handleEvent("arrow_clear", (data) => {
      arrows.forEach((arrow) => arrow.leaderLine.remove());
      arrows = [];
    });

    this.handleEvent("arrow_redraw", () => {
      arrows.forEach((arrow) => {
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
