let Square = {
  mounted() {
    this.el.addEventListener("contextmenu", (e) => {
      e.preventDefault();

      this.pushEventTo(this.el.closest("div"), "square_right_click", {
        square_index: this.el.getAttribute("phx-value-square_index"),
        alt_key: e.altKey,
        ctrl_key: e.ctrlKey,
      });

      return false;
    });
  },
};

export { Square };
