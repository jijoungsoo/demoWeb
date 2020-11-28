/***
 * Contains basic SlickGrid formatters.
 * 
 * NOTE:  These are merely examples.  You will most likely need to implement something more
 *        robust/extensible/localizable/etc. for your use!
 * 
 * @module Formatters
 * @namespace Slick
 */

(function ($) {
  // register namespace
  $.extend(true, window, {
    "Slick": {
      "Formatters": {
        "PercentComplete": PercentCompleteFormatter,
        "PercentCompleteBar": PercentCompleteBarFormatter,
        "YesNo": YesNoFormatter,
        "Checkmark": CheckmarkFormatter,
        "Checkbox": CheckboxFormatter,


        "MoneyFormatter": MoneyFormatter

      }
    }
  });

  function PercentCompleteFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "-";
    } else if (value < 50) {
      return "<span style='color:red;font-weight:bold;'>" + value + "%</span>";
    } else {
      return "<span style='color:green'>" + value + "%</span>";
    }
  }

  function PercentCompleteBarFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var color;

    if (value < 30) {
      color = "red";
    } else if (value < 70) {
      color = "silver";
    } else {
      color = "green";
    }

    return "<span class='percent-complete-bar' style='background:" + color + ";width:" + value + "%'></span>";
  }

  function YesNoFormatter(row, cell, value, columnDef, dataContext) {
    return value ? "Yes" : "No";
  }

  function CheckboxFormatter(row, cell, value, columnDef, dataContext) {
    return '<img class="slick-edit-preclick" src="../images/' + (value ? "CheckboxY" : "CheckboxN") + '.png">';
  }

  function CheckmarkFormatter(row, cell, value, columnDef, dataContext) {
    return value ? "<img src='../images/tick.png'>" : "";
  }

  function MoneyFormatter(row, cell, value, columnDef, dataContext) {
    var U = ax5.util;
    value = (""+value).replace(/[^0-9^\.^\-]/g, "");
    var regExpPattern = new RegExp("([0-9])([0-9][0-9][0-9][,.])");
    var arrNumber = value.split(".");
    var returnValue;
    arrNumber[0] += ".";
    do {
      arrNumber[0] = arrNumber[0].replace(regExpPattern, "$1,$2");
    } while (regExpPattern.test(arrNumber[0]));

    if (arrNumber.length > 1) {
      returnValue = arrNumber.join("");
    } else {
      returnValue = arrNumber[0].split(".")[0];
    }

    return returnValue;
  }
}) (jQuery);
