<?php
/**
 * Created using JetBrains PhpStorm.
 * Author: Markus Tenghamn
 * Date: 9/12/13
 * Time: 12:37 PM
 * This is not to be removed.
 */

class POST {

    protected $common;
    protected $analytics;

    function POST($common, $analytics) {

        $this->common = $common;
        $this->analytics = $analytics;

    }

    function getCourses() {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("getCourses", "", $identity, $device);
        $result = "";
        $courses = mysql_query("SELECT * FROM Courses ORDER BY CourseID ASC");
        if ($this->common->json) {
            $rows = array();
            while ($r = mysql_fetch_assoc($courses)) {
                $rows[] = $r;
            }
            $result .= json_encode($rows);
        } else {
            $result .= 'CourseID,CourseName,CourseSeason,CourseCode' . "\r\n";
            while ($data = mysql_fetch_array($courses)) {
                $code = $data['CourseID'];
                $name = $data['CourseName'];
                $season = $data['CourseSeason'];
                $coursecode = $data['CourseCode'];
                $strings = explode('"', $name);
                $i = 0;
                foreach ($strings as $s) {
                    if ($i == 0) {
                        $name = $s;
                    } else {
                        $name .= '"' . $s;
                    }
                    $i++;
                }
                $result .= $code . ',"' . $name . '"' . ',' . $season . ',' . $coursecode . "\r\n";
            }
        }
        return $result;
    }

    function getTeacherName($teacherID) {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("getTeacherName", $teacherID, $identity, $device);
        $result = "";
        $tname = trim(mysql_escape_string($teacherID));
        if (!$this->common->json) {
            $result .= 'TeacherID,TeacherName' . "\r\n";
        }
        $teachers = mysql_query("SELECT TeacherName FROM Teachers WHERE TeacherID = '" . $tname . "' LIMIT 1");
        if ($this->common->json) {
            $rows = array();
            while ($r = mysql_fetch_assoc($teachers)) {
                $rows[] = $r;
            }
            $result .= json_encode($rows);

        } else {
            while ($data = mysql_fetch_array($teachers)) {
                $name = $data['TeacherName'];
                $result .= $name . "\r\n";
            }
        }
        return $result;
    }

    function getTeacherNames($teacherIDs) {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("getTeacherNames", $teacherIDs, $identity, $device);
        $result = "";
        //TeacherID,TeacherName
        $tname = trim(mysql_escape_string($teacherIDs));
        $tnames = explode(",", $tname);
        if (!$this->common->json) {
            $result .= 'TeacherID,TeacherName' . "\r\n";
        }
        foreach ($tnames as $tt) {
            $teachers = mysql_query("SELECT TeacherName FROM Teachers WHERE TeacherID = '" . $tt . "' LIMIT 1");
            if ($this->common->json) {
                $rows = array();
                while ($r = mysql_fetch_assoc($teachers)) {
                    $rows[] = $r;
                }
                $result .= json_encode($rows);

            } else {
                while ($data = mysql_fetch_array($teachers)) {
                    $name = $data['TeacherName'];
                    $result .= $name . "\r\n";
                }
            }
        }
        return $result;
    }

    function getCoursesOnSeason($season) {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("getCoursesOnSeason", $season, $identity, $device);
        $result = "";
        $season = trim(mysql_escape_string($season));

        $courses = mysql_query("SELECT * FROM Courses WHERE CourseSeason = '" . $season . "'");
        if ($this->common->json) {
            $rows = array();
            while ($r = mysql_fetch_assoc($courses)) {
                $rows[] = $r;
            }
            $result .= json_encode($rows);
        } else {
            $result .= 'CourseID,CourseName,CourseCode' . "\r\n";
            while ($data = mysql_fetch_array($courses)) {
                $code = $data['CourseID'];
                $name = $data['CourseName'];
                $coursecode = $data['CourseCode'];
                $strings = explode('"', $name);
                $i = 0;
                foreach ($strings as $s) {
                    if ($i == 0) {
                        $name = $s;
                    } else {
                        $name .= '"' . $s;
                    }
                    $i++;
                }
                $result .= $code . ',"' . $name . '"' . ',' . $coursecode . "\r\n";
            }
        }
        return $result;
    }

