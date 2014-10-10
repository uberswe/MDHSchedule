<?php
include_once 'settings.php';
if (!$COMMON->isServerRequest($POST, $FETCH, $echoVal)) {
    include_once 'header.php';
    ?>
    <div class="body">
        <?php
        if (isset($_GET['id'])) {
            $p = mysql_real_escape_string($_GET['id']);
            $courses = mysql_query("SELECT Posts.PostStartDate, Posts.PostEndDate, Posts.PostDescription, BookedRooms.RoomID FROM Posts INNER JOIN BookedRooms ON Posts.PostID = BookedRooms.PostID WHERE Posts.CourseID = '" . $p . "' ORDER BY Posts.PostStartDate ASC LIMIT 100") or die(mysql_error());
            if (mysql_num_rows($courses) > 0) {
                while ($data = mysql_fetch_array($courses)) {
                    ?>
                    <div class="resultRow">
                        <div class="PostDate">
                            <?php echo date("D jS M Y", strtotime($data['PostStartDate'])); ?>
                            <br/></div>
                        <div class="PostTime">
                            <?php echo date("H:i", strtotime($data['PostStartDate'])); ?>
                            - <?php echo date("H:i", strtotime($data['PostEndDate'])); ?>
                        </div>
                        <div class="PostDescription"><?php echo $data['PostDescription']; ?></div>
                        <div class="RoomID"><a
                                href="?map=<?php echo $data['RoomID']; ?>"><?php echo $data['RoomID']; ?></a></div>
                    </div>
                <?php
                }
            } else {
                echo 'No posts available for this course';
            }

        } else if (isset($_GET['map'])) {
            $mapurl = '';
            $mapratio = 1;
            $centerX = 0;
            $centerY = 0;
            $s = mysql_real_escape_string($_GET['map']);
            $findroom = mysql_query("SELECT * FROM RoomLocations WHERE RoomID = '" . $s . "' LIMIT 1");
            while ($roomdata = mysql_fetch_array($findroom)) {
                $mapid = str_replace('HD2', 'WEB', $roomdata['MapID']);
                $centerX = $roomdata['CenterX'];
                $centerY = $roomdata['CenterY'];
                $findmap = mysql_query("SELECT * FROM Maps WHERE MapID = '" . $mapid . "' LIMIT 1");
                while ($mapdata = mysql_fetch_array($findmap)) {
                    $mapurl = $mapdata['MapURL'];
                    $mapratio = $mapdata['Ratio'];
                }
            }
            if ($mapurl != '') {
                ?>

                <img src="<?php echo $mapurl; ?>" width="960px">
                <div
                    style="position: absolute; bottom:<?php echo (($centerY * $mapratio)) . 'px'; ?>; left:<?php echo (($centerX * $mapratio) - 10) . 'px'; ?>; width: 20px; height: 20px; background: #fe9300;"></div>
            <?php
            } else {
                echo 'No map available';
            }
        } else if (isset($_POST['search'])) {
            $s = mysql_real_escape_string($_POST['search']);
            $p = mysql_real_escape_string($_POST['period']);
            $courses = mysql_query("SELECT * FROM Courses WHERE CourseSeason = '" . $p . "' AND (CourseID LIKE '%" . $s . "%' OR CourseName LIKE '%" . $s . "%') ORDER BY CourseID ASC LIMIT 100") or die(mysql_error());
            $rooms = mysql_query("SELECT * FROM RoomLocations WHERE RoomID LIKE '%" . $s . "%' LIMIT 100") or die(mysql_error());
            echo '<h3>Courses</h3>';
            if (mysql_num_rows($courses) > 0) {
                while ($data = mysql_fetch_array($courses)) {
                    ?>
                    <div class="resultRow">
                        <div class="CourseID"><a
                                href="?id=<?php echo $data['CourseID']; ?>"><?php echo $data['CourseID']; ?></div>
                        <div class="CourseName"><?php echo $data['CourseName']; ?></div>
                        <div class="CourseSeason"><?php echo $data['CourseSeason']; ?></div>
                        <div class="CourseCode"><?php echo $data['CourseCode']; ?></a></div>
                    </div>
                <?php
                }
                if (mysql_num_rows($courses) == 100) {
                    ?>

                    <div class="resultRow">
                        Limited to 100 results. Please refine your search.
                    </div>
                <?php
                }
            } else {
                echo 'Nothing found, try again.';
            }
            echo '<h3>Rooms</h3>';
            if (mysql_num_rows($rooms) > 0) {
                while ($data = mysql_fetch_array($rooms)) {
                    ?>
                    <div class="resultRow">
                        <div class="RoomID"><a href="?map=<?php echo $data['RoomID']; ?>"><?php echo $data['RoomID']; ?>
                        </div>
                    </div>
                <?php
                }
                if (mysql_num_rows($rooms) == 100) {
                    ?>

                    <div class="resultRow">
                        Limited to 100 results. Please refine your search.
                    </div>
                <?php
                }
            } else {
                echo 'Nothing found, try again.';
            }
        } else {


            ?>
            <div class="heading2">
                <h2>Enter your search term, it can be either a course or a room.</h2>
            </div>
            <div class="searchform">

                <form method="post" action="">
                    <div class="searchdropdown">
                        <div class="dropdownbox">
                            <div class="ddbox selected">H14</div>
                            <div class="ddbox unselected">V15</div>
                            <div class="ddbox unselected">TEN</div>
                        </div>
                    </div>
                    <div class="searchbox">
                        <input type="text" name="search">
                    </div>
                    <div class="searchsubmit">
                        <input type="hidden" id="period" name="period" value="H14">
                        <input type="submit" value="Search">
                    </div>
                </form>
            </div>
        <?php
        }
        ?>
    </div>
    </div>

    <div class="dotted"></div>
    <div class="bottom">
        <div class="inner">
            <div class="row66"><p>This web app is developed and maintained by students at MDH. To see the official
                    schedule offered by the school please go to <a href="http://www.mdh.se/student/schema-terminstid">http://www.mdh.se/student/schema-terminstid</a>
                </p>
            </div>
            <div class="row33">
                <p><img src="theme/getmobileapp.png"></p>

                <p><a href="https://itunes.apple.com/us/app/mdh-schedule/id525266784?mt=8"><img src="theme/iphone.png"></a><a
                        href="https://play.google.com/store/apps/details?id=se.grupp12.mdhschedule"><img
                            src="theme/android.png"></a></p>
            </div>
        </div>
    </div>
    <?php
    include_once 'footer.php';
} else {
    echo $echoVal;
}
?>