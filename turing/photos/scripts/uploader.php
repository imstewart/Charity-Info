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

shell_exec("sudo /usr/bin/python3 /var/www/html/photo/sponsors_photos.py"); 

echo("Width: " . $_POST['Width'] . "<br />");
echo("Height: " . $_POST['Height'] . "<br />");
echo("X: " . $_POST['X'] . "<br />");
echo("Y: " . $_POST['Y'] . "<br />");

$myfile = fopen("/var/www/html/photos/position.txt", "w") or die("Unable to open file!");
$txt = $_POST['Width'];
fwrite($myfile, $txt);
$txt = $_POST['Heigth'];
fwrite($myfile, $txt);
$txt = $_POST['X'];
fwrite($myfile, $txt);
$txt = $_POST['Y'];
fwrite($myfile, $txt);
fclose($myfile);

?>
