http_path = "/"
css_dir = "public/css/lib"
sass_dir = "src/sass"
add_import_path "bower_components"
images_dir = "/img"
javascripts_dir = "public/js/lib"
if environment == :production
  output_style = :compressed
  line_comments = false
else
  output_style = :expanded
  line_comments = true
end
