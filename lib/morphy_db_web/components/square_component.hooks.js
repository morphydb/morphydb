export const Square = {
    mounted() {
        function convertEventParams(e) {
            return {
                alt_key: e.altKey,
                ctrl_key: e.ctrlKey,
                left_button: e.buttons & 1 === 1,
                right_button: e.buttons & 2 === 2,
                square: square_index
            };
        }

        const board = this.el.closest('.board');
        const square_index = this.el.getAttribute('phx-value-square');

        this.el.addEventListener('mousedown', e => {
            if (e.buttons & 2) {
                this.pushEventTo(board, 'mousedown', convertEventParams(e))
            }
        });

        this.el.addEventListener('mouseover', e => {
            if (e.buttons & 2) {
                this.pushEventTo(board, 'mouseover', convertEventParams(e))
            }

        });

        this.el.addEventListener('mouseup', e => {
            this.pushEventTo(board, 'mouseup', convertEventParams(e))
        });
    }
}
