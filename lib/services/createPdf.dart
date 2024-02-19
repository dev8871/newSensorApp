import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<Uint8List> _readImageData(String name) async {
  final data = await rootBundle.load('assets/images/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

class CreatePdf {
  Future<void> createPDF(String sensor, String title, String humidity,
      String temperature, String concentration, String referenceRange) async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 50;
    document.pageSettings.size = PdfPageSize.a4;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    Rect bounds = Rect.fromLTWH(0, 160, graphics.clientSize.width, 30);

    //image
    graphics.drawImage(PdfBitmap(await _readImageData('pdfLogo.png')),
        const Rect.fromLTWH(0, 35, 200, 80));

//Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);

//Creates a text element to add the invoice number
    PdfTextElement element =
        PdfTextElement(text: 'Report', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;

//Use 'intl' package for date format.
    DateTime today = DateTime.now();
    String currentDate =
        'DATE - ${today.day}/${today.month}/${today.year}  Time - ${today.hour}:${today.minute}';

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);

//Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

//Creates text elements to add the address and draw it to the page
    element = PdfTextElement(
        text: sensor,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
            style: PdfFontStyle.bold));
    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 0))!;

    //Creates a PDF grid
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 5);

//Add header to the grid
    grid.headers.add(1);

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Parameter';
    header.cells[1].value = 'Value';
    header.cells[2].value = 'Reference Range';
    header.cells[3].value = 'Units';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
        style: PdfFontStyle.regular);

    //Create and customize the string formats

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Humidity';
    row.cells[1].value = 'Normal';

    row = grid.rows.add();
    row.cells[0].value = 'Temperature';
    row.cells[1].value = 'Room Temperature';

    row = grid.rows.add();
    row.cells[0].value = title;
    row.cells[1].value = concentration;
    row.cells[2].value = referenceRange;
    row.cells[3].value = 'Micro Ampere';
    row.height = 60;
    graphics.drawString(
        "Given reference range is the normal concentration of $title found in human's blood",
        bounds: const Rect.fromLTWH(10, 450, 400, 40),
        PdfStandardFont(PdfFontFamily.helvetica, 10));
    graphics.drawString(
        """               Prof. Shaibal Mukherjee  
        Department of Electrical Engineering
                    IIT Indore 452020""",
        bounds: const Rect.fromLTWH(350, 540, 400, 40),
        PdfStandardFont(PdfFontFamily.helvetica, 7));
//Adds cell customizations
    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;
    format.lineAlignment = PdfVerticalAlignment.middle;
    for (int i = 0; i < header.cells.count; i++) {
      header.cells[i].stringFormat = format;
      header.cells[i].style = headerStyle;
    }

//Set padding for grid cells
    grid.style.cellPadding =
        PdfPaddings(left: 10, right: 10, top: 10, bottom: 10);

//Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
//Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        row.cells[j].stringFormat = format;
      }
    }

//Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

//Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 3),
        Offset(graphics.clientSize.width, result.bounds.bottom + 3));

    //Save the document
    List<int> bytes = await document.save();

    //Dispose the document
    document.dispose();
    //Get external storage directory
    final directory = await getApplicationSupportDirectory();

//Get directory path
    final path = directory.path;

//Create an empty file to write PDF data
    File file = File('$path/Output.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');
  }
}
