<?php


error_reporting(E_ALL);
ini_set('display_errors', '0');

/*** nullify any existing autoloads ***/
spl_autoload_register(null, false);

/*** specify extensions that may be loaded ***/
spl_autoload_extensions('.php, .class.php');

/*** class Loader ***/
function classLoader($class)
{
    $filename = strtoupper($class) . '.class.php';
    $file = 'classes/' . $filename;
//    if (!file_exists($file)) {
//        return false;
//    }
    include $file;
}

/*** register the loader functions ***/
spl_autoload_register('classLoader');

$DB = new DB("localhost", "zadmin_mdhschedule", "mdhschedule", "yzupe2ujy");
$COMMON = new COMMON();
$ANALYTICS = new ANALYTICS();
$FETCH = new FETCH($COMMON);
$POST = new POST($COMMON, $ANALYTICS);

$echoVal = '';



?>