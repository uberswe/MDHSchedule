<?php
/**
 * Created using JetBrains PhpStorm.
 * Author: Markus Tenghamn
 * Date: 9/12/13
 * Time: 12:24 PM
 * This is not to be removed.
 */

class COMMON {

    public $json = false;
    public $debug = false;

    function COMMON() {

        if (!function_exists('apache_request_headers')) {
///
            function apache_request_headers()
            {
                $arh = array();
                $rx_http = '/\AHTTP_/';
                foreach ($_SERVER as $key => $val) {
                    if (preg_match($rx_http, $key)) {
                        $arh_key = preg_replace($rx_http, '', $key);
                        $rx_matches = array();
                        // do some nasty string manipulations to restore the original letter case
                        // this should work in most cases
                        $rx_matches = explode('_', $arh_key);
                        if (count($rx_matches) > 0 and strlen($arh_key) > 2) {
                            foreach ($rx_matches as $ak_key => $ak_val) $rx_matches[$ak_key] = ucfirst($ak_val);
                            $arh_key = implode('-', $rx_matches);
                        }
                        $arh[$arh_key] = $val;
                    }
                }
                return ($arh);
            }
///
        }

        foreach (apache_request_headers() as $name => $value) {
            //echo "$name: $value\n";
            if ($name == "accept") {
                if ($value == "application/json") {
                    $this->json = true;
                }
            }
        }

        if (isset($_GET['debug'])) {
            $this->debug = true;
        }

        if (isset($_GET['json']) || $this->json) {
            $this->json = true;
            header('Content-Type: application/json; charset=UTF-8');
        } else {
            header('Content-Type: text/html; charset=UTF-8');
        }

    }

    function getAllHeaders() {
                $headers = '';
                foreach ($_SERVER as $name => $value)
                {
                    if (substr($name, 0, 5) == 'HTTP_')
                    {
                        $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
                    }
                }
                return implode(';',$headers);
            }

    function getIP() {
        return $_SERVER['REMOTE_ADDR'];
    }

    function isServerRequest($POST, $FETCH, &$echoVal) {
        global $_GET;
        if (isset($_GET['getCourses'])) {
            $echoVal = $POST->getCourses();
            return true;
        } else if (isset($_GET['getTeacherName'])) {
            $echoVal = $POST->getTeacherName($_GET['getTeacherName']);
            return true;
        } else if (isset($_GET['getTeachersNames'])) {
            $echoVal = $POST->getTeacherNames($_GET['getTeachersNames']);
            return true;
        } else if (isset($_GET['getCoursesOnSeason'])) {
            $echoVal = $POST->getCoursesOnSeason($_GET['getCoursesOnSeason']);
            return true;
        } else if (isset($_GET['getSchedule'])) {
            $echoVal = $POST->getSchedule($_GET['getSchedule'], $_GET['lastUpdated']);
            return true;
        } else if (isset($_GET['getRoomsForPosts'])) {
            $echoVal = $POST->getRoomsForPosts($_GET['getRoomsForPosts']);
            return true;
        } else if (isset($_GET['getRoomDescriptions'])) {
            $echoVal = $POST->getRoomDescriptions($_GET['getRoomDescriptions']);
            return true;
        } else if (isset($_GET['getCourseDetails'])) {
            $echoVal = $POST->getCourseDetails($_GET['getCourseDetails']);
            return true;
        } else if (isset($_GET['getPosts'])) {
            $echoVal = $POST->getPosts($_GET['getPosts']);
            return true;
        } else if (isset($_GET['getMaps'])) {
            $echoVal = $POST->getMaps($_GET['getMaps']);
            return true;
        } else if (isset($_GET['getRoomLocations'])) {
            $echoVal = $POST->getRoomLocations($_GET['getRoomLocations']);
            return true;
        } else if (isset($_GET['link'])) {
            $echoVal = $POST->link($_GET['link']);
            return true;
        } else if (isset($_GET['cron']) && $_GET['cron'] == "courses") {
            $echoVal = $FETCH->fetchCourses($_GET['debug']);
            return true;
        } else if (isset($_GET['cron']) && $_GET['cron'] == "fetch") {
            $echoVal = $FETCH->fetchPosts($_GET['debug'], $_GET['override']);
            return true;
        }
        return false;
    }
}