    function getSchedule($courses, $lastupdated = null) {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("getSchedule", $courses." ".$lastupdated, $identity, $device);
        $result = "";
        //PostID,PostStartDate,PostEndDate,CourseID,TeacherID,PostDescription,LastUpdated
        $count = 0;
        $nochange = false;
        $courses = explode(",", $courses);
        foreach ($courses as $course) {
            if ($this->common->debug) {
                $result .= $course . "\r\n";
            }

            $nochange = false;
            $lastupdate = '';
            if (isset($lastupdated)) {
                $nochange = true;
                $lastupdate = date("Y-m-d H:i:s", strtotime(trim(mysql_escape_string($lastupdated))));
            }


            $cdetails = mysql_query("SELECT * FROM Posts WHERE CourseID = '" . $course . "'");


            if ($this->common->json) {
                $rows = array();
                while ($r = mysql_fetch_assoc($cdetails)) {
                    $rows[] = $r;
                }
                $result .= json_encode($rows);
            } else {
                while ($data = mysql_fetch_array($cdetails)) {

                    $bookingid = $data['PostID'];
                    $courseid = $course;
                    $lastchanged = $data['LastUpdated'];
                    $startdate = $data['PostStartDate'];
                    $enddate = $data['PostEndDate'];
                    $teacherid = $data['TeacherID'];
                    //$room = $data['RoomID'];
                    $event = $data['PostDescription'];
                    $lastchangedMDH = $data['LastUpdatedMDH'];

                    $lastchangeddate = date("Y-m-d H:i:s", strtotime($lastchanged));

                    if (isset($lastupdated)) {
                        if ($lastupdate < $lastchangeddate) {
                            $nochange = false;
                        } else {
                            $nochange = true;
                        }
                    }


                    if ($count == 0 && !$nochange) {
                        $result .= 'PostID,PostStartDate,PostEndDate,CourseID,TeacherID,PostDescription,LastUpdated,LastUpdatedMDH' . "\r\n";
                    }

                    //PostID,PostStartDate,PostEndDate,CourseID,TeacherID,PostDescription,LastUpdated
                    if (!$nochange) {
                        $result .= $bookingid . ',"' . $startdate . '","' . $enddate . '",' . $courseid . ',' . $teacherid . ',"' . $event . '","' . $lastchanged . '","'.$lastchangedMDH.'"'. "\r\n";
                        $count++;
                    }
                }

            }
        }
        if ($count == 0 && isset($lastupdated) && $nochange) {
            $result .= "nochange";
        }
        return $result;
    }

    function getRoomsForPosts($posts) {
        //$identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        //$device = "";
        //$this->analytics->logEvent("getRoomsForPosts", $posts, $identity, $device);
        $result = "";
        //Input: BokningsId_20120724_000000011,BokningsId_20120724_000000005
        //RoomID,RoomDescription
        $result .= 'RoomID,RoomDescription' . "\r\n";
        $postids = explode(",", mysql_escape_string($posts));
        foreach ($postids as $postid) {
            if ($this->common->debug) {
                $result .= '1<br/>';
            }
            $postid = trim($postid);
            $findrooms = mysql_query("SELECT RoomID FROM BookedRooms WHERE PostID = '" . $postid . "'");
            while ($d = mysql_fetch_array($findrooms)) {
                if ($this->common->debug) {
                    $result .= '2<br/>';
                }
                $roomid = $d['RoomID'];
                $finddetails = mysql_query("SELECT * FROM Rooms WHERE RoomID = '" . $roomid . "'");
                if (mysql_num_rows($finddetails) > 0) {
                    while ($da = mysql_fetch_array($finddetails)) {
                        if ($this->common->debug) {
                            $result .= '3<br/>';
                        }
                        $roomid = $da['RoomID'];
                        $roomdescription = $da['RoomDescription'];
                        $result .= $roomid . ',' . $roomdescription . "\r\n";
                    }
                } else {
                    $result .= $roomid . ',' . "\r\n";
                }
            }
        }
        return $result;
    }

    function getRoomDescriptions($roomIDs) {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("getRoomDescriptions", $roomIDs, $identity, $device);
        $result = "";
        //Input: R1-302,R2-211
        //RoomID,RoomDescription
        $result .= 'RoomID,RoomDescription' . "\r\n";
        $postids = explode(",", mysql_escape_string($roomIDs));
        foreach ($postids as $postid) {
            $postid = trim($postid);
            $finddetails = mysql_query("SELECT * FROM Rooms WHERE RoomID = '" . $postid . "'");
            while ($da = mysql_fetch_array($finddetails)) {
                $roomid = $da['RoomID'];
                $roomdescription = $da['RoomDescription'];
                $result .= $roomid . ',' . $roomdescription . "\r\n";
            }
        }
        return $result;
    }

