module.exports = {
	multipass: true, 
	plugins: [
		"cleanupAttrs", 
		"cleanupEnableBackground", 
		"cleanupIDs", 
		"collapseGroups", 
		"convertColors", 
		"convertEllipseToCircle", 
		"convertPathData", 
		"convertShapeToPath", 
		"convertStyleToAttrs", 
		"convertTransform", 
		"mergePaths", 
		"mergeStyles", 
		{
			name: "minifyStyles", 
			params: {
				comments: false
			}
		}, 
		"moveElemsAttrsToGroup", 
		"moveGroupAttrsToElems", 
		"removeComments", 
		"removeDoctype", 
		"removeEditorsNSData", 
		"removeEmptyAttrs", 
		"removeEmptyContainers", 
		"removeEmptyText", 
		"removeHiddenElems", 
		"removeNonInheritableGroupAttrs", 
		"removeOffCanvasPaths", 
		"removeUnknownsAndDefaults", 
		"removeUnusedNS", 
		"removeUselessDefs", 
		"removeUselessStrokeAndFill", 
		"removeXMLProcInst", 
		"reusePaths", 
		"sortAttrs", 
		"sortDefsChildren"
	]
};