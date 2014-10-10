<?php
/**
 * Created using JetBrains PhpStorm.
 * Author: Markus Tenghamn
 * Date: 9/12/13
 * Time: 12:09 PM
 * This is not to be removed.
 */

class DB {

    function DB($host, $database, $user, $pass) {
        $con = mysql_connect($host, $user, $pass);
        if (!$con) {
            die('Could not connect: ' . mysql_error());
        }
        mysql_select_db($database, $con);
        mysql_set_charset('utf8', $con);
    }

}