#include "vendor/json2.js"

var doc = app.activeDocument;
var docName = doc.name.toString().replace(".ai", "");
var baseWidth;
var baseHeight;

function savePNG(filepath, width) {
    var exp = new ExportOptionsPNG24();
    exp.transparency = true;
    exp.horizontalScale = width * 100 / baseWidth;
    exp.verticalScale = exp.horizontalScale;
    exp.artBoardClipping = true;

    doc.exportFile(new File(filepath), ExportType.PNG24, exp);
}

function exportImage(width) {
  var dirpath = doc.path + '/' + width + 'x' + ~~(baseHeight * width / baseWidth);
  var dir = new Folder(dirpath);
  if(!dir.exists) dir.create();
  var filepath = dirpath + '/' + docName + '.png';
  savePNG(filepath, width);
}

function main() {
  var path = $.fileName.substring(0,$.fileName.lastIndexOf("/")+1);
  var f = new File(path+"./config/resolution.json");
  f.open('r');
  var resolutionConfig = JSON.parse(f.read());
  f.close();

  baseWidth = resolutionConfig.baseWidth;
  baseHeight = resolutionConfig.baseHeight;

  for(var i in resolutionConfig.widths) {
    exportImage(resolutionConfig.widths[i]);
  }
}

main();
