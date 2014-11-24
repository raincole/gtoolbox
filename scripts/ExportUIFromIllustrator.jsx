var doc = app.activeDocument;
var baseSuffixWidth = 960;
var baseSuffixHeight = 1536;
var docName = doc.name.toString().replace(".ai", "");

function savePNG(filepath, scale) {
    var exp = new ExportOptionsPNG24();
    exp.transparency = true;
    exp.horizontalScale = scale * 100 / 12;
    exp.verticalScale = scale * 100 / 12;
    exp.artBoardClipping = true;

    doc.exportFile(new File(filepath), ExportType.PNG24, exp);
}

function exportImage(scale) {
  var dirpath = doc.path + '/' + baseSuffixWidth * scale / 12 + 'x' + baseSuffixHeight * scale / 12;
  var dir = new Folder(dirpath);
  if(!dir.exists) dir.create();
  var filepath = dirpath + '/' + docName + '.png';
  savePNG(filepath, scale);
}

function main() {
  scales = [2, 4, 6, 8, 10, 12];
  for(var i in scales)
    exportImage(scales[i]);
}

main();
