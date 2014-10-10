<?php

error_reporting(E_ALL);
ini_set('display_errors', '1');

/*** nullify any existing autoloads ***/
spl_autoload_register(null, false);

/*** specify extensions that may be loaded ***/
spl_autoload_extensions('.php, .class.php');

/*** class Loader ***/
function classLoader($class)
{
    $filename = strtoupper($class) . '.class.php';
    $file = 'classes/' . $filename;
    if (!file_exists($file)) {
        return false;
    }
    include $file;
}

/*** register the loader functions ***/
spl_autoload_register('classLoader');

$DB = new DB("mysql443.loopia.se", "mdhschedule_com", "mdhsched@m88679", "XCQ3_K7D[x8Yj*(");
$COMMON = new COMMON();
$ANALYTICS = new ANALYTICS();
$FETCH = new FETCH($COMMON);
$POST = new POST($COMMON, $ANALYTICS);

if (!$COMMON->isServerRequest($POST, $FETCH, $echoVal)) {
    echo '<html><head>
    <title>MDH Schedule Server</title>
    </head>
    <body>
    <h1>Welcome to the MDH Schedule Server</h1>
    <p>User <input type="text"></p>
    <p>Pass <input type="password"></p>
    <p><input type="submit" value="login"></p>
    </body>
    </html>';
} else {
    echo $echoVal;
}
?>