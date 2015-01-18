<?php

/**
 * Created using JetBrains PhpStorm.
 * Author: Markus Tenghamn
 * Date: 9/12/13
 * Time: 12:37 PM
 * This is not to be removed.
 */
class FETCH
{
    protected $common;

    function COMMON($common)
    {

        $this->common = $common;

    }

    function getStringBetweenStrings($string1, $string2, &$origString){
        $origString = str_replace($string1, "", $origString);
        $string = explode($string2, $origString, 2);
        if (isset($string[1])) {
            $origString = $string[1];
        }
        if (isset($string[0])) {
            return trim($string[0]);
        }
        return "";
    }

    function fetchCourses($setDebug = null)
    {
        $result = "";
        if (!is_object($this->common)) {
            $this->common = NEW COMMON();
        }
        $this->common->debug = $setDebug;
        //http://webbschema.mdh.se/SchemaSok?sokOrd=-
        $ch = curl_init();
        // Set query data here with the URL
        curl_setopt($ch, CURLOPT_URL, 'http://webbschema.mdh.se/ajax/ajax_sokResurser.jsp?sokord=-&startDatum=idag&slutDatum=&intervallTyp=m&intervallAntal=6');
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET');

        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, '30');

        $coursesarray = array();

        if (curl_exec($ch) === false) {
            if ($this->common->debug) {
                $result .= 'Curl error: ' . curl_error($ch);
            }
        } else {
            $content = trim(curl_exec($ch));

            $dom = new DOMDocument();
            @$dom->loadHTML($content);

            // run xpath for the dom

            $xPath = new DOMXPath($dom);


            // get links from starting page
            $section = 0;
            $count = 0;
            $elements = $xPath->query("//a | //h2");
            foreach ($elements as $e) {
                $course = $e->nodeValue;
                //echo $course.'<br/>';
                if ($course == "Kurser") {
                    $section = 1;
                } else if ($course == "Signaturer") {
                    $section = 2;
                } else if ($course == "Lokaler") {
                    $section = 3;
                } else if ($course == "") {

                } else {
                    if ($section == 1) {
                        $coursesplit = explode('-', $course);
                        $parts = explode(",", $course, 2);
                        $code = trim($parts[0]);
                        $desc = trim($parts[1]);

                        if ($this->common->debug) {
                            $result .= $code . '<br/>';
                        }

                        $season = "";
                        $coursecode = "";
                        $findcourses = mysql_query("SELECT * FROM Courses WHERE CourseID = '$code'");
                        if (mysql_num_rows($findcourses) == 0) {
                            if (strpos($desc, '(endast tentamen)') !== false) {
                                $season = "TEN";
                                $desc = str_replace(" (endast tentamen)", "", $desc);
                            } else if (strpos($code, 'H10') !== false) {
                                $season = "H10";
                            } else if (strpos($code, 'V11') !== false) {
                                $season = "V11";
                            } else if (strpos($code, 'H11') !== false) {
                                $season = "H11";
                            } else if (strpos($code, 'V12') !== false) {
                                $season = "V12";
                            } else if (strpos($code, 'H12') !== false) {
                                $season = "H12";
                            } else if (strpos($code, 'V13') !== false) {
                                $season = "V13";
                            } else if (strpos($code, 'H13') !== false) {
                                $season = "H13";
                            } else if (strpos($code, 'V14') !== false) {
                                $season = "V14";
                            } else if (strpos($code, 'H14') !== false) {
                                $season = "H14";
                            } else if (strpos($code, 'V15') !== false) {
                                $season = "V15";
                            } else if (strpos($code, 'H15') !== false) {
                                $season = "H15";
                            } else if (strpos($code, 'V16') !== false) {
                                $season = "V16";
                            } else if (strpos($code, 'H16') !== false) {
                                $season = "H16";
                            } else if (strpos($code, 'V17') !== false) {
                                $season = "V17";
                            } else if (strpos($code, 'H17') !== false) {
                                $season = "H17";
                            } else if (strpos($code, 'V18') !== false) {
                                $season = "V18";
                            }
                            if (substr($code, -1) == "-") {
                                $coursecode = rtrim($code, "-");
                            } else {
                                $coursecode = $code;
                            }
                            $explodingcodes = explode("-", $coursecode);
                            $coursecode = $explodingcodes[0];
                            mysql_query("INSERT INTO Courses (CourseID, CourseName, CourseSeason, CourseCode) VALUES ('$code','$desc', '$season', '$coursecode')");
                            $coursesarray[] = $code;
                            $count++;

                            if ($this->common->debug) {
                                $result .= 'added course<br/>';
                            }
                        } else {
                            $coursesarray[] = $code;

                            if ($this->common->debug) {
                                $result .= 'added to array<br/>';
                            }
                            $count++;
                        }
                    }
                    if ($section == 2) {
                        $coursesplit = explode('-', $course);
                        $parts = explode(",", $course, 2);
                        $code = trim($parts[0]);
                        $desc = "";
                        if (isset($parts[1])) {
                            $desc = trim($parts[1]);
                        }
                        $findcourses = mysql_query("SELECT * FROM Teachers WHERE TeacherID = '$code'");
                        if (mysql_num_rows($findcourses) == 0) {
                            mysql_query("INSERT INTO Teachers (TeacherID, TeacherName) VALUES ('$code','$desc')");

                            if ($this->common->debug) {
                                $result .= 'added teacher<br/>';
                            }
                            $count++;
                        }
                    }
                    if ($section == 3) {
                        $coursesplit = explode('-', $course);
                        $parts = explode(",", $course, 2);
                        $code = trim($parts[0]);
                        $desc = "";
                        if (isset($parts[1])) {
                            $desc = trim($parts[1]);
                        }
                        $findcourses = mysql_query("SELECT * FROM Rooms WHERE RoomID = '$code'");
                        if (mysql_num_rows($findcourses) == 0) {
                            mysql_query("INSERT INTO Rooms (RoomID, RoomDescription) VALUES ('$code','$desc')");
                            if ($this->common->debug) {
                                $result .= 'added room<br/>';
                            }
                            $count++;
                        }
                    }
                }
            }
        }
        curl_close($ch);

