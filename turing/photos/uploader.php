<?php

/* Get the name of the uploaded file */
$filename = $_FILES['file']['name'];

/* Choose where to save the uploaded file */
$location = "uploads/".$filename;

/* Save the uploaded file to the local filesystem */
if ( move_uploaded_file($_FILES['file']['tmp_name'], $location) ) { 
  echo 'Success $filename'; 
} else { 
  echo 'Failure'; 
}

shell_exec("/usr/bin/python3 /var/www/html/photo/sponsors_photos.py");

?>
