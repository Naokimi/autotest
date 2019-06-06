//Display the images to be uploaded.
$('#photos').on 'change', (e) ->
  multiPhotoDisplay(this);

@readURL = (input) ->
  // #
  // # Read the contents of the image file to be uploaded and display it.
  // #
  if (input.files && input.files[0])
    reader = new FileReader()

    reader.onload = (e) ->
      $('.image_to_upload').attr('src', e.target.result)
      $preview = $('.preview')
      if $preview.hasClass('hide')
        $preview.toggleClass('hide');

    reader.readAsDataURL(input.files[0]);

multiPhotoDisplay = (input) ->
  // #
  // # Read the contents of the image file to be uploaded and display it.
  // #
  if (input.files && input.files[0])
    for file in input.files
      reader = new FileReader()

      reader.onload = (e) ->
        image_html = """<li><a class="th" href="#{e.target.result}"><img width="75" src="#{e.target.result}"></a></li>"""

        $('#photos_clearing').append(image_html)

        if $('.pics-label.hide').length != 0
          $('.pics-label').toggle('hide').removeClass('hide')

        $(document).foundation('reflow')

      reader.readAsDataURL(file)

    window.post_files = input.files
    if window.post_files != undefined
      input.files = $.merge(window.post_files, input.files)