        //Delete old courses

        if ($this->common->debug) {
            $result .= "Count: " . $count . "<br/>";
        }
        if ($count > 20) {
            $allcourses = mysql_query("SELECT CourseID FROM Courses");
            while ($d = mysql_fetch_array($allcourses)) {
                $courseid = $d['CourseID'];
                $c = 0;
                foreach ($coursesarray as $ca) {
                    if ($ca == $courseid) {
                        $c = 1;
                        if ($this->common->debug) {
                            $result .= $ca . ' Exists<br/>';
                        }
                    }
                }
                if ($c == 0) {

                    if ($this->common->debug) {
                        $result .= $courseid . ' Does not exist<br/>';
                    }
                    mysql_query("DELETE FROM Courses WHERE CourseID = '" . $courseid . "'");

                    if ($this->common->debug) {
                        $result .= 'deleted ' . $courseid . '<br/>';
                    }
                }
            }
            $findbookedrooms = mysql_query("SELECT * FROM BookedRooms");
            while ($d = mysql_fetch_array($findbookedrooms)) {
                $bookingid = $d['PostID'];
                $findbooking = mysql_query("SELECT * FROM Posts Where PostID = '" . $bookingid . "'");
                if (mysql_num_rows($findbooking) == 0) {
                    mysql_query("DELETE FROM BookedRooms WHERE PostID = '" . $bookingid . "'");

                    if ($this->common->debug) {
                        $result .= 'deleted ' . $bookingid . '<br/>';
                    }
                }
            }
        }
        return $result;
    }

    function fetchPosts($setDebug = null, $override = null)
    {
        $result = "";
        $resource = "";
        $coursearray = array();
        if (!is_object($this->common)) {
            $this->common = NEW COMMON();
        }
        $this->common->debug = $setDebug;
        // http://webbschema.mdh.se/setup/jsp/SchemaXML.jsp?resurser=k.BMA005-22167H12-,
//$url = "http://webbschema.mdh.se/setup/jsp/SchemaXML.jsp?resurser=k.DVA101-24145H12-,";
//if (isset($_GET['resurser']) && $_GET['resurser'] != null) {
//	$resource = mysql_escape_string($_GET['resurser']);
//	$url = "http://webbschema.mdh.se/setup/jsp/SchemaXML.jsp?resurser=".$resource;
//}
        if (!(isset($setDebug) && isset($override))) {
            $fetchcourses = mysql_query("SELECT CourseID FROM Courses ORDER BY fetched_count ASC LIMIT 10");
        }
        if ((isset($setDebug) && isset($override)) || mysql_num_rows($fetchcourses) > 0) {

            if (!(isset($setDebug) && isset($override))) {
                $i = 0;
                $resource = "";
                while ($data = mysql_fetch_array($fetchcourses)) {
                    $coursecode = $data['CourseID'];
                    if ($i == 0) {
                        $resource = "k." . $coursecode;
                    } else {
                        $resource .= ",k." . $coursecode;
                    }
                    $coursearray[] = $coursecode;
                    mysql_query("UPDATE Courses SET fetched_count = fetched_count +1 WHERE CourseID = '$coursecode'");
                    $i++;
                }
            } else {
                $resource = $override;
                if ($this->common->debug) {
                    $result .= 'override active<br/>';
                }
            }
            $url = "http://webbschema.mdh.se/setup/jsp/SchemaXML.jsp?resurser=" . $resource;
            $handle = curl_init($url);
            curl_setopt($handle, CURLOPT_RETURNTRANSFER, TRUE);

            /* Check for 404 (file not found). */
            $httpCode = curl_getinfo($handle, CURLINFO_HTTP_CODE);
            if ($httpCode == 200) {


                curl_close($handle);
                if ($this->common->debug) {
                    $result .= $url;
                }
                try {

                    $dom = new DOMDocument();
                    $dom->load($url);

                    $count = 0;
                    $postarray = array();
                    $root = $dom->getElementsByTagName("schemaPost");
                    foreach ($root as $tag) {
                        $subChild5 = $tag->getElementsByTagName("moment");
                        foreach ($subChild5 as $bid) {
                            $instancename = $bid->nodeValue;
                        }

                        $subChild6 = $tag->getElementsByTagName("bokadeDatum");
                        foreach ($subChild6 as $bid) {
                            $startDatumTid = $bid->getAttribute('startDatumTid');
                            $endDatumTid = $bid->getAttribute('slutDatumTid');
                        }

                        $subChild = $tag->getElementsByTagName("bokningsId");
                        foreach ($subChild as $bid) {
                            $instanceid = $bid->nodeValue;
                        }
                        $subChild2 = $tag->getElementsByTagName("senastAndradDatum");
                        foreach ($subChild2 as $bid2) {
                            $lastupdated = $bid2->nodeValue;
                        }

                        $teacher = "";
                        $coursename = "";
                        $room = "";

                        $subChild3 = $tag->getElementsByTagName("resursNod");
                        foreach ($subChild3 as $bid3) {

                            if ($bid3->getAttribute('resursTypId') == "RESURSER_SIGNATURER") {

                                $subChild4 = $bid3->getElementsByTagName("resursId");
                                foreach ($subChild4 as $bid4) {
                                    $teacher = $bid4->nodeValue;
                                }

                            }

                            if ($bid3->getAttribute('resursTypId') == "UTB_KURSINSTANS_GRUPPER") {

                                $subChild4 = $bid3->getElementsByTagName("resursId");
                                foreach ($subChild4 as $bid4) {
                                    $coursename = $bid4->nodeValue;
                                }

                            }

                            if ($bid3->getAttribute('resursTypId') == "RESURSER_LOKALER") {

                                $subChild4 = $bid3->getElementsByTagName("resursId");
                                $roomsArray = array();
                                foreach ($subChild4 as $bid4) {
                                    $room = $bid4->nodeValue;
                                    $findrooms = mysql_query("SELECT * FROM BookedRooms WHERE PostID = '$instanceid' AND RoomID = '$room'");
                                    if (mysql_num_rows($findrooms) == 0) {

                                        mysql_query("INSERT INTO BookedRooms (PostID, RoomID) VALUES ('$instanceid', '$room')");
                                        $roomsArray[] = $room;


                                        if ($this->common->debug) {
                                            $result .= 'Inserted new room ' . $room . '<br/>';
                                        }
                                    } else {
                                        if ($this->common->debug) {
                                            $result .= 'Room exists ' . $room . '<br/>';
                                        }
                                        $roomsArray[] = $room;
                                    }
                                }
                                //Cleanup
                                $findAllRooms = mysql_query("SELECT * FROM BookedRooms WHERE PostID = '$instanceid'");
                                while ($roomData = mysql_fetch_array($findAllRooms)) {
                                    $roomNameId = $roomData['RoomID'];
                                    $found = 0;
                                    foreach ($roomsArray as $ra) {
                                        if ($roomNameId == $ra) {
                                            $found = 1;
                                        }
                                    }
                                    if ($found == 0) {
                                        mysql_query("DELETE FROM BookedRooms WHERE PostID = '" . $instanceid . "' AND RoomID = '" . $roomNameId . "'") or die(mysql_error());
                                        if ($this->common->debug) {
                                            $result .= 'Room deleted ' . $roomNameId . '<br/>';
                                        }
                                    }
                                }

                            }

                        }


                        $findinstance = mysql_query("SELECT * FROM Posts WHERE PostID = '$instanceid'");
                        //2013-09-13 11:00:00
                        $lastupdatedLocally = date('Y-m-d h:i:s', time());
                        if (mysql_num_rows($findinstance) == 0) {
                            $postarray[] = $instanceid;
                            $count++;
                            mysql_query("INSERT INTO Posts (PostDescription, PostID, PostStartDate, PostEndDate, CourseID, LastUpdated, LastUpdatedMDH, TeacherID) VALUES ('$instancename', '$instanceid', '$startDatumTid', '$endDatumTid', '$coursename', '$lastupdatedLocally', '$lastupdated', '$teacher')");
                            if ($this->common->debug) {
                                $result .= 'Inserted new post<br/>';
                            }
                        } else {
                            $postarray[] = $instanceid;
                            $different = false;
                            while ($instanceData = mysql_fetch_array($findinstance)) {
                                if (isset($lastupdated) && $lastupdated != $instanceData['LastUpdatedMDH']) {
                                    $different = true;
                                } elseif (isset($instancename) && $instancename != $instanceData['PostDescription']) {
                                    $different = true;
                                } elseif (isset($startDatumTid) && $startDatumTid != $instanceData['PostStartDate']) {
                                    $different = true;
                                } elseif (isset($endDatumTid) && $endDatumTid != $instanceData['PostEndDate']) {
                                    $different = true;
                                } elseif (isset($teacher) && $teacher != $instanceData['TeacherID']) {
                                    $different = true;
                                }
                                break;
                            }
                            $count++;
                            if ($different) {
                                mysql_query("UPDATE Posts SET PostDescription = '$instancename', PostStartDate = '$startDatumTid', PostEndDate = '$endDatumTid', LastUpdated = '$lastupdatedLocally', LastUpdatedMDH = '$lastupdated', TeacherID = '$teacher', FetchCount = FetchCount +1 WHERE PostID = '$instanceid'") or die(mysql_error());
                                if ($this->common->debug) {

                                    $result .= 'Post updated - last updated ' . $lastupdated . '<br/>';
                                }
                            }
                        }
                    }
                } catch (exception $e) {
                    //Silent fail here
                }
            } else {
                $count = 0;
                //Try iCal
                //http://webbschema.mdh.se/setup/jsp/SchemaICAL.ics?resurser=k.BMA005-%2Ck.MAA312-%2C
                //http://webbschema.mdh.se/setup/jsp/SchemaXML.jsp?resurser=k.SVA420-VA420H14-
                $ical = new ICal('http://webbschema.mdh.se/setup/jsp/SchemaICAL.ics?resurser=' . $resource);

                //echo '<pre>';
                //print_r($ical->events());
                //echo '</pre>';
                foreach ($ical->events() as $events) {
                    //20141009T071500Z
                    //This is probably overkill but it converts correctly
                    $startDatumTid = date('Y-m-d h:i:s', strtotime(str_replace("Z", "",str_replace("T", " ",$events['DTSTART']))));
                    $endDatumTid= date('Y-m-d h:i:s', strtotime(str_replace("Z", "",str_replace("T", " ",$events['DTEND']))));
                    $instanceid = $events['UID'];
                    $lastupdated = $events['LAST-MODIFIED'];
                    $rooms = explode(" ", $events['LOCATION']);
                    $summary = $events['SUMMARY'];

                    $coursename = $this->getStringBetweenStrings('Kurs.grp:', 'Sign:', $summary);
                    $teacher = $this->getStringBetweenStrings('Sign:', 'Moment:', $summary);
                    $instancename = $this->getStringBetweenStrings('Moment:', 'Aktivitetstyp:', $summary);

                    $roomsArray = array();
                    //Book the rooms
                    foreach ($rooms as $room) {
                        $findrooms = mysql_query("SELECT * FROM BookedRooms WHERE PostID = '$instanceid' AND RoomID = '$room'");
                        if (mysql_num_rows($findrooms) == 0) {

                            mysql_query("INSERT INTO BookedRooms (PostID, RoomID) VALUES ('$instanceid', '$room')");
                            $roomsArray[] = $room;


                            if ($this->common->debug) {
                                $result .= 'Inserted new room ' . $room . '<br/>';
                            }
                        } else {
                            if ($this->common->debug) {
                                $result .= 'Room exists ' . $room . '<br/>';
                            }
                            $roomsArray[] = $room;
                        }
                    }
                    //Cleanup
                    $findAllRooms = mysql_query("SELECT * FROM BookedRooms WHERE PostID = '$instanceid'");
                    while ($roomData = mysql_fetch_array($findAllRooms)) {
                        $roomNameId = $roomData['RoomID'];
                        $found = 0;
                        foreach ($roomsArray as $ra) {
                            if ($roomNameId == $ra) {
                                $found = 1;
                            }
                        }
                        if ($found == 0) {
                            mysql_query("DELETE FROM BookedRooms WHERE PostID = '" . $instanceid . "' AND RoomID = '" . $roomNameId . "'") or die(mysql_error());
                            if ($this->common->debug) {
                                $result .= 'Room deleted ' . $roomNameId . '<br/>';
                            }
                        }
                    }
                    //Insert the instance or "post"

                    $findinstance = mysql_query("SELECT * FROM Posts WHERE PostID = '$instanceid'");
                    //2013-09-13 11:00:00
                    $lastupdatedLocally = date('Y-m-d h:i:s', time());
                    if (mysql_num_rows($findinstance) == 0) {
                        $postarray[] = $instanceid;
                        $count++;
                        mysql_query("INSERT INTO Posts (PostDescription, PostID, PostStartDate, PostEndDate, CourseID, LastUpdated, LastUpdatedMDH, TeacherID) VALUES ('$instancename', '$instanceid', '$startDatumTid', '$endDatumTid', '$coursename', '$lastupdatedLocally', '$lastupdated', '$teacher')");
                        if ($this->common->debug) {
                            $result .= 'Inserted new post<br/>';
                        }
                    } else {
                        $postarray[] = $instanceid;
                        $different = false;
                        while ($instanceData = mysql_fetch_array($findinstance)) {
                            if (isset($lastupdated) && $lastupdated != $instanceData['LastUpdatedMDH']) {
                                $different = true;
                            } elseif (isset($instancename) && $instancename != $instanceData['PostDescription']) {
                                $different = true;
                            } elseif (isset($startDatumTid) && $startDatumTid != $instanceData['PostStartDate']) {
                                $different = true;
                            } elseif (isset($endDatumTid) && $endDatumTid != $instanceData['PostEndDate']) {
                                $different = true;
                            } elseif (isset($teacher) && $teacher != $instanceData['TeacherID']) {
                                $different = true;
                            }
                            break;
                        }
                        $count++;
                        if ($different) {
                            mysql_query("UPDATE Posts SET PostDescription = '$instancename', PostStartDate = '$startDatumTid', PostEndDate = '$endDatumTid', LastUpdated = '$lastupdatedLocally', LastUpdatedMDH = '$lastupdated', TeacherID = '$teacher', FetchCount = FetchCount +1 WHERE PostID = '$instanceid'") or die(mysql_error());
                            if ($this->common->debug) {

                                $result .= 'Post updated - last updated ' . $lastupdated . '<br/>';
                            }
                        }
                    }
                }
                //[DTSTART] => 20141009T071500Z
                //[DTEND] => 20141009T100000Z
                //[DTSTAMP] => 20141009T193900Z //Server time?
                //[UID] => BokningsId_20140626_000000217
                //[CREATED] => 20140626T135401Z
                //[LAST-MODIFIED] => 20140905T133444Z
                //[LOCATION] => U2-003
                //[SEQUENCE] => 2
                //[STATUS] => CONFIRMED
                //[SUMMARY] => Kurs.grp: MMA132-21055H14- Sign: kld02 Moment: Laboration 3 - Grupp A Aktivitetstyp: Okänd
                //[TRANSP] => OPAQUE
                //[X-GWSHOW-AS] => BUSY
            }

            //DELETE OLD INSTANCES
            //Todo make sure this works
//        foreach ($coursearray as $ca) {
//
//            if ($this->common->debug) {
//                $result .= '1<br/>';
//                $result .= $ca.'<br/>';
//            }
//            $findposts = mysql_query("SELECT PostID FROM Posts WHERE CourseID = '".$ca."'");
//            while ($d = mysql_fetch_array($findposts)) {
//                if ($this->common->debug) {
//                    $result .= '2<br/>';
//                }
//                $postid = $d['PostID'];
//                $check = 0;
//                foreach ($postarray as $p) {
//                    if ($p == $postid) {
//                        $check = 1;
//                    }
//                }
//                if ($check == 0) {
//                    mysql_query("DELETE FROM Posts WHERE PostID = '".$postid."'");
//                    if ($this->common->debug) {
//                        $result .= 'DELETED '.$postid.'<br/>';
//                    }
//                }
//            }
//        }
//
//            //DELETE instances where courses don't exist
//
//
//            //TODO check if sql is right
//            mysql_query("DELETE FROM Posts WHERE CourseID NOT IN (SELECT CourseID FROM Courses)")or die(mysql_error());

        }
        return $result;
    }
}