#!/bin/bash

# navigate to desktop
cd ~/Desktop

# create temporary "upload endpoint"
touch index.php
echo "<?php
  // choose a filename
  \$filename = 'uploaded_image.jpg';

  // access the input stream via php://input
  \$input = fopen('php://input', 'rb');
  \$file = fopen(\$filename, 'wb');

  stream_copy_to_stream(\$input, \$file);
  fclose(\$input);
  fclose(\$file);
?>" > index.php

# run php server
php -S localhost:8080

# remove temporary "upload endpoint"
rm index.php
