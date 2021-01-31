  /*
   * Some helper functions to work with our UI and keep our code cleaner
   */

// Adds an entry to our debug area
function ui_add_log(el,message, color)
{
  var debug_template = el.querySelector('#debug-template');
  var debug = el.querySelector('#debug');
  var d = new Date();
  var dateString = (('0' + d.getHours())).slice(-2) + ':' +
    (('0' + d.getMinutes())).slice(-2) + ':' +
    (('0' + d.getSeconds())).slice(-2);

  color = (typeof color === 'undefined' ? 'muted' : color);

  var template = $(debug_template).text();
  template = template.replace('%%date%%', dateString);
  template = template.replace('%%message%%', message);
  template = template.replace('%%color%%', color);
  
  $(debug).find('li.empty').fadeOut(); // remove the 'no messages yet'
  $(debug).prepend(template);
}