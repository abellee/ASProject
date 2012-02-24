<?php
if(isset($_GET["action"])){
	if($_GET["action"] == "screenshot"){
		$data = file_get_contents('php://input');
		$fileName = time().".png";
		if(file_put_contents("ScreenShot/".$fileName,$data)){
			echo $fileName;
		}
	}
	return 0;
}
function createPng($w, $h, $path, $color)
{
	$canvas = imagecreate($w, $h);
	$white = imagecolorallocate($canvas, $color["r"], $color["g"], $color["b"]);
	$black = imagecolorallocate($canvas, 0, 0, 0);
	imagerectangle($canvas, 0, 0, $w-1, $h-1, $black);
	header('Content-Type: image/png');
	$file = $path;
	imagepng($canvas, $file);
	if(is_file($file)){

		$fp = fopen($file, "r");
		$data = addslashes(fread($fp, filesize($file)));
		fclose($fp);

	}
	imagedestroy($canvas);
}
?>
