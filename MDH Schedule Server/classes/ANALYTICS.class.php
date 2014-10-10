<?php
/**
 * Created using JetBrains PhpStorm.
 * Author: Markus Tenghamn
 * Date: 9/14/13
 * Time: 3:42 AM
 * This is not to be removed.
 */

class ANALYTICS {

    function ANALYTICS() {

    }

    function logEvent($type, $string, $identity, $device) {
        $date = date('Y-m-d h:i:s', time());
        mysql_query("INSERT INTO Analytics (RequestType, RequestString, DateTime, IdentityBlob, DeviceType) VALUES ('".mysql_real_escape_string($type)."', '".mysql_real_escape_string($string)."', '".$date."', '".mysql_real_escape_string($identity)."', '".mysql_real_escape_string($device)."')");
    }
}