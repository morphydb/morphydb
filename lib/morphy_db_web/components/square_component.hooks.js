let Square = {
  mounted() {
    this.el.addEventListener("contextmenu", (e) => {
      e.preventDefault();

      this.pushEventTo(this.el.closest("div"), "square_highlighted", {
        square_index: Number(this.el.getAttribute("phx-value-square_index")),
        alt_key: e.altKey,
        ctrl_key: e.ctrlKey,
      });

      return false;
    });
  },
};

export { Square };
