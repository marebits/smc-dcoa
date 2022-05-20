const { Collection } = require("./Collection.js");
const { FILE_SYSTEM_CONSTANTS: constants } = require("fs");
const FileSystem = require("fs/promises");
const Path = require("path");
const Process = require("process");

module.exports = class FileGeneratorCollection extends Collection {
	#directory;
	#fileExtension;

	constructor(directory, fileExtension) {
		super();
		this.#directory = Path.isAbsolute(directory) ? directory : Path.normalize(Path.join(Process.cwd(), directory));
		this.#fileExtension = fileExtension;
	}
	get [globalThis.Symbol.toStringTag]() { return this.constructor.name; }
	get directory() { return this.#directory; }
	get fileExtension() { return this.#fileExtension; }
	get mimeType() { return "application/octet-stream"; }
	get targetFileRegex() { return new globalThis.RegExp(`*\\.${this.fileExtension}$`); }
	pathOf(key) { return this.has(key) ? Path.join(this.directory, `${key}.${this.fileExtension}`) : undefined; }
	async saveAll() {
		await FileSystem.access(this.directory, FILE_SYSTEM_CONSTANTS.W_OK);
		const existingFiles = await FileSystem.readdir(this.directory);
		const fileRegex = this.targetFileRegex;
		await globalThis.Promise.all(existingFiles.reduce((rmPromises, file) => {
			if (fileRegex.test(file))
				rmPromises.push(FileSystem.rm(Path.join(this.directory, file)));
			return rmPromises;
		}, new globalThis.Array()));
		return globalThis.Promise.all(this.reduce((savePromises, item) => {
			savePromises.push(FileSystem.writeFile(this.pathOf(item.key), item.value.toString()));
			return savePromises;
		}, new globalThis.Array()));
	}
}