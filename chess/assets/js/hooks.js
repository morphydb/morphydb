
const getSquareIndex = (element) => {
    if (!element || !element.getAttribute) {
        return null;
    }

    const square_index = element.getAttribute("data-square_index");
    if (square_index) {
        return Number(square_index);
    }

    return getSquareIndex(element.parentNode);
};

export const Hooks = {
    Board: {
        onMouseDown(e) {
            if (e.button !== 2) {
                console.log(e.button);
                return;
            }

            e.preventDefault();

            const square_index = getSquareIndex(e.target);

            if (square_index === null) {
                return;
            }

            const svg = document.querySelector("svg-container");
            const arrow = document.createElement("svg-arrow");

            arrow.setAttribute("from", `square-${square_index}`);
            arrow.setAttribute("to", `square-${square_index}`);

            svg.appendChild(arrow);

            const mouseOverHandler = ((mouseOver) => {
                const target_square_index = getSquareIndex(mouseOver.target);
                if (target_square_index) {
                    arrow.setAttribute("to", `square-${target_square_index}`);
                }
            }).bind(this);

            const mouseUpHandler = ((mouseUp) => {
                const target_square_index = getSquareIndex(mouseUp.target);

                const hasRendered = arrow.getAttribute("has-rendered");

                if (target_square_index === square_index && !hasRendered) {
                    this.pushEventTo(this.el, "highlight", {
                        square_index: square_index,
                        alt_key: e.altKey,
                        ctrl_key: e.ctrlKey,
                    });
                } else if (square_index != target_square_index) {
                    this.pushEventTo(this.el, "draw-arrow", {
                        from: square_index,
                        to: target_square_index,
                    });
                }

                svg.removeChild(arrow);
                window.removeEventListener("mouseup", mouseUpHandler);
                window.removeEventListener("mouseover", mouseOverHandler);
            }).bind(this);

            window.addEventListener("mouseup", mouseUpHandler);
            window.addEventListener("mouseover", mouseOverHandler);
        },

        mounted() {
            this.el.addEventListener("mousedown", this.onMouseDown.bind(this));
            this.el.addEventListener("contextmenu", (e) => {
                e.preventDefault();
            });
        },
    },
};
