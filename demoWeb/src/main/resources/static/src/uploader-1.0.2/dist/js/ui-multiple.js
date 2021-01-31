// Creates a new file and add it to our list
function ui_multi_add_file(el,id, file)
{
	console.log(file)
  var files_template = el.querySelector('#files-template');
  var files = el.querySelector('#files');
	
  console.log('ui_multi_add_file');
  var template = $(files_template).text();
  template = template.replace('%%filename%%', file.name);

  template = $(template);
  template.prop('id', 'uploaderFile' + id);
  template.data('file-id', id);

  $(files).find('li.empty').fadeOut(); // remove the 'no files yet'
  console.log(template);
  $(files).prepend(template);
}

// Changes the status messages on our list
function ui_multi_update_file_status(el,id, status, message)
{
  var uploaderFile = el.querySelector('#uploaderFile' + id);
  $(uploaderFile).find('span').html(message).prop('class', 'status text-' + status);
}

// Updates a file progress, depending on the parameters it may animate it or change the color.
function ui_multi_update_file_progress(el,id, percent, color, active)
{
  
  color = (typeof color === 'undefined' ? false : color);
  active = (typeof active === 'undefined' ? true : active);

  var uploaderFile = el.querySelector('#uploaderFile' + id);
  var bar = $(uploaderFile).find('div.progress-bar');

  bar.width(percent + '%').attr('aria-valuenow', percent);
  bar.toggleClass('progress-bar-striped progress-bar-animated', active);

  if (percent === 0){
    bar.html('');
  } else {
    bar.html(percent + '%');
  }

  if (color !== false){
    bar.removeClass('bg-success bg-info bg-warning bg-danger');
    bar.addClass('bg-' + color);
  }
}

// Toggles the disabled status of Star/Cancel buttons on one particual file
function ui_multi_update_file_controls(id, start, cancel, wasError)
{
  wasError = (typeof wasError === 'undefined' ? false : wasError);

  $('#uploaderFile' + id).find('button.start').prop('disabled', !start);
  $('#uploaderFile' + id).find('button.cancel').prop('disabled', !cancel);

  if (!start && !cancel) {
    $('#uploaderFile' + id).find('.controls').fadeOut();
  } else {
    $('#uploaderFile' + id).find('.controls').fadeIn();
  }

  if (wasError) {
    $('#uploaderFile' + id).find('button.start').html('Retry');
  }
}
