var doc = app.activeDocument;
var baseSuffixWidth = 960;
var baseSuffixHeight = 1536;
var docName = doc.name.toString().replace(".psd", "");
var frameRate = parseFloat(docName.match(/_(\d+)fps/)[1]);
docName = docName.replace(/_\d+fps/, '');

function exportImageSequence(scale) {
  var idExpr = charIDToTypeID( "Expr" );
  var desc13 = new ActionDescriptor();
  var idUsng = charIDToTypeID( "Usng" );
  var desc14 = new ActionDescriptor();
  var iddirectory = stringIDToTypeID( "directory" );
  desc14.putPath( iddirectory, new File( doc.path ) );
  var filename = docName + '_' + baseSuffixWidth * scale / 12 + 'x' + baseSuffixHeight * scale / 12 + '_' + '.png';
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
  desc14.putInteger( idWdth, doc.width * scale / 12 );
  var idHght = charIDToTypeID( "Hght" );
  desc14.putInteger( idHght, doc.height * scale / 12 );
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
  scales = [2, 4, 6, 8, 10, 12];
  for(var i in scales)
    exportImageSequence(scales[i]);
}
  
if (!app.activeDocument.saved)
    alert("Please save and Backup the document before running this !");
else
    main();