    function getCourseDetails($course) {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("getCourseDetails", $course, $identity, $device);
        $result = "";
        //Example: http://addr/?getCourseDetails=BTA105-23027H12-
        //Used to get course details
        //Return example: Introduktions Projekt,H12,BTA105

        $course = trim(mysql_escape_string($course));
        $cdetails = mysql_query("SELECT CourseName FROM Courses WHERE CourseID = '" . $course . "' LIMIT 1");
        $id = substr($course, 0, 6);
        $season = "";
        if (strpos($course, 'H12') !== false) {
            $season = substr($course, -4, 3);
        } else if (strpos($course, 'V12') !== false) {
            $season = substr($course, -4, 3);
        } else if (strpos($course, 'H13') !== false) {
            $season = substr($course, -4, 3);
        } else if (strpos($course, 'V13') !== false) {
            $season = substr($course, -4, 3);
        }
        if ($this->common->json) {
            $rows = array();
            while ($r = mysql_fetch_assoc($cdetails)) {
                $rows[] = $r;
                $rows[] = $id;
                $rows[] = $season;
            }
            $result .= json_encode($rows);
        } else {
            while ($data = mysql_fetch_array($cdetails)) {
                $name = $data['CourseName'];

                $result .= $name . ',' . $season . ',' . $id . "\r\n";
            }
        }
        return $result;
    }

    //New functions

    function getMaps() {
        $result = "";
        $maps = mysql_query("SELECT * FROM Maps");
        $result .= 'MapID,MapURL' . "<br/>";
        while ($d = mysql_fetch_array($maps)) {
            $name = $d['MapID'];
            $url = $d['MapURL'];
            $result .= $name . ',<a href="' . $url . '">' . $url . "</a><br/>";
        }
        $result .= 'This query should only be used for reference, not to query and download maps. This is due to server load';
        return $result;
    }

    function getRoomLocations() {
        $result = "";
        $rooml = mysql_query("SELECT * FROM RoomLocations");
        $result .= 'RoomID, MapID, CenterX, CenterY' . "\r\n";
        while ($d = mysql_fetch_array($rooml)) {
            $roomid = $d['RoomID'];
            $mapid = $d['MapID'];
            $centerx = $d['CenterX'];
            $centery = $d['CenterY'];
            $result .= $roomid . ',' . $mapid . ',' . $centerx . ',' . $centery . "\r\n";
        }
        return $result;
    }

    //Legacy functions

    function getPosts($course) {
        $result = "";
        //BookingID,CourseID,LastChanged,StartDate,EndDate,TeacherID,Room,Event

        $course = trim(mysql_escape_string($course));
        $cdetails = mysql_query("SELECT * FROM Posts WHERE CourseID = '" . $course . "'");

        if ($this->common->json) {
            $rows = array();
            while ($r = mysql_fetch_assoc($cdetails)) {
                $rows[] = $r;
            }
            $result .= json_encode($rows);
        } else {
            while ($data = mysql_fetch_array($cdetails)) {
                $bookingid = $data['PostID'];
                $courseid = $course;
                $lastchanged = $data['LastUpdated'];
                $startdate = $data['PostStartDate'];
                $enddate = $data['PostEndDate'];
                $teacherid = $data['TeacherID'];
                $room = $data['RoomID'];
                $event = $data['PostDescription'];
                $result .= $bookingid . ',' . $courseid . ',' . $lastchanged . ',' . $startdate . ',' . $enddate . ',' . $teacherid . ',' . $room . ',' . $event . "\r\n";
            }
        }
        return $result;
    }

    function link($link) {
        $identity = $this->common->getIP()." - ".$this->common->getAllHeaders();
        $device = "";
        $this->analytics->logEvent("link", $link, $identity, $device);
        $result = "";
        $qry_str = urldecode($link);
        $ch = curl_init();
        // Set query data here with the URL
        curl_setopt($ch, CURLOPT_URL, 'http://webbschema.mdh.se/' . $qry_str);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET');

        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, '30');

        if (curl_exec($ch) === false) {
            $result .= 'Curl error: ' . curl_error($ch);
        } else {
            $content = trim(curl_exec($ch));

            print $content;
        }
        curl_close($ch);
        return $result;
    }
}