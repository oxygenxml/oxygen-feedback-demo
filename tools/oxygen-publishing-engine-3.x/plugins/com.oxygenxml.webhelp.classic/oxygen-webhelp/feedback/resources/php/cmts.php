<?php
/*
    
Oxygen WebHelp Plugin
Copyright (c) 1998-2020 Syncro Soft SRL, Romania.  All rights reserved.

*/

function readCms($includeFile)
{
    $contents = '';
    if (file_exists($includeFile)) {
        $handle = fopen($includeFile, "r");
        while (!feof($handle)) {
            $contents .= fread($handle, filesize($includeFile));
        }
        fclose($handle);
    }
    //sleep(5);
    return $contents;
}

$cmtsPage = "cmts.html";
if (isset($_GET['type']) && $_GET['type']=="responsive"){
    $cmtsPage = "cmts_responsive.html";
}

$depthStr = "";
$pos = strpos($_SERVER['PHP_SELF'], $_POST['depth']);

if (isset($_POST['depth']) && trim($_POST['depth']) != '' && $pos === 0) {
    $depthStr = trim($_POST['depth']);
}

if ($_POST['isInstaller']) {
    $baseDir = dirname(dirname(__FILE__));

    $realInclude = $baseDir . '/' . $cmtsPage;
    $contents = readCms($realInclude);
    $contents = str_replace("@relPath@", $depthStr, $contents);
    ob_start();
    ob_clean();
    flush();
    echo $contents;
    ob_end_flush();
} else {

    $baseDir = dirname(dirname(__FILE__));
    require_once $baseDir . '/php/init.php';

    $ses = Session::getInstance();
    if (!isset($ses->errBag)) {
        $ses->errBag = new OxyBagHandler();
    }

    $realInclude = $baseDir . '/' . $cmtsPage;
    $contents = readCms($realInclude);
    $contents = str_replace("@relPath@", $depthStr, $contents);
    ob_start();
    ob_clean();
    flush();
    echo $contents;
    ob_end_flush();

}
?>
