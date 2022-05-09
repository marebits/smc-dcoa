import * as Process from "process";

// "⣾⣽⣻⢿⡿⣟⣯⣷";
// "◴◷◶◵"

export class ProgressBar {
	static #EMPTY_BAR_CHARACTER = "▱";
	static #FULL_BAR_CHARACTER = "▰";
	static #HIDE_CURSOR_COMMAND = "\x1B[?25l";
	static #LEFT_MARGIN = 3;
	static #SHOW_CURSOR_COMMAND = "\x1B[?25h";
	static #WIDTH = 50;

	#_isDisplayed = false;
	#max = globalThis.Number.POSITIVE_INFINITY;
	#min = globalThis.Number.NEGATIVE_INFINITY;
	#value = globalThis.Number.NaN;

	constructor(min = 0, max = 100, value = 0) {
		[this.max, this.min] = [max, min];
		this.value = value;
	}
	get #cursor() { return globalThis.Math.round(this.position * this.constructor.#WIDTH); }
	get #isDisplayed() { return this.#_isDisplayed; }
	get max() { return this.#max; }
	get min() { return this.#min; }
	get position() { return this.value / (this.max - this.min); }
	get value() { return this.#value; }
	set #isDisplayed(isDisplayed) {
		isDisplayed = globalThis.Boolean(isDisplayed);

		if (this.#_isDisplayed === isDisplayed)
			return;
		this.#_isDisplayed = isDisplayed;

		if (this.#isDisplayed) {
			this.#hideCursor();
			this.#printEmptyBar();
			this.#fill();
		} else {
			Process.stdout.clearLine(0);
			this.#showCursor();
			Process.stdout.cursorTo(0);
		}
	}
	set max(max) {
		this.#max = globalThis.Math.max(globalThis.Number.parseFloat(max), this.min);
		this.value = this.value;
	}
	set min(min) {
		this.#min = globalThis.Math.min(globalThis.Number.parseFloat(min), this.max);
		this.value = this.value;
	}
	set value(value) {
		if (!globalThis.Number.isNaN(value)) {
			this.#value = globalThis.Math.max(globalThis.Math.min(globalThis.Number.parseFloat(value), this.max), this.min);
			this.#fill();
		}
	}
	#fill() {
		if (!this.#isDisplayed)
			return;
		this.#cursorToBeginning();
		Process.stdout.write(this.constructor.#FULL_BAR_CHARACTER.repeat(this.#cursor));
	}
	#hideCursor() { Process.stdout.write(this.constructor.#HIDE_CURSOR_COMMAND); }
	#printEmptyBar() {
		this.#cursorToBeginning();
		Process.stdout.write(this.constructor.#EMPTY_BAR_CHARACTER.repeat(this.constructor.#WIDTH));
	}
	#cursorToBeginning() { Process.stdout.cursorTo(this.constructor.#LEFT_MARGIN); }
	#showCursor() { Process.stdout.write(this.constructor.#SHOW_CURSOR_COMMAND); }
	begin() { this.#isDisplayed = true; }
	end() { this.#isDisplayed = false; }
}

// let doIt = function() {
// 	const MIN = 0;
// 	const MAX = 100;

// 	const fubar = new ProgressBar(MIN, MAX);
// 	let i = MIN;
// 	fubar.begin();
// 	const timer = globalThis.setInterval(() => {
// 		fubar.value = i++;

// 		if (i >= MAX) {
// 			globalThis.clearInterval(timer);
// 			fubar.end();
// 		}
// 	}, 100);
// };
// doIt();