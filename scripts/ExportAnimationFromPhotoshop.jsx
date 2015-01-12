#include "vendor/json2.js"

var doc = app.activeDocument;
var baseWidth;
var baseHeight;
var docName = doc.name.toString().replace(".psd", "");
var frameRate = parseFloat(docName.match(/_(\d+)fps/)[1]);
docName = docName.replace(/_\d+fps/, '');

function exportImageSequence(width) {
  var height = ~~(baseHeight * width / baseWidth);
  var idExpr = charIDToTypeID( "Expr" );
  var desc13 = new ActionDescriptor();
  var idUsng = charIDToTypeID( "Usng" );
  var desc14 = new ActionDescriptor();
  var iddirectory = stringIDToTypeID( "directory" );
  desc14.putPath( iddirectory, new File( doc.path ) );
  var filename = docName + '_' + width + 'x' + height + '_' + '.png';
  var idNm = charIDToTypeID( "Nm  " );
  desc14.putString( idNm, filename);
  var idsubdirectory = stringIDToTypeID( "subdirectory" );
  desc14.putString( idsubdirectory, "" );
  var idsequenceRenderSettings = stringIDToTypeID( "sequenceRenderSettings" );
  var desc15 = new ActionDescriptor();
  var idAs = charIDToTypeID( "As  " );
  var desc16 = new ActionDescriptor();
  var idPGIT = charIDToTypeID( "PGIT" );
  var idPGIT = charIDToTypeID( "PGIT" );
  var idPGIN = charIDToTypeID( "PGIN" );
  desc16.putEnumerated( idPGIT, idPGIT, idPGIN );
  var idPNGf = charIDToTypeID( "PNGf" );
  var idPNGf = charIDToTypeID( "PNGf" );
  var idPGAd = charIDToTypeID( "PGAd" );
  desc16.putEnumerated( idPNGf, idPNGf, idPGAd );
  var idCmpr = charIDToTypeID( "Cmpr" );
  desc16.putInteger( idCmpr, 0 );
  var idPNGF = charIDToTypeID( "PNGF" );
  desc15.putObject( idAs, idPNGF, desc16 );
  var idsequenceRenderSettings = stringIDToTypeID( "sequenceRenderSettings" );
  desc14.putObject( idsequenceRenderSettings, idsequenceRenderSettings, desc15 );
  var idminDigits = stringIDToTypeID( "minDigits" );
  desc14.putInteger( idminDigits, 4 );
  var idstartNumber = stringIDToTypeID( "startNumber" );
  desc14.putInteger( idstartNumber, 1 );
  var idWdth = charIDToTypeID( "Wdth" );
  desc14.putInteger( idWdth, doc.width * width / baseWidth );
  var idHght = charIDToTypeID( "Hght" );
  desc14.putInteger( idHght, doc.height * width / baseWidth );
  var idframeRate = stringIDToTypeID( "frameRate" );
  desc14.putDouble( idframeRate, frameRate );
  var idallFrames = stringIDToTypeID( "allFrames" );
  desc14.putBoolean( idallFrames, true );
  var idrenderAlpha = stringIDToTypeID( "renderAlpha" );
  var idalphaRendering = stringIDToTypeID( "alphaRendering" );
  var idstraight = stringIDToTypeID( "straight" );
  desc14.putEnumerated( idrenderAlpha, idalphaRendering, idstraight );
  var idQlty = charIDToTypeID( "Qlty" );
  desc14.putInteger( idQlty, 1 );
  var idvideoExport = stringIDToTypeID( "videoExport" );
  desc13.putObject( idUsng, idvideoExport, desc14 );
  executeAction( idExpr, desc13, DialogModes.NO );
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
    exportImageSequence(resolutionConfig.widths[i]);
  }
}
  
if (!app.activeDocument.saved)
    alert("Please save and Backup the document before running this !");
else
    main();
