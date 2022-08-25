export const Board = {
  mounted() {
    const board = this;

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
